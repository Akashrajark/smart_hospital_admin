import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';
import '../../common_widgets/custom_alert_dialog.dart';
import '../../common_widgets/custom_seearch_filter.dart';
import '../../common_widgets/patient_card.dart';
import 'patient_detail_screen.dart';
import 'patients_bloc/patients_bloc.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({super.key});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  List<Map<String, dynamic>> patients = [];
  final PatientsBloc _patientsBloc = PatientsBloc();

  Map<String, dynamic> params = {'query': null, 'range_start': 0, 'range_end': 24};

  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  int _totalPatientsCount = 0;
  final int _itemsPerPage = 25;

  @override
  void initState() {
    _setupScrollListener();
    getPatients();
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

  void getPatients({bool isLoadMore = false}) {
    if (!isLoadMore) {
      // Reset pagination for new search/filter
      params['range_start'] = 0;
      params['range_end'] = _itemsPerPage - 1;
      _hasMoreData = true;
    }
    _patientsBloc.add(GetAllPatientsEvent(params: params));
  }

  void _loadMoreProjects() {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    // Calculate next range
    params['range_start'] = patients.length;
    params['range_end'] = patients.length + _itemsPerPage - 1;

    _patientsBloc.add(GetAllPatientsEvent(params: params));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _patientsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _patientsBloc,
      child: BlocConsumer<PatientsBloc, PatientsState>(
        listener: (context, state) {
          if (state is PatientsFailureState) {
            showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                title: 'Failure',
                description: state.message,
                primaryButton: 'Try Again',
                onPrimaryPressed: () {
                  getPatients();
                  Navigator.pop(context);
                },
              ),
            );
          } else if (state is PatientsGetSuccessState) {
            setState(() {
              if (_isLoadingMore) {
                // Append new data to existing list
                patients.addAll(state.patients);
                _isLoadingMore = false;

                // Check if we have more data to load
                _hasMoreData = state.patients.length == _itemsPerPage;
              } else {
                // Replace list for new search/filter
                patients = state.patients;
                _hasMoreData = state.patients.length == _itemsPerPage;
              }
              _totalPatientsCount = state.patientCount;
            });
            Logger().w("Patients loaded: ${state.patients.length}, Total: $_totalPatientsCount");
          } else if (state is PatientsSuccessState) {
            getPatients();
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              controller: _scrollController,
              children: [
                Text("Patients List", style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                CustomSearchFilter(
                  onSearch: (search) {
                    params['query'] = search.trim();
                    getPatients();
                  },
                ),
                const SizedBox(height: 16),
                if (state is PatientsLoadingState && !_isLoadingMore)
                  Center(child: CircularProgressIndicator())
                else if (patients.isEmpty)
                  Center(
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
                else
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => PatientCard(
                      patientDetails: patients[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PatientDetailScreen(patient: patients[index])),
                        );
                      },
                    ),
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemCount: patients.length,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
