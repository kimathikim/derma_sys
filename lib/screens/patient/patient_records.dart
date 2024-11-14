import 'package:flutter/material.dart';

class PatientRecordsPage extends StatefulWidget {
  const PatientRecordsPage({Key? key}) : super(key: key);

  @override
  _PatientRecordsPageState createState() => _PatientRecordsPageState();
}

class _PatientRecordsPageState extends State<PatientRecordsPage> {
  // Sample list of medical records
  final List<Map<String, dynamic>> _records = [
    {
      "date": "2024-01-10",
      "title": "Acne Treatment Plan",
      "description": "Started a topical therapy for moderate acne.",
      "doctor": "Dr. Jane Smith",
      "status": "Ongoing",
    },
    {
      "date": "2024-01-20",
      "title": "Blood Test Results",
      "description": "Complete blood count showed no abnormalities.",
      "doctor": "Dr. Alan Brown",
      "status": "Completed",
    },
    {
      "date": "2024-02-05",
      "title": "Eczema Flare-up Consultation",
      "description": "Prescribed hydrocortisone cream to manage symptoms.",
      "doctor": "Dr. Sarah Lee",
      "status": "Completed",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medical Records"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Medical Records",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildRecordsGrid()),
          ],
        ),
      ),
    );
  }

  // Builds a grid layout for displaying medical records
  Widget _buildRecordsGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Display two records per row
        childAspectRatio: 3, // Adjust height for large screens
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
      itemCount: _records.length,
      itemBuilder: (context, index) {
        final record = _records[index];
        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record["title"],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Date: ${record["date"]}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  "Doctor: ${record["doctor"]}",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  record["description"],
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Chip(
                    label: Text(
                      record["status"],
                      style: TextStyle(
                        color: record["status"] == "Ongoing" ? Colors.blue : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: record["status"] == "Ongoing"
                        ? Colors.blue[50]
                        : Colors.green[50],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

