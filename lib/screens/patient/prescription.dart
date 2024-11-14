import 'package:flutter/material.dart';

class PrescriptionsPage extends StatelessWidget {
  final List<Map<String, String>> prescriptions = [
    {'name': 'Acne Treatment', 'date': '12th Oct 2024', 'doctor': 'Dr. Jane Doe'},
    {'name': 'Skin Infection', 'date': '1st Oct 2024', 'doctor': 'Dr. Alice Brown'},
  ];

  PrescriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescriptions'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: prescriptions.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: const Icon(Icons.medication, size: 40, color: Colors.green),
                title: Text(prescriptions[index]['name']!),
                subtitle: Text('Prescribed by ${prescriptions[index]['doctor']} on ${prescriptions[index]['date']}'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to prescription details if necessary
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

