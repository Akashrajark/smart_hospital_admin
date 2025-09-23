import 'package:bloc/bloc.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../value/strings.dart';
part 'appointments_event.dart';
part 'appointments_state.dart';

class AppointmentsBloc extends Bloc<AppointmentsEvent, AppointmentsState> {
  AppointmentsBloc() : super(AppointmentsInitialState()) {
    on<AppointmentsEvent>((event, emit) async {
      try {
        emit(AppointmentsLoadingState());
        SupabaseQueryBuilder table = Supabase.instance.client.from('appointments');

        if (event is GetAllAppointmentsEvent) {
          PostgrestFilterBuilder<List<Map<String, dynamic>>> query = table.select('*, patients(*), doctors(*)');

          if (event.params['query'] != null) {
            // Check if the query is a string and can be parsed to an int

            // If it's not a valid int, use it for name query
            query = query.or(
              'full_name.ilike.%${event.params['query']}%, specialization.ilike.%${event.params['query']}%',
            );
          }
          if (event.params['selected_status'] != null && event.params['selected_status'] != 'All') {
            query = query.eq('status', event.params['selected_status'].toString().toLowerCase());
          }

          List<Map<String, dynamic>> result;
          int? count;
          if (event.params['limit'] != null) {
            result = await query.order('appointment_date', ascending: false).limit(event.params['limit']);
          } else {
            result = await query
                .order('appointment_date', ascending: false)
                .range(event.params['range_start'], event.params['range_end']);
            count = (await query.count(CountOption.exact)).count;
          }

          emit(AppointmentsGetSuccessState(appointments: result, appointmentCount: count ?? 0));
        }
      } catch (e, s) {
        Logger().e('$e\n$s');
        emit(AppointmentsFailureState(message: apiErrorMessage));
      }
    });
  }
}
