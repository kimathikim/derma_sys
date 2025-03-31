import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dermasys_flutter/screens/patient/patient_dashboard.dart';
import 'package:dermasys_flutter/screens/patient/patient_appointments.dart';
import 'package:dermasys_flutter/screens/patient/patient_profile.dart';
import 'package:dermasys_flutter/screens/patient/patient_treatment.dart';
import 'package:dermasys_flutter/screens/patient/patient_records.dart';
import 'package:dermasys_flutter/screens/communication/messages.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  _MainNavigationPageState createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0; // To track the selected page index

  // List of pages to navigate between
  final List<Widget> _pages = [
    const PatientDashboard(),         // Dashboard Page
    const PatientAppointmentPage(),    // Appointments Page
    const PatientTreatmentPage(),      // Treatment Progress Page
    const PatientRecordsPage(),        // Medical Records Page
    const MessagesPage(),              // Messages Page
    const PatientProfilePage(),        // Profile Page
  ];

  // Called when the user taps on a navigation item
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close the Drawer after selecting
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DermaSys'),
        backgroundColor: Theme.of(context).primaryColor,
        // Hamburger menu icon
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
            );
          },
        ),
      ),
      // Drawer for navigation
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Text(
                'Navigation Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.home),
              title: const Text('Dashboard'),
              onTap: () => _onItemTapped(0),
              selected: _selectedIndex == 0,
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.calendarAlt),
              title: const Text('Appointments'),
              onTap: () => _onItemTapped(1),
              selected: _selectedIndex == 1,
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.heartbeat),
              title: const Text('Treatment Progress'),
              onTap: () => _onItemTapped(2),
              selected: _selectedIndex == 2,
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.fileMedical),
              title: const Text('Medical Records'),
              onTap: () => _onItemTapped(3),
              selected: _selectedIndex == 3,
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.envelope),
              title: const Text('Messages'),
              onTap: () => _onItemTapped(4),
              selected: _selectedIndex == 4,
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.user),
              title: const Text('Profile'),
              onTap: () => _onItemTapped(5),
              selected: _selectedIndex == 5,
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex], // Show the selected page
    );
  }
}

