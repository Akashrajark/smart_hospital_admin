part of 'patients_bloc.dart';

@immutable
sealed class PatientsState {}

final class PatientsInitialState extends PatientsState {}

final class PatientsLoadingState extends PatientsState {}

final class PatientsSuccessState extends PatientsState {}

final class PatientsGetSuccessState extends PatientsState {
  final List<Map<String, dynamic>> patients;
  final int patientCount;

  PatientsGetSuccessState({required this.patients, required this.patientCount});
}

final class PatientsFailureState extends PatientsState {
  final String message;

  PatientsFailureState({this.message = apiErrorMessage});
}
