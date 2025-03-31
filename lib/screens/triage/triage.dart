import 'package:flutter/material.dart';
import 'package:dermasys_flutter/database_helper.dart'; // Import the DatabaseHelper
import 'package:dermasys_flutter/doctor_main.dart';

class TriagePage extends StatefulWidget {
  final String patientId;

  const TriagePage({super.key, required this.patientId});

  @override
  _TriagePageState createState() => _TriagePageState();
}

class _TriagePageState extends State<TriagePage> {
  final _formKey = GlobalKey<FormState>();

  // Form field controllers
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _bloodPressureController =
      TextEditingController();
  final TextEditingController _heartRateController = TextEditingController();
  final TextEditingController _respiratoryRateController =
      TextEditingController();
  final TextEditingController _arrivalTimeController = TextEditingController();

  // Status and Priority options
  String? _selectedStatus;
  String? _selectedPriority;

  final List<String> _statusOptions = ["Walk-In", "Ambulance", "Referral"];
  final List<String> _priorityOptions = ["Low", "Medium", "High"];

  @override
  void initState() {
    super.initState();
    print('Patient ID: ${widget.patientId}');
    _fetchPatientDetails();
  }

  Future<void> _fetchPatientDetails() async {
    final patient = await DatabaseHelper.instance.getPatient(widget.patientId);
    if (patient != null) {
      setState(() {
        _temperatureController.text = patient['temperature'].toString();
        _bloodPressureController.text = patient['blood_pressure'];
        _heartRateController.text = patient['heart_rate'].toString();
        _respiratoryRateController.text =
            patient['respiratory_rate'].toString();
        _arrivalTimeController.text = patient['arrival_time'];
        _selectedStatus = patient['status'];
        _selectedPriority = patient['priority'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Triage"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Triage for Patient ID: ${widget.patientId}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("Patient Vitals",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildTextField(_temperatureController, "Temperature (°C)"),
              const SizedBox(height: 10),
              _buildTextField(
                  _bloodPressureController, "Blood Pressure (mmHg)"),
              const SizedBox(height: 10),
              _buildTextField(_heartRateController, "Heart Rate (bpm)"),
              const SizedBox(height: 10),
              _buildTextField(
                  _respiratoryRateController, "Respiratory Rate (breaths/min)"),
              const SizedBox(height: 20),
              const Text("Agency Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildDropdownField("Status", _statusOptions, _selectedStatus,
                  (value) {
                setState(() {
                  _selectedStatus = value;
                });
              }),
              const SizedBox(height: 10),
              _buildTextField(_arrivalTimeController, "Arrival Time"),
              const SizedBox(height: 10),
              _buildDropdownField(
                  "Priority", _priorityOptions, _selectedPriority, (value) {
                setState(() {
                  _selectedPriority = value;
                });
              }),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _resetForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text("Reset"),
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text("Save"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Text field builder for general input
  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: label.contains("Temperature") ||
              label.contains("Rate") ||
              label.contains("Pressure")
          ? TextInputType.number
          : TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  // Dropdown field builder
  Widget _buildDropdownField(String label, List<String> options,
      String? selectedValue, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 5),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          value: selectedValue,
          items: options.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select $label';
            }
            return null;
          },
        ),
      ],
    );
  }

  // Reset form fields
  void _resetForm() {
    _formKey.currentState?.reset();
    _temperatureController.clear();
    _bloodPressureController.clear();
    _heartRateController.clear();
    _respiratoryRateController.clear();
    _arrivalTimeController.clear();
    setState(() {
      _selectedStatus = null;
      _selectedPriority = null;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Update the patient data in the database
      final patient = {
        'temperature': double.tryParse(_temperatureController.text),
        'blood_pressure': _bloodPressureController.text,
        'heart_rate': int.tryParse(_heartRateController.text),
        'respiratory_rate': int.tryParse(_respiratoryRateController.text),
        'arrival_time': _arrivalTimeController.text,
        'status': _selectedStatus,
        'priority': _selectedPriority,
      };

      await DatabaseHelper.instance.updatePatient(widget.patientId, patient);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Triage data updated successfully!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DocMainNavigationPage()),
      );
      // Optionally navigate to another page or reset the form
      _resetForm();
    }
  }
}
