class Patient {
  final String id;
  final String name;
  final int age;
  final String email;
  final String phone;
  final String address;
  final List<String> prescriptions;

  const Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.email,
    required this.phone,
    required this.address,
    required this.prescriptions,
  });

  static List<Patient> getDummyPatients() {
    return [
      const Patient(
        id: '1',
        name: 'John Smith',
        age: 45,
        email: 'john.smith@email.com',
        phone: '+1-555-0123',
        address: '123 Main St, City, State 12345',
        prescriptions: [
          'Medication A - Take twice daily',
          'Medication B - Once before meals',
          'Rest and follow-up in 2 weeks',
        ],
      ),
      const Patient(
        id: '2',
        name: 'Sarah Johnson',
        age: 32,
        email: 'sarah.johnson@email.com',
        phone: '+1-555-0456',
        address: '456 Oak Ave, City, State 12345',
        prescriptions: ['Physical therapy sessions', 'Pain medication as needed'],
      ),
      const Patient(
        id: '3',
        name: 'Michael Brown',
        age: 58,
        email: 'michael.brown@email.com',
        phone: '+1-555-0789',
        address: '789 Pine Rd, City, State 12345',
        prescriptions: ['Blood pressure medication', 'Low sodium diet', 'Regular exercise'],
      ),
      const Patient(
        id: '4',
        name: 'Emily Davis',
        age: 28,
        email: 'emily.davis@email.com',
        phone: '+1-555-0321',
        address: '321 Elm St, City, State 12345',
        prescriptions: ['Prenatal vitamins', 'Regular checkups'],
      ),
    ];
  }
}
