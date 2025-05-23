import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:path_provider/path_provider.dart';
import 'package:qonnect/utils/handlers/flutter_secure_storage_handler.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as sqlFFi;

class DBHelper {
  static Database? _database;
  static var dbPassword;
  static final secureStorage = FlutterSecureStorageHandler().secureStorage;

  static String generateRandomString(int length) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final math.Random random = math.Random.secure();
    return List.generate(
      length,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
    return List.generate(
      length,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }

  // Initialize the database
  static Future<Database> initDB() async {
    if (_database != null) return _database!;

    // String path = join(await getDatabasesPath(), 'chat_database.db');
    // print("Path: $path");
    final directory =
        Platform.isAndroid
            ? await getExternalStorageDirectory()
            : await getApplicationDocumentsDirectory();
    final path = '${directory?.path}/databases/chat_database.db';
    final file = File(path);
    log("Path: $path");

    dbPassword = await secureStorage.read(key: 'encryptionPassword');
    if (dbPassword == null || dbPassword.isEmpty) {
      dbPassword = generateRandomString(16);
      await secureStorage.write(key: 'encryptionPassword', value: dbPassword);
    }

    // Open the database with encryption password
    _database =
        Platform.isLinux
            ? await sqlFFi.databaseFactoryFfi
                .openDatabase(
                  path,
                  // password: '1234',
                  options: sqlFFi.OpenDatabaseOptions(
                    version: 1,
                    onCreate: (db, version) async {
                      await db.execute(
                        '''CREATE TABLE contacts(recID INTEGER PRIMARY KEY, name TEXT, lastMsg TEXT, timeStamp TEXT, isSender INTEGER, message_status TEXT DEFAULT 'not_delivered')''',
                      );
                      await db.execute(
                        '''CREATE TABLE messages(id INTEGER PRIMARY KEY, sender TEXT, receiver TEXT, message TEXT, path TEXT, message_type TEXT, uuidId TEXT, timestamp TEXT, message_id TEXT, message_reaction TEXT, message_status TEXT DEFAULT 'not_delivered' )''',
                      );
                      await db.execute(
                        'CREATE TABLE ownerInfo(userID INTEGER, userName TEXT, email TEXT)',
                      );
                      await db.execute(
                        'CREATE TABLE callDetails(id INTEGER PRIMARY KEY, callerId TEXT, receiverId TEXT, receiverName TEXT, call_type TINYINT, roomId TEXT, start_call_timestamp TEXT, call_status TINYINT )',
                      );
                      await db.execute(
                        'CREATE TABLE groupDetails(roomId TEXT PRIMARY KEY, sender TEXT, participants TEXT, groupName TEXT, lastMsg TEXT, timeStamp TEXT, isSender INTEGER)',
                      );
                      await db.execute(
                        '''CREATE TABLE groupMessages(id INTEGER PRIMARY KEY, roomId TEXT, sender TEXT, participants TEXT, message TEXT, path TEXT, message_type TEXT, uuid TEXT, timeStamp TEXT, message_reaction TEXT, message_status TEXT DEFAULT 'not_delivered')''',
                      );
                      // await db.execute('CREATE TABLE calllogs()');
                    },
                  ),
                )
                .onError((error, _) {
                  throw error.toString();
                })
            : await openDatabase(
              path,
              // password: '1234',
              password: dbPassword,
              onCreate: (db, version) async {
                await db.execute(
                  '''CREATE TABLE contacts(recID INTEGER PRIMARY KEY, name TEXT, lastMsg TEXT, timeStamp TEXT, isSender INTEGER, message_status TEXT DEFAULT 'not_delivered')''',
                );
                await db.execute(
                  '''CREATE TABLE messages(id INTEGER PRIMARY KEY, sender TEXT, receiver TEXT, message TEXT, path TEXT, message_type TEXT, uuidId TEXT, timestamp TEXT, message_id TEXT, message_reaction TEXT, message_status TEXT DEFAULT 'not_delivered' )''',
                );
                await db.execute(
                  'CREATE TABLE ownerInfo(userID INTEGER, userName TEXT, email TEXT)',
                );
                await db.execute(
                  'CREATE TABLE callDetails(id INTEGER PRIMARY KEY, callerId TEXT, receiverId TEXT, receiverName TEXT, call_type TINYINT, roomId TEXT, start_call_timestamp TEXT, call_status TINYINT )',
                );
                await db.execute(
                  'CREATE TABLE groupDetails(roomId TEXT PRIMARY KEY, sender TEXT, participants TEXT, groupName TEXT, lastMsg TEXT, timeStamp TEXT, isSender INTEGER)',
                );
                await db.execute(
                  '''CREATE TABLE groupMessages(id INTEGER PRIMARY KEY, roomId TEXT, sender TEXT, participants TEXT, message TEXT, path TEXT, message_type TEXT, uuid TEXT, timeStamp TEXT, message_reaction TEXT, message_status TEXT DEFAULT 'not_delivered')''',
                );
                // await db.execute('CREATE TABLE calllogs()');
              },
              version: 1,
            ).onError((error, _) {
              throw error.toString();
            });
    return _database!;
  }

  // For ownerInfo table
  static Future<void> insertOwnerInfo(int id, String name, String email) async {
    final db = await initDB();
    try {
      int newId = await db.insert('ownerInfo', {
        'userID': id,
        'userName': name,
        'email': email,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      log("Inserted row ID: $newId", name: "OwnerInfo Insert");

      // Fetch and print the inserted row
      List<Map<String, dynamic>> result = await db.rawQuery(
        '''
      SELECT * FROM ownerInfo WHERE userID = ?
    ''',
        [id],
      );

      if (result.isNotEmpty) {
        log("Inserted row: ${result.first}");
      } else {
        log("No row found with userID: $id");
      }
    } catch (error) {
      log("The error in updating message_id is: $error");
    }
  }

  // For ownerInfo table
  static Future<List<Map<String, dynamic>>> getOwnerInfo() async {
    final db = await initDB();
    return await db.query('ownerInfo');
  }

  // For contacts table
  static Future<int> insertContact(String name, int recID) async {
    final db = await initDB();
    int id = await db.insert('contacts', {
      'name': name,
      'recID': recID,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    log("recent contacts added");
    return id;
  }

  // For contacts table
  static Future<List<Map<String, dynamic>>> getContacts() async {
    final db = await initDB();

    List<Map<String, dynamic>> res = await db.rawQuery('''
    SELECT * FROM contacts
    ''');
    if (res.isNotEmpty) {
      log("Row after update: $res");
    } else {
      log("No row found.");
    }
    return await db.query('contacts', orderBy: 'timeStamp DESC');
  }

  // For messages table ----- Insert a message into the database
  static Future<int> insertMessage(
    String sender,
    String receiver,
    String message,
    String path,
    String messageType,
    String uuidId,
    String timestamp,
    String messageId,
    String messageReaction,
  ) async {
    final db = await initDB();
    int id = await db.insert('messages', {
      'sender': sender,
      'receiver': receiver,
      'message': message,
      'path': path,
      'message_type': messageType,
      'uuidId': uuidId,
      'timestamp': timestamp,
      'message_id': messageId,
      'message_reaction': messageReaction,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    log("Message added successfully");
    return id;
  }

  // For messages table ----- Fetch messages between two users
  static Future<List<Map<String, dynamic>>> getMessages(
    String currentUserId,
    String peerId,
  ) async {
    final db = await initDB();
    return await db.query(
      'messages',
      where: '(sender = ? AND receiver = ?) OR (sender = ? AND receiver = ?)',
      whereArgs: [currentUserId, peerId, peerId, currentUserId],
      orderBy: 'timestamp ASC',
    );
  }

  // For messages table
  static Future<void> updateMessageWithId(
    String messageId,
    String uuidId,
  ) async {
    final db = await initDB();
    log("Updating message with ID: $messageId");

    try {
      int count = await db.rawUpdate(
        '''
      UPDATE messages 
      SET message_id = ? 
      WHERE uuidId = ?
      ''',
        [messageId, uuidId],
      );
      log("Number of rows updated: $count");
    } catch (error) {
      log("The error in updating message_id is: $error");
    }
    List<Map<String, dynamic>> res = await db.rawQuery(
      '''
    SELECT * FROM messages
    WHERE uuidId = ?
    ''',
      [uuidId],
    );
    if (res.isNotEmpty) {
      log("Row after update: $res");
    } else {
      log("No row found with uuid: $uuidId");
    }
  }

  // For messages table
  static Future<void> updateMessagesWithReaction(
    String messageReaction,
    String uuidId,
  ) async {
    final db = await initDB();
    log("Updating message with Reaction $messageReaction");
    try {
      int count = await db.rawUpdate(
        '''
          UPDATE messages
          SET message_reaction = ?
          WHERE uuidId = ?
       ''',
        [messageReaction, uuidId],
      );
      log("Number of rows updated due to message reaction $count");
    } catch (error) {
      log("Updating messages reaction cought an error ${error.toString()}");
    }
  }

  // For messages table ----- Delete all messages
  static Future<void> deleteMessages() async {
    final db = await initDB();
    await db.delete('messages');
  }

  // For messages table
  static Future<void> deleteOneMessage(int messageId) async {
    log("Inside delete function");
    final db = await initDB();
    try {
      await db.delete('messages', where: 'id = ?', whereArgs: [messageId]);
    } catch (error) {
      log("The error in deletion is: $error");
    }
  }

  // For messages table
  static Future<void> updateFilePath(
    String temporaryFilePath,
    permanentFilePath,
  ) async {
    final db = await initDB();
    try {
      await db.rawUpdate(
        '''
          UPDATE messages
          SET path = ?
          WHERE path = ?
       ''',
        [permanentFilePath, temporaryFilePath],
      );
    } catch (error) {
      log("Error in updating the file path: $error");
    }
  }

  // For messages table
  static Future<String> retrieveUuid(int messageId) async {
    final db = await initDB();
    String uuid = '';
    try {
      List<Map<String, dynamic>> result = await db.query(
        'messages',
        columns: ['uuidId'],
        where: 'id = ?',
        whereArgs: [messageId],
      );

      if (result.isNotEmpty) {
        uuid = result[0]['uuidId'];
        log("Uuid of Message is: $uuid");
      } else {
        log("No message found with uuid $messageId");
      }
    } catch (error) {
      log("The error is: $error");
    }
    return uuid;
  }

  // For messages table
  static Future<void> updateMessageToDeleted(int messageId) async {
    final db = await initDB();
    try {
      await db.update(
        'messages',
        {
          'message': 'You deleted this message',
          'path': '',
          'message_type': 'text',
        },
        where: 'id = ?',
        whereArgs: [messageId],
      );
      log("Message updated to 'You deleted this message'");
    } catch (error) {
      log("The error is: $error");
    }
  }

  // For messages table
  static Future<void> updateMessageToDeleted2(String uuid) async {
    final db = await initDB();
    try {
      await db.update(
        'messages',
        {
          'message': 'You deleted this message',
          'path': '',
          'message_type': 'text',
        },
        where: 'uuidId = ?',
        whereArgs: [uuid],
      );
      log("Message updated to 'You deleted this message'");
    } catch (error) {
      log("The error is: $error");
    }
  }

  // For contacts table
  static Future<void> updateContactsWithLastMsg(
    int receiverId,
    String name,
    String lastMessage,
    String timeStamp,
    int isSender,
  ) async {
    final db = await initDB();
    log("Processing contact with ID: $receiverId");

    try {
      // Check if the user already exists in the table
      List<Map<String, dynamic>> existingContact = await db.rawQuery(
        '''
    SELECT * FROM contacts 
    WHERE recID = ?
    ''',
        [receiverId],
      );

      if (existingContact.isNotEmpty) {
        int count = await db.rawUpdate(
          '''
      UPDATE contacts 
      SET lastMsg = ?, timeStamp = ?, isSender = ?
      WHERE recID = ?
      ''',
          [lastMessage, timeStamp, isSender, receiverId],
        );
        log("Number of rows updated: $count");
      } else {
        int id = await db.rawInsert(
          '''
      INSERT INTO contacts (recID, name, lastMsg, timeStamp, isSender)
      VALUES (?, ?, ?, ?, ?)
      ''',
          [receiverId, name, lastMessage, timeStamp, isSender],
        );
        log("Inserted new contact with ID: $id");
      }
    } catch (error) {
      log("The error in updating message_id is: $error");
    }
    List<Map<String, dynamic>> result = await db.rawQuery(
      '''
    SELECT * FROM contacts 
    WHERE recID = ?
    ''',
      [receiverId],
    );

    if (result.isNotEmpty) {
      log("Updated row: ${result.first}");
    } else {
      log("No row found with userID: $receiverId");
    }
  }

  static Future<void> updateMessageStatus(String status, String uuId) async {
    final db = await initDB();

    // List<Map<String, dynamic>> result = await db.rawQuery('''
    // SELECT * FROM messages
    // WHERE uuidId = ?
    // ''', [uuId]);
    // if (result.isNotEmpty) {
    //   log("Row before update: $result");
    // } else {
    //   log("No row found with uuid: $uuId");
    // }
    try {
      log(status, name: "Message status inside DB update function");
      int count = await db.rawUpdate(
        '''
      UPDATE messages 
      SET message_status = ?
      WHERE uuidId = ?
      ''',
        [status, uuId],
      );
      log("Number of rows updated for message_staus: $count");
    } catch (error) {
      log("The error in updating message_staus is: $error");
    }

    List<Map<String, dynamic>> res = await db.rawQuery(
      '''
    SELECT * FROM messages
    WHERE uuidId = ?
    ''',
      [uuId],
    );
    if (res.isNotEmpty) {
      log("Row after update11111111111111111111111111: $res");
    } else {
      log("No row found with uuid: $uuId");
    }
  }

  static Future<void> updateMessageStatusReceivedToRead(String sender) async {
    final db = await initDB();
    try {
      int count = await db.rawUpdate(
        '''
      UPDATE messages 
      SET message_status = ? 
      WHERE message_status = ? AND sender = ?
    ''',
        ['read', 'received', sender],
      );
      log("Number of rows updated for message_status: $count");
    } catch (error, stackTrace) {
      log("Error updating message_status: $error");
      log("StackTrace: $stackTrace");
    }
  }

  static Future<void> updateMessageStatusDeliveredToRead(
    String receiver,
  ) async {
    final db = await initDB();
    try {
      int count = await db.rawUpdate(
        '''
      UPDATE messages 
      SET message_status = ? 
      WHERE message_status = ? AND receiver = ?
    ''',
        ['read', 'delivered', receiver],
      );
      log(
        "Number of rows updated for message_status in updateMessageStatusDeliveredToRead function: $count",
      );
    } catch (error, stackTrace) {
      log("Error updating message_status: $error");
      log("StackTrace: $stackTrace");
    }
  }

  // For callDetails table -- insert call details
  // 0 - Audio Call and 1 - Video Call
  // 0 - Missed Call, 1 - Outgoing Call, 2- Incoming Call
  static Future<void> insertCalls(
    String callerId,
    String receiverId,
    String receiverName,
    String timeStamp,
    String roomId,
    bool callType,
    int callStatus,
  ) async {
    final db = await initDB();
    int callTypeinBool;
    if (callType) {
      callTypeinBool = 1;
    } else {
      callTypeinBool = 0;
    }
    try {
      await db.insert('callDetails', {
        'callerId': callerId,
        'receiverId': receiverId,
        'receiverName': receiverName,
        'call_type': callTypeinBool,
        'roomId': roomId,
        'start_call_timestamp': timeStamp,
        'call_status': callStatus,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      // log("callDetails table updated with id: $id");
    } catch (error) {
      log("The error in inserting call in the callDetails table is: $error");
    }
  }

  // For callDetails table ----- Fetch calls between two users
  static Future<List<Map<String, dynamic>>> getCalls() async {
    final db = await initDB();
    return await db.query('callDetails', orderBy: 'start_call_timestamp DESC');
  }

  // For Group Functionality
  static Future<void> insertGroupDetails(
    String roomId,
    String groupName,
    String lastMsg,
    String timeStamp,
    int isSender,
    String participants,
    String sender,
  ) async {
    final db = await initDB();
    try {
      await db.insert('groupDetails', {
        'roomId': roomId,
        'participants': participants,
        'groupName': groupName,
        'lastMsg': lastMsg,
        'timeStamp': timeStamp,
        'isSender': isSender,
        // 'admins': adminList,
        'sender': sender,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      // log("callDetails table updated with id: $id");
    } catch (error) {
      log(
        "The error in inserting group details in the groupDetails table is: $error",
      );
    }
  }

  static Future<void> updateGroupDetailsWithLastMessage(
    String roomId,
    String groupName,
    String lastMsg,
    String timeStamp,
    int isSender,
    String participants,
    String sender,
  ) async {
    final db = await initDB();
    try {
      await db.update(
        'groupDetails',
        {
          'participants': participants,
          'lastMsg': lastMsg,
          'timeStamp': timeStamp,
          'isSender': isSender,
          // 'admins': adminList,
          'sender': sender,
        },
        where: 'roomId = ?',
        whereArgs: [roomId],
      );
      log("Last entry in groupDetails updated successfully.");
      // log("callDetails table updated with id: $id");
    } catch (error) {
      log(
        "The error in updating group details in the groupDetails table is: $error",
      );
    }
  }

  static Future<List<Map<String, dynamic>>> getGroups() async {
    final db = await initDB();
    return await db.query('groupDetails', orderBy: 'timestamp DESC');
  }

  static Future<int> insertGroupMessage(
    String roomId,
    String sender,
    String receivers,
    String message,
    String path,
    String messageType,
    String uuidId,
    String timestamp,
    String messageReaction,
  ) async {
    final db = await initDB();
    int id = await db.insert('groupMessages', {
      'roomId': roomId,
      'sender': sender,
      'participants': receivers,
      'message': message,
      'path': path,
      'message_type': messageType,
      'uuid': uuidId,
      'timestamp': timestamp,
      'message_reaction': messageReaction,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    log("Message added successfully in the groupMessages table");
    return id;
  }

  static Future<List<Map<String, dynamic>>> getGroupMessages(
    String roomId,
  ) async {
    final db = await initDB();
    return await db.query(
      'groupMessages',
      where: 'roomId = ?',
      whereArgs: [roomId],
      orderBy: 'timestamp ASC',
    );
  }

  // For groupMessages table
  static Future<void> updateGroupFilePath(
    String temporaryFilePath,
    permanentFilePath,
  ) async {
    final db = await initDB();
    try {
      await db.rawUpdate(
        '''
          UPDATE groupMessages
          SET path = ?
          WHERE path = ?
       ''',
        [permanentFilePath, temporaryFilePath],
      );
    } catch (error) {
      log("Error in updating the file path: $error");
    }
  }
}
