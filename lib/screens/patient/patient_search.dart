import 'package:flutter/material.dart';
import 'package:dermasys_flutter/database_helper.dart'; // Import the DatabaseHelper
import 'package:dermasys_flutter/screens/patient/patient_registration.dart';
import "package:dermasys_flutter/screens/triage/triage.dart";

class PatientSearchPage extends StatefulWidget {
  const PatientSearchPage({Key? key}) : super(key: key);

  @override
  _PatientSearchPageState createState() => _PatientSearchPageState();
}

class _PatientSearchPageState extends State<PatientSearchPage> {
  final TextEditingController _idController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Patient"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: "Enter ID/Passport/Birth No",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter ID/Passport/Birth No';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _searchPatient,
                  child: const Text("Search"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _searchPatient() async {
    if (_formKey.currentState?.validate() ?? false) {
      String enteredId = _idController.text;

      // Search for the patient in the database
      Map<String, dynamic>? patient = await DatabaseHelper.instance.getUser(enteredId);

      if (patient != null) {
        // Navigate to Triage Page with the patient's ID
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TriagePage(patientId: enteredId)),
        );
      } else {
        // Navigate to Registration Page if patient is not found
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PatientRegistrationPage()),
        );
      }
    }
  }
}
