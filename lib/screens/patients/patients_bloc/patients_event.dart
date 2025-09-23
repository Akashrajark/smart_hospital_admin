part of 'patients_bloc.dart';

@immutable
sealed class PatientsEvent {}

class GetAllPatientsEvent extends PatientsEvent {
  final Map<String, dynamic> params;

  GetAllPatientsEvent({required this.params});
}
