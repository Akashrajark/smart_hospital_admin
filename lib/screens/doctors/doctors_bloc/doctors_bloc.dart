import 'package:bloc/bloc.dart';
import 'package:hospital_admin/util/file_upload.dart';
import 'package:logger/web.dart';
import 'package:meta/meta.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../value/strings.dart';

part 'doctors_event.dart';
part 'doctors_state.dart';

class DoctorsBloc extends Bloc<DoctorsEvent, DoctorsState> {
  DoctorsBloc() : super(DoctorsInitialState()) {
    on<DoctorsEvent>((event, emit) async {
      try {
        emit(DoctorsLoadingState());
        SupabaseQueryBuilder table = Supabase.instance.client.from('doctors');

        if (event is GetAllDoctorsEvent) {
          PostgrestFilterBuilder<List<Map<String, dynamic>>> query = table.select('*');

          if (event.params['query'] != null) {
            // Check if the query is a string and can be parsed to an int

            // If it's not a valid int, use it for name query
            query = query.or('full_name.ilike.%${event.params['query']}%, phone.ilike.%${event.params['query']}%');
          }
          if (event.params['status'] != null && event.params['status'].toString().isNotEmpty) {
            query = query.eq('status', event.params['status']);
          }

          List<Map<String, dynamic>> result;
          int? count;
          if (event.params['limit'] != null) {
            result = await query.order('id', ascending: false).limit(event.params['limit']);
          } else {
            result = await query
                .order('id', ascending: false)
                .range(event.params['range_start'], event.params['range_end']);
            count = (await query.count(CountOption.exact)).count;
          }

          emit(DoctorsGetSuccessState(doctors: result, doctorCount: count ?? 0));
        } else if (event is AddDoctorEvent) {
          final response = await Supabase.instance.client.auth.admin.createUser(
            AdminUserAttributes(
              email: event.doctorDetails['email'],
              password: event.doctorDetails['password'],
              appMetadata: {'role': 'doctor'},
              emailConfirm: true,
            ),
          );
          if (response.user != null) {
            event.doctorDetails['user_id'] = response.user!.id;
          }

          event.doctorDetails['image_url'] = await uploadFile(
            'profile_photo',
            event.doctorDetails['image'],
            event.doctorDetails['image_name'],
          );
          event.doctorDetails.remove('image');
          event.doctorDetails.remove('image_name');
          event.doctorDetails.remove('password');
          await table.insert(event.doctorDetails);
          emit(DoctorsSuccessState());
        } else if (event is EditDoctorEvent) {
          if (event.doctorDetails['password'] != null &&
              event.doctorDetails['password'].toString().isNotEmpty &&
              event.doctorDetails['email'] != null &&
              event.doctorDetails['email'].toString().isNotEmpty) {
            Supabase.instance.client.auth.admin.updateUserById(
              event.doctorId,
              attributes: AdminUserAttributes(
                email: event.doctorDetails['email'],
                password: event.doctorDetails['password'],
                appMetadata: {'role': 'doctor'},
              ),
            );
          }

          if (event.doctorDetails['image'] != null) {
            event.doctorDetails['image_url'] = await uploadFile(
              'profile_photo',
              event.doctorDetails['image'],
              event.doctorDetails['image_name'],
            );
            event.doctorDetails.remove('image');
            event.doctorDetails.remove('image_name');
          }
          event.doctorDetails.remove('password');
          await table.update(event.doctorDetails).eq('user_id', event.doctorId);
          emit(DoctorsSuccessState());
        } else if (event is BlockUnblockDoctorEvent) {
          if (event.status == 'blocked') {
            await Supabase.instance.client.auth.admin.updateUserById(
              event.doctorId,
              attributes: AdminUserAttributes(banDuration: '876000h'),
            );
            await table.update({'status': 'blocked'}).eq('user_id', event.doctorId);
          } else {
            await Supabase.instance.client.auth.admin.updateUserById(
              event.doctorId,
              attributes: AdminUserAttributes(banDuration: 'none'),
            );
            await table.update({'status': 'active'}).eq('user_id', event.doctorId);
          }
          emit(DoctorsSuccessState());
        }
      } catch (e, s) {
        Logger().e('$e\n$s');
        // emit(DoctorsFailureState(message: apiErrorMessage));
        emit(DoctorsFailureState(message: e.toString()));
      }
    });
  }
}
