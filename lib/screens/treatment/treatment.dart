import 'package:flutter/material.dart';
import 'package:dermasys_flutter/database_helper.dart'; // Import your database helper
import 'package:dermasys_flutter/screens/treatment/treatment_overview.dart';

class RecordTreatmentPage extends StatefulWidget {
  final String patientId;

  const RecordTreatmentPage({super.key, required this.patientId});

  @override
  _RecordTreatmentPageState createState() => _RecordTreatmentPageState();
}

class _RecordTreatmentPageState extends State<RecordTreatmentPage> {
  final _formKey = GlobalKey<FormState>();
  String _treatmentType = '';
  String _medication = '';
  String _observation = '';
  String? _labResults; // Holds the lab results if available

  @override
  void initState() {
    super.initState();
    _fetchLabResults(); // Fetch lab results when the page is loaded
  }

  void _fetchLabResults() async {
    final labDetails =
        await DatabaseHelper.instance.getLabDetails(widget.patientId);
    setState(() {
      _labResults = labDetails[0]['testResults'];
    });
  }

  void _saveTreatment() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Save treatment details to the database
      await DatabaseHelper.instance.addTreatment({
        'patientId': widget.patientId,
        'treatmentType': _treatmentType,
        'medication': _medication,
        'observation': _observation,
      });

    //  Navigator.pop(context);
    }
  }

  void _goToLab() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LabWidget(
          patientId: widget.patientId,
          doctorObservation: _observation, // Pass the doctor's observation
        ),
      ),
    );
  }

  void _goToPharmacy() {
    // Navigate to the pharmacy page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const Placeholder(), // Replace Placeholder with PharmacyPage
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Record Treatment"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_labResults != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lab Results:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(_labResults!,
                        style: const TextStyle(color: Colors.blue)),
                    const SizedBox(height: 20),
                  ],
                ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Treatment Type'),
                onSaved: (value) {
                  _treatmentType = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Medication'),
                onSaved: (value) {
                  _medication = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Observation'),
                maxLines: 3,
                onSaved: (value) {
                  _observation = value!;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _saveTreatment,
                    child: const Text('Save Treatment'),
                  ),
                  ElevatedButton(
                    onPressed: _goToLab,
                    child: const Text('Go to Lab'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LabWidget extends StatefulWidget {
  final String patientId;
  final String doctorObservation;

  const LabWidget(
      {super.key, required this.patientId, required this.doctorObservation});

  @override
  _LabWidgetState createState() => _LabWidgetState();
}

class _LabWidgetState extends State<LabWidget> {
  final _formKey = GlobalKey<FormState>();
  String _testType = '';
  String _testResults = '';

  void _saveLabDetails() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Save lab details to the database
      await DatabaseHelper.instance.addLabDetails({
        'patientId': widget.patientId,
        'testType': _testType,
        'testResults': _testResults,
      });

      // Navigate back to treatment page
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lab details saved successfully')),
      );

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TreatmentOverviewPage()
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lab Test"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Doctor Observation:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(widget.doctorObservation,
                  style: const TextStyle(color: Colors.blue)),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Test Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the test type';
                  }
                  return null;
                },
                onSaved: (value) {
                  _testType = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Test Results'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the test results';
                  }
                  return null;
                },
                onSaved: (value) {
                  _testResults = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveLabDetails,
                child: const Text('Save Lab Details'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

