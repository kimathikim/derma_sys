import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DoctorAppointmentPage extends StatefulWidget {
  const DoctorAppointmentPage({super.key});

  @override
  _DoctorAppointmentPageState createState() => _DoctorAppointmentPageState();
}

class _DoctorAppointmentPageState extends State<DoctorAppointmentPage> {
  bool _showUpcoming = true; // Toggle for showing upcoming or past appointments

  // Example list of appointments
  final List<Map<String, dynamic>> _appointments = [
    {
      'patient': 'Jane Doe',
      'appointmentType': 'Consultation',
      'date': '24th Oct 2024',
      'time': '10:30 AM',
      'status': 'upcoming'
    },
    {
      'patient': 'John Smith',
      'appointmentType': 'Follow-up',
      'date': '25th Oct 2024',
      'time': '09:00 AM',
      'status': 'upcoming'
    },
    {
      'patient': 'Alice Brown',
      'appointmentType': 'Dermatology',
      'date': '20th Oct 2023',
      'time': '02:00 PM',
      'status': 'past'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor\'s Appointments'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          // Toggle between showing past and upcoming appointments
          IconButton(
            icon: _showUpcoming
                ? const FaIcon(FontAwesomeIcons.history)
                : const FaIcon(FontAwesomeIcons.calendarAlt),
            onPressed: () {
              setState(() {
                _showUpcoming = !_showUpcoming;
              });
            },
            tooltip: _showUpcoming
                ? 'Show Past Appointments'
                : 'Show Upcoming Appointments',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _showUpcoming
                ? const Text(
                    'Upcoming Appointments',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  )
                : const Text(
                    'Past Appointments',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
            const SizedBox(height: 20),
            _buildAppointmentList(),
          ],
        ),
      ),
    );
  }

  // Build a list of filtered appointments
  Widget _buildAppointmentList() {
    final filteredAppointments = _appointments.where((appointment) {
      return _showUpcoming
          ? appointment['status'] == 'upcoming'
          : appointment['status'] == 'past';
    }).toList();

    return Expanded(
      child: filteredAppointments.isEmpty
          ? Center(
              child: Text(
                _showUpcoming
                    ? "No upcoming appointments"
                    : "No past appointments",
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: filteredAppointments.length,
              itemBuilder: (context, index) {
                final appointment = filteredAppointments[index];
                return _buildAppointmentCard(appointment);
              },
            ),
    );
  }

  // Build an individual appointment card
  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        leading: const FaIcon(FontAwesomeIcons.userMd, size: 40, color: Colors.green),
        title: Text('${appointment['appointmentType']} with ${appointment['patient']}'),
        subtitle: Text('${appointment['date']}, ${appointment['time']}'),
        trailing: _showUpcoming
            ? ElevatedButton(
                onPressed: () {
                  // Mark the appointment as completed
                  setState(() {
                    appointment['status'] = 'past';
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Appointment with ${appointment['patient']} marked as completed.'),
                    ),
                  );
                },
                child: const Text('Complete'),
              )
            : const Icon(Icons.check_circle, color: Colors.grey),
      ),
    );
  }
}

