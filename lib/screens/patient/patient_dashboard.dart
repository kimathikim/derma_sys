import 'package:flutter/material.dart';
import 'package:dermasys_flutter/screens/patient/prescription.dart';
import 'package:dermasys_flutter/screens/communication/messages.dart';
import 'package:dermasys_flutter/screens/patient/patient_appointments.dart';
import 'package:dermasys_flutter/screens/patient/patient_treatment.dart';

class PatientDashboard extends StatelessWidget {
  const PatientDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Dashboard"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 30),
                  _buildQuickActions(context),
                  const SizedBox(height: 30),
                  _buildUpcomingAppointments(context),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRecentTreatments(context),
                  const SizedBox(height: 20),
                  _buildPrescriptions(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header with welcome message and profile picture
  Widget _buildHeader(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome back,",
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            Text(
              "Jane Doe",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(
              'https://www.example.com/images/profile.jpg'), // Placeholder profile image
        ),
      ],
    );
  }

  // Quick Actions like Prescriptions and Messages
  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildQuickAction(
          context,
          icon: Icons.medication,
          label: "Prescriptions",
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PrescriptionsPage(),
              ),
            );
          },
        ),
        _buildQuickAction(
          context,
          icon: Icons.message,
          label: "Messages",
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const MessagesPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickAction(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: Icon(
              icon,
              size: 30,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // Upcoming appointments section
  Widget _buildUpcomingAppointments(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upcoming Appointments",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          child: ListTile(
            leading: const Icon(Icons.event, size: 40, color: Colors.green),
            title: const Text("Dermatology Consultation"),
            subtitle: const Text("24th Oct 2024, 10:30 AM"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PatientAppointmentPage(),
                ),
              );
            },
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.event, size: 40, color: Colors.green),
            title: const Text("Follow-up Appointment"),
            subtitle: const Text("30th Oct 2024, 9:00 AM"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PatientAppointmentPage(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Recent treatments section
  Widget _buildRecentTreatments(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recent Treatments",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          child: ListTile(
            leading: const Icon(Icons.healing, size: 40, color: Colors.purple),
            title: const Text("Acne Treatment"),
            subtitle: const Text("Started on 12th Oct 2024"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PatientTreatmentPage(),
                ),
              );
            },
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.healing, size: 40, color: Colors.purple),
            title: const Text("Eczema Management"),
            subtitle: const Text("Started on 5th Sep 2024"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PatientTreatmentPage(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Prescriptions section
  Widget _buildPrescriptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Prescriptions",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          child: ListTile(
            leading: const Icon(Icons.medication, size: 40, color: Colors.blue),
            title: const Text("Benzoyl Peroxide"),
            subtitle: const Text("Prescribed on 12th Oct 2024"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PrescriptionsPage(),
                ),
              );
            },
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.medication, size: 40, color: Colors.blue),
            title: const Text("Hydrocortisone Cream"),
            subtitle: const Text("Prescribed on 5th Sep 2024"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PrescriptionsPage(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

