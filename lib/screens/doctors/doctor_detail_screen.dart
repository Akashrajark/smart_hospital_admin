import 'package:flutter/material.dart';
import 'package:hospital_admin/common_widgets/custom_button.dart';
import 'package:hospital_admin/util/format_functions.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorDetailScreen extends StatelessWidget {
  final Map<String, dynamic> doctor;

  const DoctorDetailScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Doctor Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(doctor['image_url'], height: 200, width: 200, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ID: #${formatValue(doctor['id'])}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.grey, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      formatValue(doctor['full_name']),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Professional Information',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(context, Icons.date_range, 'Date of Birth', formatDate(doctor['dob'])),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      context,
                      Icons.local_hospital,
                      'Specialization',
                      formatValue(doctor['specialization']),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(context, Icons.business, 'Qualification', formatValue(doctor['qualification'])),
                    const SizedBox(height: 12),
                    _buildInfoRow(context, Icons.timeline, 'Experience', '${formatValue(doctor['experience'])} years'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Information',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(context, Icons.email, 'Email', formatValue(doctor['email'])),
                    const SizedBox(height: 12),
                    _buildInfoRow(context, Icons.phone, 'Phone', formatValue(doctor['phone'])),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            CustomButton(
              label: 'Contact',
              inverse: true,
              onPressed: () async {
                final phone = doctor['phone'];
                if (phone != null && phone.toString().isNotEmpty) {
                  final Uri url = Uri(scheme: 'tel', path: phone.toString());

                  try {
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('Could not launch phone dialer')));
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                } else {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Phone number not available')));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(value, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }
}
