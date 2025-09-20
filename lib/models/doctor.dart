class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String email;
  final String phone;
  final String department;
  final int experienceYears;

  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.email,
    required this.phone,
    required this.department,
    required this.experienceYears,
  });

  static List<Doctor> getDummyDoctors() {
    return [
      const Doctor(
        id: '1',
        name: 'Dr. Robert Wilson',
        specialty: 'Cardiology',
        email: 'robert.wilson@hospital.com',
        phone: '+1-555-1001',
        department: 'Cardiovascular Department',
        experienceYears: 15,
      ),
      const Doctor(
        id: '2',
        name: 'Dr. Lisa Anderson',
        specialty: 'Orthopedics',
        email: 'lisa.anderson@hospital.com',
        phone: '+1-555-1002',
        department: 'Orthopedic Department',
        experienceYears: 12,
      ),
      const Doctor(
        id: '3',
        name: 'Dr. James Martinez',
        specialty: 'Internal Medicine',
        email: 'james.martinez@hospital.com',
        phone: '+1-555-1003',
        department: 'Internal Medicine',
        experienceYears: 20,
      ),
      const Doctor(
        id: '4',
        name: 'Dr. Maria Garcia',
        specialty: 'Obstetrics & Gynecology',
        email: 'maria.garcia@hospital.com',
        phone: '+1-555-1004',
        department: 'Women\'s Health',
        experienceYears: 8,
      ),
      const Doctor(
        id: '5',
        name: 'Dr. David Lee',
        specialty: 'Neurology',
        email: 'david.lee@hospital.com',
        phone: '+1-555-1005',
        department: 'Neuroscience Department',
        experienceYears: 18,
      ),
    ];
  }
}
