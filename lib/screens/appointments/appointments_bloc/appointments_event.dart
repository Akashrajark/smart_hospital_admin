part of 'appointments_bloc.dart';

@immutable
sealed class AppointmentsEvent {}

class GetAllAppointmentsEvent extends AppointmentsEvent {
  final Map<String, dynamic> params;

  GetAllAppointmentsEvent({required this.params});
}
