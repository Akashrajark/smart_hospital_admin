import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital_admin/common_widgets/custom_seearch_filter.dart';
import 'package:hospital_admin/screens/doctors/add_edit_doctor.dart';
import 'package:hospital_admin/screens/doctors/doctor_detail_screen.dart';
import 'package:hospital_admin/screens/doctors/doctors_bloc/doctors_bloc.dart';
import 'package:hospital_admin/util/format_functions.dart';
import 'package:logger/web.dart';
import '../../common_widgets/custom_alert_dialog.dart';
import '../../common_widgets/custom_button.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  List<Map<String, dynamic>> doctors = [];
  final DoctorsBloc _doctorsBloc = DoctorsBloc();
  String status = 'active';

  Map<String, dynamic> params = {'query': null, 'range_start': 0, 'range_end': 24, 'status': 'active'};

  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  int _totalDoctorsCount = 0;
  final int _itemsPerPage = 25;

  @override
  void initState() {
    _setupScrollListener();
    getDoctors();
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

  void getDoctors({bool isLoadMore = false}) {
    if (!isLoadMore) {
      // Reset pagination for new search/filter
      params['range_start'] = 0;
      params['range_end'] = _itemsPerPage - 1;
      _hasMoreData = true;
    }
    _doctorsBloc.add(GetAllDoctorsEvent(params: params));
  }

  void _loadMoreProjects() {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    // Calculate next range
    params['range_start'] = doctors.length;
    params['range_end'] = doctors.length + _itemsPerPage - 1;

    _doctorsBloc.add(GetAllDoctorsEvent(params: params));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _doctorsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _doctorsBloc,
      child: BlocConsumer<DoctorsBloc, DoctorsState>(
        listener: (context, state) {
          if (state is DoctorsFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getDoctors();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is DoctorsGetSuccessState) {
            setState(() {
              if (_isLoadingMore) {
                // Append new data to existing list
                doctors.addAll(state.doctors);
                _isLoadingMore = false;

                // Check if we have more data to load
                _hasMoreData = state.doctors.length == _itemsPerPage;
              } else {
                // Replace list for new search/filter
                doctors = state.doctors;
                _hasMoreData = state.doctors.length == _itemsPerPage;
              }
              _totalDoctorsCount = state.doctorCount;
            });
            Logger().w("Doctors loaded: ${state.doctors.length}, Total: $_totalDoctorsCount");
          } else if (state is DoctorsSuccessState) {
            getDoctors();
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              controller: _scrollController,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Doctors List", style: Theme.of(context).textTheme.headlineSmall),
                    CustomButton(
                      label: 'Add',
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      iconData: Icons.add,
                      backGroundColor: Colors.white,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BlocProvider.value(value: _doctorsBloc, child: const AddEditDoctorScreen()),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomSearchFilter(
                  onSearch: (search) {
                    params['query'] = search;
                    getDoctors();
                  },
                  onFilter: () {},
                ),
                const SizedBox(height: 16),
                CupertinoSlidingSegmentedControl(
                  groupValue: status,
                  children: {'active': Text('Active '), 'blocked': Text('Blocked')},
                  onValueChanged: (value) {
                    setState(() {
                      status = value!;
                      params['status'] = value;
                    });
                    getDoctors();
                  },
                ),
                const SizedBox(height: 16),
                if (state is DoctorsLoadingState && !_isLoadingMore)
                  Center(child: CircularProgressIndicator())
                else if (doctors.isEmpty)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        const SizedBox(height: 16),
                        Text(
                          'No doctors found',
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
                    itemBuilder: (context, index) => CustomDoctorCard(
                      doctorDetails: doctors[index],
                      onEdit: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: _doctorsBloc,
                              child: AddEditDoctorScreen(doctorData: doctors[index]),
                            ),
                          ),
                        );
                      },
                      onblock: () {
                        final String action = doctors[index]['status'] == 'blocked' ? 'Unblock' : 'Block';
                        showDialog(
                          context: context,
                          builder: (context) => CustomAlertDialog(
                            title: '$action Doctor?',
                            description: 'Are you sure you want to $action this doctor?',
                            primaryButton: action,
                            onPrimaryPressed: () {
                              _doctorsBloc.add(
                                BlockUnblockDoctorEvent(
                                  doctorId: doctors[index]['user_id'],
                                  status: doctors[index]['status'] == 'blocked' ? 'active' : 'blocked',
                                ),
                              );
                              Navigator.pop(context);
                            },
                            secondaryButton: 'Cancel',
                          ),
                        );
                      },
                    ),
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemCount: doctors.length,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CustomDoctorCard extends StatelessWidget {
  final Map<String, dynamic>? doctorDetails;
  final Function() onEdit, onblock;
  const CustomDoctorCard({super.key, this.doctorDetails, required this.onEdit, required this.onblock});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: Colors.black.withAlpha(20)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatValue(doctorDetails?['full_name']),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "#${doctorDetails?['id']}",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: Colors.grey, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            Divider(color: Colors.grey.withAlpha(50), thickness: 1, height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(doctorDetails?['image_url'], height: 100, width: 100, fit: BoxFit.cover),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatValue(doctorDetails?['email']),
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        formatValue(doctorDetails?['specialization']),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(color: Colors.grey.withAlpha(50), thickness: 1, height: 20),
            CustomButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoctorDetailScreen(doctor: doctorDetails!)),
                );
              },
              label: "View Details",
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              iconData: Icons.arrow_forward_ios_rounded,
              backGroundColor: Colors.white,
              color: Colors.blue,
              outlineColor: Colors.blue,
            ),
            SizedBox(height: 10),
            Row(
              spacing: 15,
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onEdit,
                    label: Text("Edit", style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.orange)),
                    icon: Icon(Icons.edit, color: Colors.orange),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.orange.withAlpha(100), width: 2),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onblock,
                    label: Text(
                      doctorDetails?['status'] == 'blocked' ? "Unblock" : "Block",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.red),
                    ),
                    icon: Icon(Icons.delete, color: Colors.red),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.red.withAlpha(100), width: 2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
