import 'package:flutter/material.dart';
import 'package:dermasys_flutter/database_helper.dart';
import 'package:dermasys_flutter/screens/treatment/treatment.dart';

class TriageOverviewPage extends StatefulWidget {
  const TriageOverviewPage({super.key});

  @override
  _TriageOverviewPageState createState() => _TriageOverviewPageState();
}

class _TriageOverviewPageState extends State<TriageOverviewPage> {
  List<Map<String, dynamic>> _triagePatients = [];
  String _selectedStatusFilter = "All";
  final List<String> _statusOptions = ["All", "Walk-In", "Observation", "Procedure Queue"];

  @override
  void initState() {
    super.initState();
    _fetchTriagePatients();
  }

  Future<void> _fetchTriagePatients() async {
    final patients = await DatabaseHelper.instance.getAllPatients();
    print(patients);
    setState(() {
      _triagePatients = patients;
    });
  }

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
        : _triagePatients.where((patient) => patient["status"] == _selectedStatusFilter).toList();

    return ListView.builder(
      itemCount: filteredPatients.length,
      itemBuilder: (context, index) {
        final patient = filteredPatients[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getPriorityColor(patient["priority"]),
              child: Text(patient["priority"][0]),
            ),
            title: Text(patient["name"]),
            subtitle: Text(
              "Status: ${patient["status"]}\nArrival Time: ${patient["arrival_time"]}",
            ),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                // Navigate to RecordTreatmentPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecordTreatmentPage(patientId: patient["id"]),
                  ),
                );
              },
            ),
            onTap: () {
              // Navigate to RecordTreatmentPage
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecordTreatmentPage(patientId: patient["id"]),
                ),
              );
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
