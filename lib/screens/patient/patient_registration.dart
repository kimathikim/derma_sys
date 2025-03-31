import 'package:flutter/material.dart';
import 'package:dermasys_flutter/database_helper.dart'; // Import the DatabaseHelper
import 'package:dermasys_flutter/screens/triage/triage.dart'; // Import the TriagePage
class PatientRegistrationPage extends StatefulWidget {
  const PatientRegistrationPage({super.key});

  @override
  _PatientRegistrationPageState createState() =>
      _PatientRegistrationPageState();
}

class _PatientRegistrationPageState extends State<PatientRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  // Form field controllers
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _nextOfKinController = TextEditingController();
  final TextEditingController _nextOfKinPhoneController =
      TextEditingController();

  String? _selectedGender;
  String? _selectedRelationship;
  String? _selectedPatientType;
  String? _selectedInsurance;

  // Gender options
  final List<String> _genders = ["male", "female", "other"];

  // Relationship options
  final List<String> _relationships = ["Parent", "Sibling", "Spouse", "Other"];

  // Patient Type options
  final List<String> _patientTypes = [
    "Private",
    "Student",
    "Employee",
    "Dependent",
  ];

  // Insurance options (sample list)
  final List<String> _insuranceOptions = ["None", "Insurance A", "Insurance B"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Registration"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(_idController, "ID/Passport/Birth No"),
              const SizedBox(height: 10),
              _buildTextField(_firstNameController, "First Name"),
              const SizedBox(height: 10),
              _buildTextField(_surnameController, "Surname"),
              const SizedBox(height: 10),
              _buildTextField(_middleNameController, "Middle Name"),
              const SizedBox(height: 10),
              _buildDropdownField("Gender", _genders, _selectedGender, (value) {
                setState(() {
                  _selectedGender = value;
                });
              }),
              const SizedBox(height: 10),
              _buildDatePickerField("Date of Birth"),
              const SizedBox(height: 10),
              _buildTextField(_phoneNumberController, "Phone Number"),
              const SizedBox(height: 10),
              _buildTextField(_nextOfKinController, "Next of Kin Name"),
              const SizedBox(height: 10),
              _buildTextField(_nextOfKinPhoneController, "Next of Kin Phone"),
              const SizedBox(height: 10),
              _buildDropdownField(
                "Relationship to Next of Kin",
                _relationships,
                _selectedRelationship,
                (value) {
                  setState(() {
                    _selectedRelationship = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              _buildDropdownField(
                "Patient Type",
                _patientTypes,
                _selectedPatientType,
                (value) {
                  setState(() {
                    _selectedPatientType = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              _buildDropdownField(
                "Insurance",
                _insuranceOptions,
                _selectedInsurance,
                (value) {
                  setState(() {
                    _selectedInsurance = value;
                  });
                },
              ),
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

  // Date picker field for Date of Birth
  Widget _buildDatePickerField(String label) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          setState(() {
            _selectedDate = "${pickedDate.toLocal()}".split(' ')[0];
          });
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Date of Birth",
        ),
        child: Text(
          _selectedDate ?? "Select Date",
          style: TextStyle(
              color: _selectedDate == null ? Colors.grey : Colors.black),
        ),
      ),
    );
  }

  String? _selectedDate;

  // Reset form fields
  void _resetForm() {
    _formKey.currentState?.reset();
    _idController.clear();
    _firstNameController.clear();
    _surnameController.clear();
    _middleNameController.clear();
    _phoneNumberController.clear();
    _nextOfKinController.clear();
    _nextOfKinPhoneController.clear();
    setState(() {
      _selectedGender = null;
      _selectedRelationship = null;
      _selectedPatientType = null;
      _selectedInsurance = null;
      _selectedDate = null;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Save the patient data to the database
      final patient = {
        'idno': _idController.text,
        'name': _firstNameController.text,
        'surname': _surnameController.text,
        'middle_name': _middleNameController.text,
        'gender': _selectedGender,
        'date_of_birth': _selectedDate,
        'phone': _phoneNumberController.text,
        'next_of_kin': _nextOfKinController.text,
        'next_of_kin_phone': _nextOfKinPhoneController.text,
        'relationship': _selectedRelationship,
        'password': '1234567',
        'patient_type': _selectedPatientType,
        'insurance': _selectedInsurance,
      };

      await DatabaseHelper.instance.savePatient(patient);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Patient data saved successfully!")),
      );

      // Navigate to TriagePage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TriagePage(patientId: patient['idno'] as String),
                  
        ),
      );

      _resetForm();
    }
  }
}
