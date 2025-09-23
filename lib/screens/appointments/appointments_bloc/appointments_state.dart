part of 'appointments_bloc.dart';

@immutable
sealed class AppointmentsState {}

final class AppointmentsInitialState extends AppointmentsState {}

final class AppointmentsLoadingState extends AppointmentsState {}

final class AppointmentsSuccessState extends AppointmentsState {}

final class AppointmentsGetSuccessState extends AppointmentsState {
  final List<Map<String, dynamic>> appointments;
  final int appointmentCount;

  AppointmentsGetSuccessState({required this.appointments, required this.appointmentCount});
}

final class AppointmentsFailureState extends AppointmentsState {
  final String message;

  AppointmentsFailureState({this.message = apiErrorMessage});
}
