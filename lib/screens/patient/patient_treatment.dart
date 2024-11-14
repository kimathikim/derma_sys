import 'package:flutter/material.dart';

class PatientTreatmentPage extends StatefulWidget {
  const PatientTreatmentPage({super.key});

  @override
  _PatientTreatmentPageState createState() => _PatientTreatmentPageState();
}

class _PatientTreatmentPageState extends State<PatientTreatmentPage> {
  // Sample list of treatments
  final List<Map<String, dynamic>> _treatments = [
    {
      "treatmentType": "Acne Treatment",
      "progress": 75,
      "milestones": [
        {"description": "Initial Consultation", "date": "2024-01-10"},
        {"description": "Start Topical Therapy", "date": "2024-02-01"},
        {"description": "Follow-up Visit", "date": "2024-03-15"},
      ],
      "medications": ["Benzoyl Peroxide", "Salicylic Acid Cream"],
      "status": "In Progress",
    },
    {
      "treatmentType": "Scar Reduction",
      "progress": 40,
      "milestones": [
        {"description": "Initial Assessment", "date": "2024-01-20"},
        {"description": "Begin Laser Therapy", "date": "2024-02-15"},
      ],
      "medications": ["Retinoid Cream", "Vitamin C Serum"],
      "status": "In Progress",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Treatment Progress"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Treatment Plans",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildTreatmentList()),
          ],
        ),
      ),
    );
  }

  // Builds the list of treatments with progress and details
  Widget _buildTreatmentList() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Display two items side by side
        childAspectRatio: 3, // Adjust height for large screens
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
      ),
      itemCount: _treatments.length,
      itemBuilder: (context, index) {
        final treatment = _treatments[index];
        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  treatment["treatmentType"],
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildProgressIndicator(treatment["progress"]),
                const SizedBox(height: 20),
                Text(
                  "Status: ${treatment["status"]}",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                _buildMilestonesSection(treatment["milestones"]),
                const SizedBox(height: 10),
                _buildMedicationsSection(treatment["medications"]),
              ],
            ),
          ),
        );
      },
    );
  }

  // Progress indicator for each treatment plan
  Widget _buildProgressIndicator(int progress) {
    return Row(
      children: [
        Expanded(
          flex: progress,
          child: Container(
            height: 8,
            color: progress == 100 ? Colors.green : Colors.blue,
          ),
        ),
        Expanded(
          flex: 100 - progress,
          child: Container(
            height: 8,
            color: Colors.grey[300],
          ),
        ),
        const SizedBox(width: 10),
        Text("$progress%", style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  // Milestones section showing the milestones of the treatment
  Widget _buildMilestonesSection(List<Map<String, String>> milestones) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Milestones:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        ...milestones.map((milestone) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(milestone["description"]!),
                Text(
                  milestone["date"]!,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // Medications section showing medications involved in the treatment
  Widget _buildMedicationsSection(List<String> medications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Medications:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        ...medications.map((medication) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text("- $medication"),
          );
        }),
      ],
    );
  }
}

