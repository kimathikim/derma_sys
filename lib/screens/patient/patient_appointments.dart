import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class PatientAppointmentPage extends StatefulWidget {
  const PatientAppointmentPage({super.key});

  @override
  _PatientAppointmentPageState createState() => _PatientAppointmentPageState();
}

class _PatientAppointmentPageState extends State<PatientAppointmentPage> {
  final _formKey = GlobalKey<FormState>();

  String _selectedDoctor = 'Dr. John Smith';
  String _selectedAppointmentType = 'Consultation';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  final List<String> _doctors = [
    'Dr. John Smith',
    'Dr. Jane Doe',
    'Dr. Alice Brown'
  ];
  final List<String> _appointmentTypes = [
    'Consultation',
    'Follow-up',
    'Dermatology'
  ];

  final List<Map<String, String>> _appointments = [
    {
      'doctor': 'Dr. John Smith',
      'date': '24th Oct 2024',
      'time': '10:30 AM',
      'type': 'Consultation'
    },
    {
      'doctor': 'Dr. Alice Brown',
      'date': '25th Oct 2024',
      'time': '09:00 AM',
      'type': 'Follow-up'
    }
  ];

  bool _showUpcoming = true;

  // Helper function to remove ordinal suffixes (like 24th -> 24)
  String _removeOrdinalSuffix(String date) {
    return date.replaceAll(RegExp(r'(st|nd|rd|th)'), '');
  }

  // Helper function to parse date strings that include ordinal suffixes
  DateTime parseDateString(String dateString) {
    String cleanedDate = _removeOrdinalSuffix(dateString); // Clean the date string
    DateFormat dateFormat = DateFormat('d MMM y');
    return dateFormat.parse(cleanedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppointmentForm(),
            const SizedBox(height: 20),
            _buildFilteredAppointments(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentForm() {
    return Center(
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          width: 400, // Reduced width for a more compact form
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Book a New Appointment',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDoctorDropdown(),
                      const SizedBox(height: 10),
                      _buildAppointmentTypeDropdown(),
                      const SizedBox(height: 10),
                      _buildDatePicker(),
                      const SizedBox(height: 10),
                      _buildTimePicker(),
                      const SizedBox(height: 20),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedDoctor,
      onChanged: (String? newValue) {
        setState(() {
          _selectedDoctor = newValue!;
        });
      },
      decoration: InputDecoration(
        labelText: 'Select Doctor',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: _doctors.map<DropdownMenuItem<String>>((String doctor) {
        return DropdownMenuItem<String>(
          value: doctor,
          child: Text(doctor),
        );
      }).toList(),
    );
  }

  Widget _buildAppointmentTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedAppointmentType,
      onChanged: (String? newValue) {
        setState(() {
          _selectedAppointmentType = newValue!;
        });
      },
      decoration: InputDecoration(
        labelText: 'Appointment Type',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: _appointmentTypes.map<DropdownMenuItem<String>>((String type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Text(type),
        );
      }).toList(),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
        );
        if (picked != null && picked != _selectedDate) {
          setState(() {
            _selectedDate = picked;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Appointment Date',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(DateFormat('yMMMd').format(_selectedDate)),
            const Icon(Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker() {
    return GestureDetector(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: _selectedTime,
        );
        if (picked != null && picked != _selectedTime) {
          setState(() {
            _selectedTime = picked;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Appointment Time',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_selectedTime.format(context)),
            const Icon(Icons.access_time),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // Confirm appointment booking
            setState(() {
              _appointments.add({
                'doctor': _selectedDoctor,
                'date': DateFormat('d MMM y').format(_selectedDate),
                'time': _selectedTime.format(context),
                'type': _selectedAppointmentType,
              });
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Appointment booked successfully!'),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'Dismiss',
                  onPressed: () {},
                ),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          'Book Appointment',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  // Display filtered appointments (vertically scrollable upcoming appointments)
  Widget _buildFilteredAppointments() {
    final filteredAppointments = _appointments.where((appointment) {
      DateTime appointmentDate = parseDateString(appointment['date']!); // Use the cleaned date string
      if (_showUpcoming) {
        return appointmentDate.isAfter(DateTime.now());
      } else {
        return appointmentDate.isBefore(DateTime.now());
      }
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _showUpcoming
              ? 'Your Upcoming Appointments'
              : 'Your Past Appointments',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        filteredAppointments.isEmpty
            ? Center(
                child: Text(
                  _showUpcoming
                      ? "No upcoming appointments"
                      : "No past appointments",
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : SizedBox(
                height: 300, // Limit the height for scrollability
                child: ListView.builder(
                  itemCount: filteredAppointments.length,
                  itemBuilder: (context, index) {
                    final appointment = filteredAppointments[index];
                    return _buildAppointmentCard(
                      doctor: appointment['doctor']!,
                      date: appointment['date']!,
                      time: appointment['time']!,
                      type: appointment['type']!,
                    );
                  },
                ),
              ),
      ],
    );
  }

  Widget _buildAppointmentCard({
    required String doctor,
    required String date,
    required String time,
    required String type,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const FaIcon(FontAwesomeIcons.userMd, size: 40, color: Colors.green),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  date,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  time,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                Text(
                  type,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

