import 'package:flutter/material.dart';
import '../../models/appointment.dart';
import '../../common_widgets/appointment_tile.dart';
import 'appointment_detail_screen.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  late List<Appointment> appointments;
  List<Appointment> filteredAppointments = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    appointments = Appointment.getDummyAppointments();
    filteredAppointments = appointments;
    _searchController.addListener(_filterAppointments);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterAppointments() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredAppointments = appointments.where((appointment) {
        final matchesSearch =
            appointment.patient.name.toLowerCase().contains(query) ||
            appointment.doctor.name.toLowerCase().contains(query) ||
            appointment.status.toLowerCase().contains(query);

        final matchesFilter =
            _selectedFilter == 'All' || appointment.status.toLowerCase() == _selectedFilter.toLowerCase();

        return matchesSearch && matchesFilter;
      }).toList();
    });
  }

  void _navigateToAppointmentDetail(Appointment appointment) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentDetailScreen(appointment: appointment)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface.withOpacity(0.95),
      body: Column(
        children: [
          // Modern Header Section
          Column(
            children: [
              // Search Bar with Modern Design
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              //   child: CustomSearchFilter(theme: theme, searchController: _searchController),
              // ),

              // Modern Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 20),
                    ...['All', 'Scheduled', 'Confirmed', 'Completed', 'Cancelled'].map((filter) {
                      final isSelected = _selectedFilter == filter;
                      Color chipColor;

                      switch (filter.toLowerCase()) {
                        case 'scheduled':
                          chipColor = Colors.orange;
                          break;
                        case 'confirmed':
                          chipColor = Colors.blue;
                          break;
                        case 'completed':
                          chipColor = Colors.green;
                          break;
                        case 'cancelled':
                          chipColor = Colors.red;
                          break;
                        default:
                          chipColor = theme.colorScheme.primary;
                      }

                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(16),
                          elevation: isSelected ? 4 : 0,
                          shadowColor: chipColor.withOpacity(0.3),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedFilter = filter;
                              });
                              _filterAppointments();
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? LinearGradient(colors: [chipColor, chipColor.withOpacity(0.8)])
                                    : LinearGradient(colors: [chipColor.withOpacity(0.1), chipColor.withOpacity(0.05)]),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected ? chipColor.withOpacity(0.3) : chipColor.withOpacity(0.2),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (filter != 'All') ...[
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: isSelected ? Colors.white : chipColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  Text(
                                    filter,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: isSelected ? Colors.white : chipColor,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Expanded(
            child: filteredAppointments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No appointments found',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredAppointments.length,
                    itemBuilder: (context, index) {
                      final appointment = filteredAppointments[index];
                      return AppointmentTile(
                        appointment: appointment,
                        onTap: () => _navigateToAppointmentDetail(appointment),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
