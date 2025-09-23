import 'package:flutter/material.dart';
import 'package:hospital_admin/screens/doctors/doctor_detail_screen.dart';
import 'package:hospital_admin/screens/patients/patient_detail_screen.dart';
import '../../util/format_functions.dart';

class AppointmentDetailScreen extends StatelessWidget {
  final Map<String, dynamic> appointmentDetails;

  const AppointmentDetailScreen({super.key, required this.appointmentDetails});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appointment Details',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          PatientCard(patientDetails: appointmentDetails['patients']),
          SizedBox(height: 20),
          DoctorCard(doctorDetails: appointmentDetails['doctors']),
          SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Appointment Details',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey.shade300),
                  Text('Date Time', style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 5),
                  Text(
                    formatDateTime(appointmentDetails['appointment_date']),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Divider(color: Colors.grey.shade300),
                  Text('Reason for Visit', style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 5),
                  Text(
                    formatValue(appointmentDetails['reason']),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),

          if (['prescribed', 'submitted', 'reviewed'].contains(appointmentDetails['status']))
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prescription Details',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    Divider(color: Colors.grey.shade300),
                    Text('Prescription', style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 5),
                    Text(
                      formatValue(appointmentDetails['prescription']),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Divider(color: Colors.grey.shade300),
                    Text('Xray Report', style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 5),
                    Text(
                      formatValue(appointmentDetails['xray_needed']),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          SizedBox(height: 20),
          if (['submitted', 'reviewed'].contains(appointmentDetails['status']))
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Xray',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    if (appointmentDetails['xray_url'] != null)
                      InkWell(
                        borderRadius: BorderRadius.circular(8.0),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => Scaffold(
                              appBar: AppBar(),
                              body: InteractiveViewer(
                                child: Center(child: Image.network(appointmentDetails['xray_url'])),
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            appointmentDetails['xray_url'],
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                    Text('Xray Report', style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 5),
                    Text(
                      formatValue(appointmentDetails['xray_report']),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          SizedBox(height: 20),

          if (appointmentDetails['status'] == 'reviewed')
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Doctor Report',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 10),

                    Text(
                      formatValue(appointmentDetails['doctor_review']),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class PatientCard extends StatelessWidget {
  const PatientCard({super.key, required this.patientDetails});

  final Map<String, dynamic> patientDetails;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PatientDetailScreen(patient: patientDetails)),
          );
        },
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: patientDetails['image_url'] != null
                    ? Image.network(
                        patientDetails['image_url'],
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8.0)),
                          child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
                        ),
                      )
                    : Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8.0)),
                        child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
                      ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "#${patientDetails['id']}",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      formatValue(patientDetails['full_name']),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      formatValue(patientDetails['email']),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  const DoctorCard({super.key, required this.doctorDetails});

  final Map<String, dynamic> doctorDetails;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorDetailScreen(doctor: doctorDetails)));
        },
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 10,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: doctorDetails['image_url'] != null
                    ? Image.network(
                        doctorDetails['image_url'],
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8.0)),
                          child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
                        ),
                      )
                    : Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8.0)),
                        child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
                      ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "#${doctorDetails['id']}",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      formatValue(doctorDetails['full_name']),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      formatValue(doctorDetails['email']),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
