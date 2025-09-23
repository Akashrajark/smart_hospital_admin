import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital_admin/screens/appointments/appointment_detail_screen.dart';
import 'package:logger/web.dart';
import '../../common_widgets/custom_alert_dialog.dart';
import '../../common_widgets/appointment_tile.dart';
import 'appointments_bloc/appointments_bloc.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  List<Map<String, dynamic>> appointments = [];
  final AppointmentsBloc _appointmentsBloc = AppointmentsBloc();

  Map<String, dynamic> params = {'query': null, 'range_start': 0, 'range_end': 24, 'selected_status': 'All'};

  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  int _totalAppointmentsCount = 0;
  final int _itemsPerPage = 25;

  @override
  void initState() {
    _setupScrollListener();
    getAppointments();
    super.initState();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        // Load more data when user is 200 pixels from the bottom
        _loadMoreProjects();
      }
    });
  }

  void getAppointments({bool isLoadMore = false}) {
    if (!isLoadMore) {
      // Reset pagination for new search/filter
      params['range_start'] = 0;
      params['range_end'] = _itemsPerPage - 1;
      _hasMoreData = true;
    }
    _appointmentsBloc.add(GetAllAppointmentsEvent(params: params));
  }

  void _loadMoreProjects() {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    // Calculate next range
    params['range_start'] = appointments.length;
    params['range_end'] = appointments.length + _itemsPerPage - 1;

    _appointmentsBloc.add(GetAllAppointmentsEvent(params: params));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _appointmentsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocProvider.value(
      value: _appointmentsBloc,
      child: BlocConsumer<AppointmentsBloc, AppointmentsState>(
        listener: (context, state) {
          if (state is AppointmentsFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getAppointments();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is AppointmentsGetSuccessState) {
            setState(() {
              if (_isLoadingMore) {
                // Append new data to existing list
                appointments.addAll(state.appointments);
                _isLoadingMore = false;

                // Check if we have more data to load
                _hasMoreData = state.appointments.length == _itemsPerPage;
              } else {
                // Replace list for new search/filter
                appointments = state.appointments;
                _hasMoreData = state.appointments.length == _itemsPerPage;
              }
              _totalAppointmentsCount = state.appointmentCount;
            });
            Logger().w("Appointments loaded: ${state.appointments.length}, Total: $_totalAppointmentsCount");
          } else if (state is AppointmentsSuccessState) {
            getAppointments();
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              controller: _scrollController,
              children: [
                Text("Appointments List", style: Theme.of(context).textTheme.headlineSmall),

                // const SizedBox(height: 16),
                // CustomSearchFilter(
                //   onSearch: (search) {
                //     params['query'] = search.trim();
                //     getAppointments();
                //   },
                // ),
                SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...['All', 'booked', 'prescribed', 'submitted', 'reviewed'].map((filter) {
                        final isSelected = params['selected_status'] == filter;
                        Color chipColor;

                        switch (filter.toLowerCase()) {
                          case 'booked':
                            chipColor = Colors.teal;
                            break;
                          case 'prescribed':
                            chipColor = Colors.orange;
                            break;
                          case 'submitted':
                            chipColor = Colors.purple;
                            break;
                          case 'reviewed':
                            chipColor = Colors.green;
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
                                  params['selected_status'] = filter;
                                });
                                getAppointments();
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? LinearGradient(colors: [chipColor, chipColor.withOpacity(0.8)])
                                      : LinearGradient(
                                          colors: [chipColor.withOpacity(0.1), chipColor.withOpacity(0.05)],
                                        ),
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
                const SizedBox(height: 16),
                if (state is AppointmentsLoadingState && !_isLoadingMore)
                  Center(child: CircularProgressIndicator())
                else if (appointments.isEmpty)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
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
                else
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => AppointmentTile(
                      appointmentDetail: appointments[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppointmentDetailScreen(appointmentDetails: appointments[index]),
                          ),
                        );
                      },
                    ),
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemCount: appointments.length,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
