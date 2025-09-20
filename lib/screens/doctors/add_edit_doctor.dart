import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hospital_admin/common_widgets/custom_alert_dialog.dart';
import 'package:hospital_admin/common_widgets/custom_button.dart';
import 'package:hospital_admin/common_widgets/custom_date_picker.dart';
import 'package:hospital_admin/common_widgets/custom_image_picker_button.dart';
import 'package:hospital_admin/common_widgets/custom_radio_button.dart';
import 'package:hospital_admin/common_widgets/custom_text_form_field.dart';
import 'package:hospital_admin/util/value_validators.dart';

import 'doctors_bloc/doctors_bloc.dart';

class AddEditDoctorScreen extends StatefulWidget {
  final Map<String, dynamic>? doctorData;
  const AddEditDoctorScreen({super.key, this.doctorData});

  @override
  State<AddEditDoctorScreen> createState() => _AddEditDoctorScreenState();
}

class _AddEditDoctorScreenState extends State<AddEditDoctorScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController specializationController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController qualificationController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String gender = 'male';
  DateTime? dob;

  File? doctorProfileImage;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.doctorData != null) {
      fullNameController.text = widget.doctorData!['full_name'] ?? '';
      emailController.text = widget.doctorData!['email'] ?? '';
      phoneController.text = widget.doctorData!['phone'] ?? '';
      specializationController.text = widget.doctorData!['specialization'] ?? '';
      experienceController.text = widget.doctorData!['experience']?.toString() ?? '';
      qualificationController.text = widget.doctorData!['qualification'] ?? '';
      gender = widget.doctorData!['gender'] ?? 'male';
      dob = DateTime.tryParse(widget.doctorData!['dob'] ?? '');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorsBloc, DoctorsState>(
      listener: (context, state) {
        if (state is DoctorsSuccessState) {
          Navigator.pop(context);
        }
        if (state is DoctorsFailureState) {
          CustomAlertDialog(title: "Failed", description: state.message, primaryButton: "Ok");
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(widget.doctorData == null ? 'Add Doctor' : 'Edit Doctor')),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20.0),
              children: [
                Text("Doctor Profile Image", style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 5),
                CustomImagePickerButton(
                  selectedImage: widget.doctorData?['image_url'],
                  onPick: (pick) {
                    doctorProfileImage = pick;
                  },
                ),
                const SizedBox(height: 15),
                Text("Email", style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 5),
                CustomTextFormField(labelText: "Email", controller: emailController, validator: emailValidator),
                const SizedBox(height: 15),
                Text("Password", style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 5),
                CustomTextFormField(
                  labelText: "Password",
                  controller: passwordController,
                  validator: passwordValidator,
                ),
                const SizedBox(height: 15),
                Text("Full Name", style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 5),
                CustomTextFormField(
                  labelText: "Full Name",
                  controller: fullNameController,
                  validator: alphabeticWithSpaceValidator,
                ),
                const SizedBox(height: 15),
                Text("Phone", style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 5),
                CustomTextFormField(labelText: "Phone", controller: phoneController, validator: phoneNumberValidator),
                const SizedBox(height: 15),
                Text("Gender", style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 5),
                Row(
                  children: [
                    CustomRadioButton(
                      isChecked: gender == 'male',
                      label: "Male",
                      onPressed: () {
                        setState(() {
                          gender = 'male';
                        });
                      },
                    ),
                    CustomRadioButton(
                      isChecked: gender == 'female',
                      label: "Female",
                      onPressed: () {
                        setState(() {
                          gender = 'female';
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text("Date of Birth", style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 5),
                CustomDatePicker(
                  isRequired: true,
                  onPick: (pick) {
                    dob = pick;
                  },
                ),
                const SizedBox(height: 15),
                Text("Specialization", style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 5),
                CustomTextFormField(
                  labelText: "Specialization",
                  controller: specializationController,
                  validator: alphabeticWithSpaceValidator,
                ),
                const SizedBox(height: 15),
                Text("Qualification", style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 5),
                CustomTextFormField(
                  labelText: "Qualification",
                  controller: qualificationController,
                  validator: alphabeticWithSpaceValidator,
                ),
                const SizedBox(height: 15),
                Text("Experience (years)", style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 5),
                CustomTextFormField(
                  labelText: "Experience",
                  controller: experienceController,
                  validator: numericValidator,
                ),
                const SizedBox(height: 15),
                SafeArea(
                  child: CustomButton(
                    isLoading: state is DoctorsLoadingState,
                    label: 'Save',
                    inverse: true,
                    onPressed: () {
                      if (_formKey.currentState!.validate() && doctorProfileImage != null) {
                        Map<String, dynamic> doctorData = {
                          'full_name': fullNameController.text.trim(),
                          'email': emailController.text.trim(),
                          'phone': phoneController.text.trim(),
                          'gender': gender,
                          'dob': dob?.toIso8601String(),
                          'specialization': specializationController.text.trim(),
                          'qualification': qualificationController.text.trim(),
                          'experience': int.tryParse(experienceController.text.trim()) ?? 0,
                          'password': passwordController.text.trim(),
                        };
                        if (doctorProfileImage != null) {
                          doctorData['image'] = doctorProfileImage;
                          doctorData['image_name'] = doctorProfileImage!.path;
                        }
                        if (widget.doctorData != null) {
                          BlocProvider.of<DoctorsBloc>(
                            context,
                          ).add(EditDoctorEvent(doctorDetails: doctorData, doctorId: widget.doctorData!['user_id']));
                        } else {
                          BlocProvider.of<DoctorsBloc>(context).add(AddDoctorEvent(doctorDetails: doctorData));
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
