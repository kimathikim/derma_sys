import 'package:flutter/material.dart';
import 'package:dermasys_flutter/screens/treatment/treatment.dart';
import 'package:dermasys_flutter/database_helper.dart';

class TreatmentOverviewPage extends StatefulWidget {
  const TreatmentOverviewPage({super.key});

  @override
  _TreatmentOverviewPageState createState() => _TreatmentOverviewPageState();
}

class _TreatmentOverviewPageState extends State<TreatmentOverviewPage> {
  List<Map<String, dynamic>> _treatmentPatients = [];
  String _selectedStatusFilter = "All";
  final List<String> _statusOptions = [
    "All",
    "In Progress",
    "Completed",
    "Pending"
  ];

  @override
  void initState() {
    super.initState();
    _fetchTreatmentPatients();
  }

  Future<void> _fetchTreatmentPatients() async {
    final patients = await DatabaseHelper.instance.getAllTreatments();
    setState(() {
      _treatmentPatients = patients;
    });
  }

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
                  // Navigate to RecordTreatmentPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RecordTreatmentPage(patientId: patient["id"]),
                    ),
                  );
                },
              ),
            ));
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
