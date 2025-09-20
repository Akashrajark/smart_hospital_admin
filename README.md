# hospital_admin

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Flutter Admin Panel App – Prompt for Copilot/Claude

You are an AI coding assistant. I want you to generate a **Flutter app** with **Material 3 expressive UI**, structured with **class-based widgets (not functions)**, and each **screen/widget should be in its own file** for maintainability.  

The app is an **Admin Panel** with the following requirements:

---

## Structure

- **Language/Framework:** Dart + Flutter (latest stable).
- **UI:** Material 3 expressive UI.
- **Widget Style:** Only `class`-based widgets, no functional widgets.
- **File Organization:** Each screen and widget must be in its own file under `lib/`.

---

## Features

### 1. Login Screen
- First screen is **Login** (for Admin).
- Should contain:
  - Email field
  - Password field
  - Login button
- On successful login → Navigate to **Home Screen**.

### 2. Home Screen (Bottom TabBarView)
- After login, the admin lands on **Home**.
- Instead of a top TabBar, create a **custom, beautiful bottom TabBar navigation view**.
- Tabs:
  - Patients
  - Appointments
  - Doctors

---

### 3. Patients Tab
- Show a **list of patients** (basic info: name, age).
- Use **custom reusable widgets** (not default `ListTile` or `Card`) for each patient item.
- On tapping a patient → Navigate to **Patient Detail Screen**.
- **Patient Detail Screen** shows:
  - Patient details (name, age, contact info, etc.)
  - Prescriptions list.

---

### 4. Appointments Tab
- Show a **list of appointments** (date, time, patient name).
- Use a **custom widget** for each appointment item.
- On tapping an appointment → Navigate to **Appointment Detail Screen**.
- **Appointment Detail Screen** shows:
  - Appointment details (date, time, doctor, status, etc.)
  - Patient details (linked to this appointment).

---

### 5. Doctors Tab
- Show a **list of doctors**.
- Use a **custom widget** for each doctor item.
- On tapping a doctor → Navigate to **Doctor Detail Screen**.
- **Doctor Detail Screen** shows:
  - Doctor details (name, specialty, contact info, etc.).

---


---

## UI/UX Notes
- Use **Material 3 expressive UI** (`ThemeData(useMaterial3: true)`).
- Build a **custom bottom TabBar navigation** for Home.
- Do **not** use Flutter’s built-in `Card` or `ListTile`.  
  Instead, create **custom reusable widgets** (`PatientTile`, `DoctorTile`, `AppointmentTile`) for list items.
- All screens should respect and adapt to the **theme defined inside `theme/apptheme.dart` folder** (colors, etc.).
dont update the theme folder files
- Maintain **consistent theming** (light/dark modes).
- Use **class-based widgets only** (e.g., `class LoginScreen extends StatelessWidget`).
- Add dummy/mock data for patients, appointments, and doctors to demonstrate functionality.

---

## Deliverables
- Complete Flutter project.
- All screens and widgets separated into their own files.
- Class-based widgets only.
- Material 3 expressive design.
- **Custom bottom TabBarView** navigation.
- **Custom reusable widgets for all tiles** (no direct ListTile/Card usage).
- Screens styled consistently with the **theme provided in the `theme/` folder**.


