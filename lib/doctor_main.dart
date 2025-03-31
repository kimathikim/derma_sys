import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dermasys_flutter/screens/doctor/doctor_dashboard.dart';
import 'package:dermasys_flutter/screens/doctor/doctor_appointments.dart';
import 'package:dermasys_flutter/screens/doctor/doctor_profile.dart';
import 'package:dermasys_flutter/screens/triage/triage_overview.dart';
import 'package:dermasys_flutter/screens/treatment/treatment_overview.dart';
import 'package:dermasys_flutter/screens/inventory/inventory_management.dart';
import 'package:dermasys_flutter/screens/analytics/analytics_overview.dart';
import 'package:dermasys_flutter/screens/communication/messages.dart';
import 'package:dermasys_flutter/screens/patient/patient_search.dart';

class DocMainNavigationPage extends StatefulWidget {
  const DocMainNavigationPage({super.key});

  @override
  _MainNavigationPageState createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<DocMainNavigationPage> {
  int _selectedIndex = 0; // To track the selected page index

  // List of pages to navigate between
  final List<Widget> _pages = [
    const DoctorDashboard(), // Dashboard Page
    const DoctorAppointmentPage(), // Appointments Page
    const PatientSearchPage(), // Patient
    const TriageOverviewPage(), // Triage Page
    const TreatmentOverviewPage(), // Treatment Page
    const InventoryManagementPage(), // Inventory Management Page
    const AnalyticsOverviewPage(), // Analytics Page
    const MessagesPage(), // Communication Page
    const DoctorProfilePage(), // Profile Page
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
              leading: const FaIcon(FontAwesomeIcons.userPlus),
              title: const Text('Patient Management'),
              onTap: () => _onItemTapped(2),
              selected: _selectedIndex == 2,
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.stethoscope),
              title: const Text('Triage'),
              onTap: () => _onItemTapped(3),
              selected: _selectedIndex == 3,
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.heartbeat),
              title: const Text('Treatment'),
              onTap: () => _onItemTapped(4),
              selected: _selectedIndex == 4,
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.pills),
              title: const Text('Inventory Management'),
              onTap: () => _onItemTapped(5),
              selected: _selectedIndex == 5,
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.chartLine),
              title: const Text('Analytics'),
              onTap: () => _onItemTapped(6),
              selected: _selectedIndex == 6,
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.envelope),
              title: const Text('Messages'),
              onTap: () => _onItemTapped(7),
              selected: _selectedIndex == 7,
            ),
            ListTile(
              leading: const FaIcon(FontAwesomeIcons.user),
              title: const Text('Profile'),
              onTap: () => _onItemTapped(8),
              selected: _selectedIndex == 8,
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex], // Show the selected page
    );
  }
}

