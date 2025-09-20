import 'patient.dart';
import 'doctor.dart';

class Appointment {
  final String id;
  final DateTime dateTime;
  final Patient patient;
  final Doctor doctor;
  final String status;
  final String notes;

  const Appointment({
    required this.id,
    required this.dateTime,
    required this.patient,
    required this.doctor,
    required this.status,
    required this.notes,
  });

  static List<Appointment> getDummyAppointments() {
    final patients = Patient.getDummyPatients();
    final doctors = Doctor.getDummyDoctors();

    return [
      Appointment(
        id: '1',
        dateTime: DateTime.now().add(const Duration(days: 1)),
        patient: patients[0],
        doctor: doctors[0],
        status: 'Scheduled',
        notes: 'Regular cardiac checkup',
      ),
      Appointment(
        id: '2',
        dateTime: DateTime.now().add(const Duration(days: 2)),
        patient: patients[1],
        doctor: doctors[1],
        status: 'Scheduled',
        notes: 'Follow-up for knee injury',
      ),
      Appointment(
        id: '3',
        dateTime: DateTime.now().add(const Duration(days: 3)),
        patient: patients[2],
        doctor: doctors[2],
        status: 'Confirmed',
        notes: 'Blood pressure monitoring',
      ),
      Appointment(
        id: '4',
        dateTime: DateTime.now().add(const Duration(days: 5)),
        patient: patients[3],
        doctor: doctors[3],
        status: 'Scheduled',
        notes: 'Prenatal checkup',
      ),
      Appointment(
        id: '5',
        dateTime: DateTime.now().subtract(const Duration(days: 1)),
        patient: patients[0],
        doctor: doctors[4],
        status: 'Completed',
        notes: 'Neurological evaluation',
      ),
    ];
  }
}
