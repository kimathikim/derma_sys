import 'package:flutter/material.dart';

class TreatmentOverviewPage extends StatefulWidget {
  const TreatmentOverviewPage({Key? key}) : super(key: key);

  @override
  _TreatmentOverviewPageState createState() => _TreatmentOverviewPageState();
}

class _TreatmentOverviewPageState extends State<TreatmentOverviewPage> {
  // Sample list of patients currently undergoing treatment
  final List<Map<String, dynamic>> _treatmentPatients = [
    {
      "name": "Jane Doe",
      "treatmentType": "Acne Treatment",
      "medication": "Benzoyl Peroxide",
      "progress": 70,
      "status": "In Progress",
    },
    {
      "name": "John Smith",
      "treatmentType": "Eczema Care",
      "medication": "Hydrocortisone",
      "progress": 50,
      "status": "In Progress",
    },
    {
      "name": "Alice Johnson",
      "treatmentType": "Scar Removal",
      "medication": "Retinoid Cream",
      "progress": 30,
      "status": "Pending",
    },
  ];

  String _selectedStatusFilter = "All";

  // Status filter options
  final List<String> _statusOptions = ["All", "In Progress", "Completed", "Pending"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Treatment Overview"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilterDropdown(),
            const SizedBox(height: 10),
            Expanded(child: _buildTreatmentList()),
          ],
        ),
      ),
    );
  }

  // Dropdown for filtering treatments by status
  Widget _buildFilterDropdown() {
    return Row(
      children: [
        const Text(
          "Filter by Status:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 10),
        DropdownButton<String>(
          value: _selectedStatusFilter,
          onChanged: (String? newValue) {
            setState(() {
              _selectedStatusFilter = newValue!;
            });
          },
          items: _statusOptions.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  // List of treatment patients based on selected filter
  Widget _buildTreatmentList() {
    // Filter patients based on selected status
    List<Map<String, dynamic>> filteredPatients = _selectedStatusFilter == "All"
        ? _treatmentPatients
        : _treatmentPatients
            .where((patient) => patient["status"] == _selectedStatusFilter)
            .toList();

    return ListView.builder(
      itemCount: filteredPatients.length,
      itemBuilder: (context, index) {
        final patient = filteredPatients[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            leading: _buildProgressIndicator(patient["progress"]),
            title: Text(patient["name"]),
            subtitle: Text(
              "Treatment: ${patient["treatmentType"]}\nMedication: ${patient["medication"]}\nStatus: ${patient["status"]}",
            ),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                // Navigate to treatment details
              },
            ),
            onTap: () {
              // Navigate to treatment details
            },
          ),
        );
      },
    );
  }

  // Circular progress indicator to show treatment progress
  Widget _buildProgressIndicator(int progress) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.grey[200],
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: progress / 100,
            backgroundColor: Colors.grey,
            valueColor: AlwaysStoppedAnimation<Color>(
              progress == 100 ? Colors.green : Colors.blue,
            ),
          ),
          Text(
            "$progress%",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

