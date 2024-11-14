import 'package:flutter/material.dart';

class TriageOverviewPage extends StatefulWidget {
  const TriageOverviewPage({Key? key}) : super(key: key);

  @override
  _TriageOverviewPageState createState() => _TriageOverviewPageState();
}

class _TriageOverviewPageState extends State<TriageOverviewPage> {
  // Sample list of patients for the triage area
  final List<Map<String, dynamic>> _triagePatients = [
    {
      "name": "Jane Doe",
      "status": "Walk-In",
      "arrivalTime": "10:30 AM",
      "priority": "High"
    },
    {
      "name": "John Smith",
      "status": "Observation",
      "arrivalTime": "11:00 AM",
      "priority": "Medium"
    },
    {
      "name": "Alice Johnson",
      "status": "Procedure Queue",
      "arrivalTime": "11:15 AM",
      "priority": "Low"
    },
  ];

  String _selectedStatusFilter = "All";

  final List<String> _statusOptions = ["All", "Walk-In", "Observation", "Procedure Queue"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Triage Overview"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilterDropdown(),
            const SizedBox(height: 10),
            Expanded(child: _buildTriageList()),
          ],
        ),
      ),
    );
  }

  // Filter dropdown for patient status
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

  // List of triage patients based on selected filter
  Widget _buildTriageList() {
    // Filter patients based on selected status
    List<Map<String, dynamic>> filteredPatients = _selectedStatusFilter == "All"
        ? _triagePatients
        : _triagePatients
            .where((patient) => patient["status"] == _selectedStatusFilter)
            .toList();

    return ListView.builder(
      itemCount: filteredPatients.length,
      itemBuilder: (context, index) {
        final patient = filteredPatients[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(patient["priority"][0]), // Priority level initial
              backgroundColor: _getPriorityColor(patient["priority"]),
            ),
            title: Text(patient["name"]),
            subtitle: Text(
              "Status: ${patient["status"]}\nArrival Time: ${patient["arrivalTime"]}",
            ),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                // Navigate to patient details or triage actions
              },
            ),
            onTap: () {
              // Navigate to patient details or triage actions
            },
          ),
        );
      },
    );
  }

  // Helper function to get priority color
  Color _getPriorityColor(String priority) {
    switch (priority) {
      case "High":
        return Colors.red;
      case "Medium":
        return Colors.orange;
      case "Low":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

