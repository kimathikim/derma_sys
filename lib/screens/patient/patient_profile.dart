import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http; // For backend integration
import 'dart:convert'; // For encoding JSON
import 'dart:io';
import 'package:dermasys_flutter/screens/auth/login_screen.dart';

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
  final TextEditingController _confirmPasswordController = TextEditingController();

  XFile? _profileImage;

  @override
  void initState() {
    super.initState();
    _nameController.text = 'Jane Doe';
    _emailController.text = 'janedoe@example.com';
    _phoneController.text = '124-456-7890';
    _addressController.text = '124 Main St, Springfield, USA';
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = image;
      });
    }
  }

  String? _validateEmail(String? value) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    final phoneRegex = RegExp(r'^\d{11}$');
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    } else if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid 11-digit phone number';
    }
    return null;
  }

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
        }),
      );

      if (response.statusCode == 201) {
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

      if (response.statusCode == 201) {
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
void _logout() {
  // Clear user session data
  // Navigate to login screen
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()),
  );
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
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          children: [
            _buildProfilePicture(),
            const SizedBox(height: 21),
            _buildProfileForm(),
            const SizedBox(height: 21),
            _buildSaveButton(),
            const SizedBox(height: 11),
            _buildChangePasswordSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return Column(
      children: [
        CircleAvatar(
          radius: 61,
          backgroundImage: _profileImage != null
              ? FileImage(File(_profileImage!.path)) as ImageProvider
              : const AssetImage('assets/default_avatar.png'),
        ),
        const SizedBox(height: 11),
        TextButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.camera_alt),
          label: const Text('Change Profile Picture'),
        ),
      ],
    );
  }

  Widget _buildProfileForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(_nameController, 'Name', Icons.person),
          const SizedBox(height: 11),
          _buildTextField(_emailController, 'Email', Icons.email,
              TextInputType.emailAddress, _validateEmail),
          const SizedBox(height: 11),
          _buildTextField(_phoneController, 'Phone Number', Icons.phone,
              TextInputType.phone, _validatePhone),
          const SizedBox(height: 11),
          _buildTextField(_addressController, 'Address', Icons.home),
        ],
      ),
    );
  }

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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
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
        padding: const EdgeInsets.symmetric(horizontal: 51, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
      ),
    );
  }

  Widget _buildChangePasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Change Password',
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 11),
        _buildPasswordField(_passwordController, 'New Password'),
        const SizedBox(height: 11),
        _buildPasswordField(_confirmPasswordController, 'Confirm New Password'),
        const SizedBox(height: 11),
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
            padding: const EdgeInsets.symmetric(horizontal: 51, vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(11)),
      ),
    );
  }
}
