import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('job_app.db');
    return _database!;
  }

  // Initialize database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Create tables
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT UNIQUE,
        phone TEXT,
        role TEXT,
        avatar TEXT,
        password TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE companies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        industry TEXT,
        location TEXT,
        description TEXT,
        logo TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE jobs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        companyId INTEGER,
        description TEXT,
        requirements TEXT,
        salary TEXT,
        location TEXT,
        jobType TEXT,
        FOREIGN KEY (companyId) REFERENCES companies (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE chats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        senderId INTEGER,
        receiverId INTEGER,
        message TEXT,
        timestamp TEXT,
        FOREIGN KEY (senderId) REFERENCES users (id),
        FOREIGN KEY (receiverId) REFERENCES users (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE applications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        jobId INTEGER,
        status TEXT,
        appliedAt TEXT,
        FOREIGN KEY (userId) REFERENCES users (id),
        FOREIGN KEY (jobId) REFERENCES jobs (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE notifications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        title TEXT,
        message TEXT,
        timestamp TEXT,
        isRead INTEGER DEFAULT 0,
        FOREIGN KEY (userId) REFERENCES users (id)
      );
    ''');

    await db.execute('''
      CREATE TABLE saved_jobs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        jobId INTEGER,
        savedAt TEXT,
        FOREIGN KEY (userId) REFERENCES users (id),
        FOREIGN KEY (jobId) REFERENCES jobs (id)
      );
    ''');
  }

  // Close the database
  Future close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  // Delete the database (for testing or reset)
  Future<void> deleteDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'job_app.db');
    await deleteDatabase(path);
    _database = null;
  }
}
