import 'package:bloc/bloc.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../value/strings.dart';

part 'patients_event.dart';
part 'patients_state.dart';

class PatientsBloc extends Bloc<PatientsEvent, PatientsState> {
  PatientsBloc() : super(PatientsInitialState()) {
    on<PatientsEvent>((event, emit) async {
      try {
        emit(PatientsLoadingState());
        SupabaseQueryBuilder table = Supabase.instance.client.from('patients');

        if (event is GetAllPatientsEvent) {
          PostgrestFilterBuilder<List<Map<String, dynamic>>> query = table.select('*)');

          if (event.params['query'] != null) {
            // Check if the query is a string and can be parsed to an int

            // If it's not a valid int, use it for name query
            query = query.or('full_name.ilike.%${event.params['query']}%, phone.ilike.%${event.params['query']}%');
          }

          List<Map<String, dynamic>> result;
          int? count;
          if (event.params['limit'] != null) {
            result = await query.order('created_at', ascending: false).limit(event.params['limit']);
          } else {
            result = await query
                .order('created_at', ascending: false)
                .range(event.params['range_start'], event.params['range_end']);
            count = (await query.count(CountOption.exact)).count;
          }

          emit(PatientsGetSuccessState(patients: result, patientCount: count ?? 0));
        }
      } catch (e, s) {
        Logger().e('$e\n$s');
        emit(PatientsFailureState(message: apiErrorMessage));
      }
    });
  }
}
