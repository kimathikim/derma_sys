import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http; // For backend integration
import 'dart:convert'; // For encoding JSON
import 'dart:io';

class PatientProfilePage extends StatefulWidget {
  const PatientProfilePage({super.key});

  @override
  _PatientProfilePageState createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  XFile? _profileImage;

  // Simulate the patient's existing data
  @override
  void initState() {
    super.initState();
    _nameController.text = 'Jane Doe';
    _emailController.text = 'janedoe@example.com';
    _phoneController.text = '123-456-7890';
    _addressController.text = '123 Main St, Springfield, USA';
  }

  // Image picker for uploading profile picture
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = image;
      });
    }
  }

  // Validate email format
  String? _validateEmail(String? value) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Validate phone number format (simple example)
  String? _validatePhone(String? value) {
    final phoneRegex = RegExp(r'^\d{10}$');
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    } else if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  // Backend integration for saving profile
  Future<void> _saveProfile() async {
    final url = Uri.parse('https://your-backend-api.com/profile/update');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'address': _addressController.text,
          // Add more fields as needed
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      } else {
        throw Exception('Failed to update profile');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.toString()}')),
      );
    }
  }

  // Backend integration for changing password
  Future<void> _changePassword() async {
    final url = Uri.parse('https://your-backend-api.com/password/change');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'new_password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully!')),
        );
      } else {
        throw Exception('Failed to change password');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${error.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Profile'),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.signOutAlt),
            onPressed: () {
              // Implement logout functionality
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfilePicture(),
            const SizedBox(height: 20),
            _buildProfileForm(),
            const SizedBox(height: 20),
            _buildSaveButton(),
            const SizedBox(height: 10),
            _buildChangePasswordSection(),
          ],
        ),
      ),
    );
  }

  // Profile picture section
  Widget _buildProfilePicture() {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: _profileImage != null
              ? FileImage(File(_profileImage!.path)) as ImageProvider
              : const AssetImage('assets/default_avatar.png'),
        ),
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.camera_alt),
          label: const Text('Change Profile Picture'),
        ),
      ],
    );
  }

  // Form to edit profile details
  Widget _buildProfileForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(_nameController, 'Name', Icons.person),
          const SizedBox(height: 10),
          _buildTextField(_emailController, 'Email', Icons.email,
              TextInputType.emailAddress, _validateEmail),
          const SizedBox(height: 10),
          _buildTextField(_phoneController, 'Phone Number', Icons.phone,
              TextInputType.phone, _validatePhone),
          const SizedBox(height: 10),
          _buildTextField(_addressController, 'Address', Icons.home),
        ],
      ),
    );
  }

  // Generic text field widget for the profile form
  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      [TextInputType inputType = TextInputType.text,
      String? Function(String?)? validator]) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $label';
            }
            return null;
          },
    );
  }

  // Save button to submit profile changes
  Widget _buildSaveButton() {
    return ElevatedButton.icon(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _saveProfile();
        }
      },
      icon: const Icon(Icons.save),
      label: const Text('Save Changes'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Change password section with validation
  Widget _buildChangePasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Change Password',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        _buildPasswordField(_passwordController, 'New Password'),
        const SizedBox(height: 10),
        _buildPasswordField(_confirmPasswordController, 'Confirm New Password'),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {
            if (_passwordController.text != _confirmPasswordController.text) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Passwords do not match!')),
              );
            } else if (_passwordController.text.isEmpty ||
                _confirmPasswordController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Please fill in both password fields!')),
              );
            } else {
              _changePassword();
            }
          },
          icon: const Icon(Icons.lock),
          label: const Text('Change Password'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  // Password field for changing passwords
  Widget _buildPasswordField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
