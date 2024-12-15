import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Import the package
import 'package:dermasys_flutter/themes/theme.dart';
import 'package:dermasys_flutter/screens/auth/login_screen.dart';
import 'package:dermasys_flutter/screens/auth/signup_screen.dart';
import 'package:dermasys_flutter/database_helper.dart'; // Import the DatabaseHelper
import 'package:path/path.dart'; // Import the path package

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized

  sqfliteFfiInit();  // Initialize the FFI system
  databaseFactory = databaseFactoryFfi; // Set the database factory to FFI-based implementation

  // await deleteDatabaseFile();

  await initializeDatabase();

  await printDatabasePath(); // Print the database path

  runApp(const MyApp()); // Launch the app
}

// Function to delete the existing database file
Future<void> deleteDatabaseFile() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'dermasys.db');
  await deleteDatabase(path);
}

// Function to initialize the database
Future<void> initializeDatabase() async {
  final dbHelper = DatabaseHelper.instance;
  await dbHelper.database; 
}

Future<void> printDatabasePath() async {
  final path = await DatabaseHelper.instance.getDatabasePath();
  print('Database path: $path');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DermaSys',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/signup': (context) => const DoctorSignupPage(),
      },
    );
  }
}
