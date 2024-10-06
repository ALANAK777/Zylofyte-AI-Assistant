// ChatDatabaseHelper.dart
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ChatDatabaseHelper {
  static final ChatDatabaseHelper _instance = ChatDatabaseHelper._privateConstructor();
  ChatDatabaseHelper._privateConstructor();
  factory ChatDatabaseHelper() => _instance;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), 'chat_database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE chats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT,
        userName TEXT,
        userImage TEXT,
        message TEXT,
        timestamp TEXT
      )
    ''');
  }

  Future<int> insertChat(ChatMessage chatMessage) async {
    Database db = await database;
    return await db.insert('chats', {
      'userId': chatMessage.user.id,
      'userName': chatMessage.user.firstName,
      'userImage': chatMessage.user.profileImage,
      'message': chatMessage.text,
      'timestamp': chatMessage.createdAt.toIso8601String(),
    });
  }

  Future<List<ChatMessage>> getChats() async {
    Database db = await database;
    List<Map<String, dynamic>> chatMaps = await db.query('chats', orderBy: 'timestamp DESC');

    return List.generate(chatMaps.length, (i) {
      return ChatMessage(
        user: ChatUser(
          id: chatMaps[i]['userId'],
          firstName: chatMaps[i]['userName'],
          profileImage: chatMaps[i]['userImage'],
        ),
        createdAt: DateTime.parse(chatMaps[i]['timestamp']),
        text: chatMaps[i]['message'],
      );
    });
  }
}
