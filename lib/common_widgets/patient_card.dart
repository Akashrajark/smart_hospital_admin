import 'package:flutter/material.dart';
import 'package:hospital_admin/util/format_functions.dart';

class PatientCard extends StatelessWidget {
  final Map<String, dynamic> patientDetails;
  final VoidCallback onTap;

  const PatientCard({super.key, required this.patientDetails, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Colors.black.withAlpha(20)),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: patientDetails['image_url'] != null && patientDetails['image_url'].toString().isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.network(
                    patientDetails['image_url'],
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          formatValue(patientDetails['full_name'])[0].toUpperCase(),
                          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                )
              : Center(
                  child: Text(
                    formatValue(patientDetails['full_name'])[0].toUpperCase(),
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold),
                  ),
                ),
        ),
        title: Text(formatValue(patientDetails['full_name']), style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phone: ${formatValue(patientDetails['phone'])}'),
            Text(
              formatValue(patientDetails['email']),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
