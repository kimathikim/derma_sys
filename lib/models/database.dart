import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  static const uuid = Uuid(); // Initialize UUID generator

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('dermasys.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT UNIQUE,
        phone TEXT,
        profile_picture TEXT,
        user_type TEXT CHECK(user_type IN ('patient', 'doctor')) NOT NULL,
        specialization TEXT,
        date_of_birth TEXT,
        gender TEXT CHECK(gender IN ('male', 'female', 'other')),
        password TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      CREATE TABLE appointments (
        id TEXT PRIMARY KEY,
        patient_id TEXT NOT NULL,
        doctor_id TEXT NOT NULL,
        appointment_date TEXT NOT NULL,
        appointment_time TEXT NOT NULL,
        reason TEXT,
        status TEXT CHECK(status IN ('scheduled', 'completed', 'cancelled')) DEFAULT 'scheduled',
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (patient_id) REFERENCES users (id),
        FOREIGN KEY (doctor_id) REFERENCES users (id)
      );

      CREATE TABLE treatments (
        id TEXT PRIMARY KEY,
        patient_id TEXT NOT NULL,
        doctor_id TEXT NOT NULL,
        treatment_name TEXT NOT NULL,
        start_date TEXT,
        progress INTEGER CHECK(progress BETWEEN 0 AND 100) DEFAULT 0,
        status TEXT CHECK(status IN ('ongoing', 'completed', 'paused')) DEFAULT 'ongoing',
        description TEXT,
        FOREIGN KEY (patient_id) REFERENCES users (id),
        FOREIGN KEY (doctor_id) REFERENCES users (id)
      );

      CREATE TABLE treatment_milestones (
        id TEXT PRIMARY KEY,
        treatment_id TEXT NOT NULL,
        milestone_date TEXT,
        description TEXT,
        status TEXT CHECK(status IN ('upcoming', 'achieved', 'missed')) DEFAULT 'upcoming',
        FOREIGN KEY (treatment_id) REFERENCES treatments (id)
      );

      CREATE TABLE prescriptions (
        id TEXT PRIMARY KEY,
        treatment_id TEXT,
        patient_id TEXT NOT NULL,
        doctor_id TEXT NOT NULL,
        medication_name TEXT NOT NULL,
        dosage TEXT NOT NULL,
        frequency TEXT,
        prescribed_on TEXT DEFAULT (DATE('now')),
        FOREIGN KEY (treatment_id) REFERENCES treatments (id),
        FOREIGN KEY (patient_id) REFERENCES users (id),
        FOREIGN KEY (doctor_id) REFERENCES users (id)
      );

      CREATE TABLE messages (
        id TEXT PRIMARY KEY,
        sender_id TEXT NOT NULL,
        receiver_id TEXT NOT NULL,
        message_text TEXT NOT NULL,
        sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        is_read BOOLEAN DEFAULT 0,
        FOREIGN KEY (sender_id) REFERENCES users (id),
        FOREIGN KEY (receiver_id) REFERENCES users (id)
      );

      CREATE TABLE inventory (
        id TEXT PRIMARY KEY,
        item_name TEXT NOT NULL,
        category TEXT CHECK(category IN ('medication', 'supply')) NOT NULL,
        quantity INTEGER DEFAULT 0,
        expiration_date TEXT,
        status TEXT CHECK(status IN ('in stock', 'low stock', 'out of stock', 'expiring soon')) DEFAULT 'in stock'
      );

      CREATE TABLE patient_records (
        id TEXT PRIMARY KEY,
        patient_id TEXT NOT NULL,
        record_type TEXT CHECK(record_type IN ('diagnosis', 'test result', 'treatment note')) NOT NULL,
        title TEXT,
        description TEXT,
        created_by TEXT, -- Doctor who created the record
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (patient_id) REFERENCES users (id),
        FOREIGN KEY (created_by) REFERENCES users (id)
      );

      CREATE TABLE analytics (
        id TEXT PRIMARY KEY,
        metric_name TEXT NOT NULL,
        metric_value REAL NOT NULL,
        metric_date TEXT DEFAULT (DATE('now'))
      );
    ''');
  }

  // --- Users Table CRUD ---
  Future<int> addUser(Map<String, dynamic> user) async {
    final db = await instance.database;
    user['id'] = uuid.v4();
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUser(String id) async {
    final db = await instance.database;
    final result = await db.query('users', where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateUser(String id, Map<String, dynamic> user) async {
    final db = await instance.database;
    return await db.update('users', user, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteUser(String id) async {
    final db = await instance.database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  // --- Appointments Table CRUD ---
  Future<int> addAppointment(Map<String, dynamic> appointment) async {
    final db = await instance.database;
    appointment['id'] = uuid.v4();
    return await db.insert('appointments', appointment);
  }

  Future<List<Map<String, dynamic>>> getAppointments(String patientId) async {
    final db = await instance.database;
    return await db.query(
      'appointments',
      where: 'patient_id = ?',
      whereArgs: [patientId],
      orderBy: 'appointment_date DESC, appointment_time DESC',
    );
  }

  Future<int> updateAppointment(String id, Map<String, dynamic> appointment) async {
    final db = await instance.database;
    return await db.update('appointments', appointment, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAppointment(String id) async {
    final db = await instance.database;
    return await db.delete('appointments', where: 'id = ?', whereArgs: [id]);
  }

  // --- Treatments Table CRUD ---
  Future<int> addTreatment(Map<String, dynamic> treatment) async {
    final db = await instance.database;
    treatment['id'] = uuid.v4();
    return await db.insert('treatments', treatment);
  }

  Future<List<Map<String, dynamic>>> getTreatments(String patientId) async {
    final db = await instance.database;
    return await db.query(
      'treatments',
      where: 'patient_id = ?',
      whereArgs: [patientId],
      orderBy: 'start_date DESC',
    );
  }

  Future<int> updateTreatment(String id, Map<String, dynamic> treatment) async {
    final db = await instance.database;
    return await db.update('treatments', treatment, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteTreatment(String id) async {
    final db = await instance.database;
    return await db.delete('treatments', where: 'id = ?', whereArgs: [id]);
  }

  // --- Messages Table CRUD ---
  Future<int> addMessage(Map<String, dynamic> message) async {
    final db = await instance.database;
    message['id'] = uuid.v4();
    return await db.insert('messages', message);
  }

  Future<List<Map<String, dynamic>>> getMessages(String userId, String contactId) async {
    final db = await instance.database;
    return await db.query(
      'messages',
      where: '(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)',
      whereArgs: [userId, contactId, contactId, userId],
      orderBy: 'sent_at DESC',
    );
  }

  Future<int> updateMessage(String id, Map<String, dynamic> message) async {
    final db = await instance.database;
    return await db.update('messages', message, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteMessage(String id) async {
    final db = await instance.database;
    return await db.delete('messages', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

