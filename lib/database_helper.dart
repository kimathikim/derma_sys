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
    CREATE TABLE patient (
      id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)), 2) || '-' || substr('89ab', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(2)), 2) || '-' || hex(randomblob(6)))),
      idno TEXT NOT NULL,
      name TEXT NOT NULL,
      surname TEXT,
      middle_name TEXT,
      gender TEXT,
      date_of_birth TEXT,
      phone TEXT,
      next_of_kin TEXT,
      next_of_kin_phone TEXT,
      relationship TEXT,
      patient_type TEXT,
      insurance TEXT,
      user_type TEXT CHECK(user_type IN ('patient', 'doctor')) NOT NULL,
      password TEXT NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      temperature REAL,
      blood_pressure TEXT,
      heart_rate INTEGER,
      respiratory_rate INTEGER,
      arrival_time TEXT,
      status TEXT CHECK(status IN ('Walk-In', 'Ambulance', 'Referral')),
      priority TEXT CHECK(priority IN ('Low', 'Medium', 'High'))
    );
  ''');

    await db.execute('''
    CREATE TABLE users (
      id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)), 2) || '-' || substr('89ab', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(2)), 2) || '-' || hex(randomblob(6)))),
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
  ''');

    await db.execute('''
    CREATE TABLE appointments (
      id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)), 2) || '-' || substr('89ab', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(2)), 2) || '-' || hex(randomblob(6)))),
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
  ''');

    await db.execute('''
    CREATE TABLE treatments (
      id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)), 2) || '-' || substr('89ab', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(2)), 2) || '-' || hex(randomblob(6)))),
      patientId TEXT NOT NULL,
      treatmentType TEXT,
      progress INTEGER DEFAULT 50,
      medication TEXT,
      observation TEXT NOT NULL,
      status TEXT CHECK(status IN('pending', 'completed')) DEFAULT 'pending'    );
  ''');

    await db.execute('''
    CREATE TABLE treatment_milestones (
      id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)), 2) || '-' || substr('89ab', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(2)), 2) || '-' || hex(randomblob(6)))),
      treatment_id TEXT NOT NULL,
      milestone_date TEXT,
      description TEXT,
      status TEXT CHECK(status IN ('upcoming', 'achieved', 'missed')) DEFAULT 'upcoming',
      FOREIGN KEY (treatment_id) REFERENCES treatments (id)
    );
  ''');

    await db.execute('''
    CREATE TABLE prescriptions (
      id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)), 2) || '-' || substr('89ab', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(2)), 2) || '-' || hex(randomblob(6)))),
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
  ''');

    await db.execute('''
    CREATE TABLE messages (
      id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)), 2) || '-' || substr('89ab', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(2)), 2) || '-' || hex(randomblob(6)))),
      sender_id TEXT NOT NULL,
      receiver_id TEXT NOT NULL,
      message_text TEXT NOT NULL,
      sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      is_read BOOLEAN DEFAULT 0,
      FOREIGN KEY (sender_id) REFERENCES users (id),
      FOREIGN KEY (receiver_id) REFERENCES users (id)
    );
  ''');

    await db.execute('''
    CREATE TABLE inventory (
      id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)), 2) || '-' || substr('89ab', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(2)), 2) || '-' || hex(randomblob(6)))),
      item_name TEXT NOT NULL,
      category TEXT CHECK(category IN ('medication', 'supply')) NOT NULL,
      quantity INTEGER DEFAULT 0,
      expiration_date TEXT,
      status TEXT CHECK(status IN ('in stock', 'low stock', 'out of stock', 'expiring soon')) DEFAULT 'in stock'
    );
  ''');

    await db.execute('''
    CREATE TABLE patient_records (
      id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)), 2) || '-' || substr('89ab', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(2)), 2) || '-' || hex(randomblob(6)))),
      patient_id TEXT NOT NULL,
      record_type TEXT CHECK(record_type IN ('diagnosis', 'test result', 'treatment note')) NOT NULL,
      title TEXT,
      description TEXT,
      created_by TEXT, -- Doctor who created the record
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (patient_id) REFERENCES users (id),
      FOREIGN KEY (created_by) REFERENCES users (id)
    );
  ''');

    await db.execute('''
    CREATE TABLE analytics (
      id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)), 2) || '-' || substr('89ab', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(2)), 2) || '-' || hex(randomblob(6)))),
      metric_name TEXT NOT NULL,
      metric_value REAL NOT NULL,
      metric_date TEXT DEFAULT (DATE('now'))
    );
  ''');
    await db.execute('''
  CREATE TABLE lab_details (
    id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)), 2) || '-' || substr('89ab', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(2)), 2) || '-' || hex(randomblob(6)))),
    patientId TEXT NOT NULL,
    testType TEXT NOT NULL,
    testResults TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patientId) REFERENCES users (id)
  );
