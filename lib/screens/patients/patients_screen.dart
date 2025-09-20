import 'package:flutter/material.dart';
import '../../models/patient.dart';
import '../../common_widgets/patient_card.dart';
import 'patient_detail_screen.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  late List<Patient> patients;
  List<Patient> filteredPatients = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    patients = Patient.getDummyPatients();
    filteredPatients = patients;
    _searchController.addListener(_filterPatients);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPatients() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredPatients = patients.where((patient) {
        return patient.name.toLowerCase().contains(query) ||
            patient.email.toLowerCase().contains(query) ||
            patient.age.toString().contains(query);
      }).toList();
    });
  }

  void _navigateToPatientDetail(Patient patient) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PatientDetailScreen(patient: patient)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          //   child: CustomSearchFilter(theme: Theme.of(context), searchController: _searchController),
          // ),
          Expanded(
            child: filteredPatients.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        const SizedBox(height: 16),
                        Text(
                          'No patients found',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredPatients.length,
                    itemBuilder: (context, index) {
                      final patient = filteredPatients[index];
                      return PatientCard(patient: patient, onTap: () => _navigateToPatientDetail(patient));
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
