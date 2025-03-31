import 'package:flutter/material.dart';

class PatientRecordsPage extends StatefulWidget {
  const PatientRecordsPage({super.key});

  @override
  _PatientRecordsPageState createState() => _PatientRecordsPageState();
}

class _PatientRecordsPageState extends State<PatientRecordsPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _records = [
    {
      "id": "1",
      "date": "2024-01-10",
      "title": "Acne Treatment Plan",
      "description": "Started a topical therapy for moderate acne.",
      "doctor": "Dr. Jane Smith",
      "status": "Ongoing",
    },
    {
      "id": "2",
      "date": "2024-01-20",
      "title": "Blood Test Results",
      "description": "Complete blood count showed no abnormalities.",
      "doctor": "Dr. Alan Brown",
      "status": "Completed",
    },
    {
      "id": "3",
      "date": "2024-02-05",
      "title": "Eczema Flare-up Consultation",
      "description": "Prescribed hydrocortisone cream to manage symptoms.",
      "doctor": "Dr. Sarah Lee",
      "status": "Completed",
    },
  ];

  void _searchPatient() {
    final patientId = _searchController.text;
    final patient = _records.firstWhere(
      (record) => record["id"] == patientId,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TriagePage(patient: patient)),
    );
    }

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
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Enter Patient ID",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchPatient,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildRecordsGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordsGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
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

class TriagePage extends StatelessWidget {
  final Map<String, dynamic> patient;

  const TriagePage({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Triage Page"),
      ),
      body: Center(
        child: Text("Welcome to the Triage Page for ${patient["title"]}"),
      ),
    );
  }
}

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration Page"),
      ),
      body: const Center(
        child: Text("Please register the patient."),
      ),
    );
  }
}