''');

    await db.execute('''
    CREATE TABLE triage_patients (
      id TEXT PRIMARY KEY DEFAULT (lower(hex(randomblob(4)) || '-' || hex(randomblob(2)) || '-4' || substr(hex(randomblob(2)), 2) || '-' || substr('89ab', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(2)), 2) || '-' || hex(randomblob(6)))),
      name TEXT NOT NULL,
      status TEXT CHECK(status IN ('Walk-In', 'Observation', 'Procedure Queue')) NOT NULL,
      arrival_time TEXT NOT NULL,
      priority TEXT CHECK(priority IN ('High', 'Medium', 'Low')) NOT NULL
    );
  ''');
  } // --- Users Table CRUD ---

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

  Future<int> updateAppointment(
      String id, Map<String, dynamic> appointment) async {
    final db = await instance.database;
    return await db
        .update('appointments', appointment, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAppointment(String id) async {
    final db = await instance.database;
    return await db.delete('appointments', where: 'id = ?', whereArgs: [id]);
  }

  // --- Treatments Table CRUD ---

  Future<List<Map<String, dynamic>>> getTreatment(String patientId) async {
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
    return await db
        .update('treatments', treatment, where: 'id = ?', whereArgs: [id]);
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

  Future<List<Map<String, dynamic>>> getMessages(
      String userId, String contactId) async {
    final db = await instance.database;
    return await db.query(
      'messages',
      where:
          '(sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)',
      whereArgs: [userId, contactId, contactId, userId],
      orderBy: 'sent_at DESC',
    );
  }

  Future<int> updateMessage(String id, Map<String, dynamic> message) async {
    final db = await instance.database;
    return await db
        .update('messages', message, where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getPatient(String id) async {
    final db = await instance.database;

    final maps = await db.query(
      'patient',
      columns: [
        'id',
        'temperature',
        'blood_pressure',
        'heart_rate',
        'respiratory_rate',
        'arrival_time',
        'status',
        'priority'
      ],
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return null;
    }
  }

  Future<int> deleteMessage(String id) async {
    final db = await instance.database;
    return await db.delete('messages', where: 'id = ?', whereArgs: [id]);
  }

  // --- Triage Patients Table CRUD ---
  Future<int> addTriagePatient(Map<String, dynamic> triagePatient) async {
    final db = await instance.database;
    triagePatient['id'] = uuid.v4();
    return await db.insert('triage_patients', triagePatient);
  }

  Future<List<Map<String, dynamic>>> getTriagePatients() async {
    final db = await instance.database;
    return await db.query('triage_patients', orderBy: 'arrival_time DESC');
  }

  Future<Map<String, dynamic>?> getUserByEmailAndPassword(
      String email, String password) async {
    final db = await instance.database;

    final result = await db.query(
      'users',
      columns: ['id', 'name', 'email', 'user_type'],
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }

  Future<int> addTreatment(Map<String, dynamic> treatment) async {
    final db = await instance.database;
    treatment['id'] = uuid.v4();
    return await db.insert('treatments', treatment);
  }

  Future<List<Map<String, dynamic>>> getAllTreatments() async {
    final db = await instance.database;
    final result = await db.rawQuery('''
      SELECT
        p.id,
        p.name,
        t.treatmentType,
        t.medication,
        t.progress,
        t.status
      FROM treatments t
      JOIN patient p ON t.patientId = p.id
    ''');
    return result;
  }

  Future<int> updateTriagePatient(
      String id, Map<String, dynamic> triagePatient) async {
    final db = await instance.database;
    return await db.update('triage_patients', triagePatient,
        where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteTriagePatient(String id) async {
    final db = await instance.database;
    return await db.delete('triage_patients', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getAllPatients() async {
    final db = await instance.database;

    final result = await db.query('patient');

    return result;
  }

  Future<int> savePatient(Map<String, dynamic> patient) async {
    final db = await instance.database;
    patient['id'] = uuid.v4();
    patient['user_type'] = 'patient';
    return await db.insert('patient', patient);
  }

  Future<int> updatePatient(String idno, Map<String, dynamic> patient) async {
    final db = await instance.database;
    return await db.update(
      'patient',
      patient,
      where: 'idno = ?',
      whereArgs: [idno],
    );
  }

  Future<int> addLabDetails(Map<String, dynamic> labDetails) async {
    final db = await instance.database;
    labDetails['id'] = uuid.v4();
    return await db.insert('lab_details', labDetails);
  }

  Future<List<Map<String, dynamic>>> getLabDetails(String patientId) async {
    final db = await instance.database;
    return await db.query(
      'lab_details',
      where: 'patientId = ?',
      whereArgs: [patientId],
      orderBy: 'created_at DESC',
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
