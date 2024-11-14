import 'package:flutter/material.dart';

class DoctorDashboard extends StatelessWidget {
  const DoctorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DermaSys Dashboard"),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatisticsGrid(),
            const SizedBox(height: 30),
            _buildAppointmentSection(),
            const SizedBox(height: 30),
            _buildInventorySection(),
            const SizedBox(height: 30),
            _buildDataAnalyticsSection(),
            const SizedBox(height: 30),
            _buildCommunicationSection(),
          ],
        ),
      ),
    );
  }

  // Statistics grid for quick insights as per system modules
  Widget _buildStatisticsGrid() {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2,
      ),
      children: [
        _buildStatisticCard("Total Patients", "120"),
        _buildStatisticCard("Active Treatments", "45"),
        _buildStatisticCard("Today's Appointments", "15"),
        _buildStatisticCard("Upcoming Appointments", "32"),
        _buildStatisticCard("Inventory Alerts", "3"),
        _buildStatisticCard("New Messages", "5"),
      ],
    );
  }

  // Individual statistic card widget
  Widget _buildStatisticCard(String label, String count) {
    return Card(
      color: Colors.teal,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              count,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Appointment scheduling module with today's appointments
  Widget _buildAppointmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Today's Appointments",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildAppointmentCard("Jane Doe", "Skin Consultation", "11:00 AM"),
            _buildAppointmentCard("John Smith", "Follow-up", "1:30 PM"),
            _buildAppointmentCard("Alice Johnson", "Acne Treatment", "3:00 PM"),
          ],
        ),
      ],
    );
  }

  // Individual appointment card
  Widget _buildAppointmentCard(String patient, String purpose, String time) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: const Icon(Icons.event, color: Colors.blue),
        title: Text(patient),
        subtitle: Text("$purpose\nTime: $time"),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Navigate to detailed appointment view
        },
      ),
    );
  }

  // Inventory management section showing alerts and stock levels
  Widget _buildInventorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Inventory Management",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildInventoryCard("Skin Cream", "Low Stock"),
            _buildInventoryCard("Acne Medication", "Expiring Soon"),
            _buildInventoryCard("Sunscreen", "Out of Stock"),
          ],
        ),
      ],
    );
  }

  // Individual inventory card for alerts
  Widget _buildInventoryCard(String item, String status) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        leading: const Icon(Icons.warning, color: Colors.red),
        title: Text(item),
        subtitle: Text("Status: $status"),
      ),
    );
  }

  // Data analytics section showing key clinic metrics
  Widget _buildDataAnalyticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Data Analytics and Reporting",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          child: ListTile(
            leading: const Icon(Icons.analytics, color: Colors.orange),
            title: const Text("Treatment Success Rate"),
            subtitle: const Text("84% based on last quarter"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to detailed analytics report
            },
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.trending_up, color: Colors.green),
            title: const Text("Patient Satisfaction"),
            subtitle: const Text("92% positive feedback"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to satisfaction report
            },
          ),
        ),
      ],
    );
  }

  // Communication and security section for secure messaging and reminders
  Widget _buildCommunicationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Communication and Security",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          child: ListTile(
            leading: const Icon(Icons.message, color: Colors.blue),
            title: const Text("New Messages"),
            subtitle: const Text("5 new messages from patients"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to messages
            },
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.lock, color: Colors.red),
            title: const Text("Security Reminder"),
            subtitle: const Text("Review security settings"),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to security settings
            },
          ),
        ),
      ],
    );
  }
}

