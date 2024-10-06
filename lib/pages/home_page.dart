import 'dart:io';
import 'dart:typed_data';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import services library
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:friday/service/auth.dart'; // Import AuthMethods
import 'package:friday/ChatDatabaseHelper.dart'; // Ensure this is correctly imported

class HomePage extends StatefulWidget {
 const HomePage({super.key});

 @override
 State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 final Gemini gemini = Gemini.instance;
 final ChatDatabaseHelper _dbHelper = ChatDatabaseHelper();

 List<ChatMessage> messages = [];
 ChatUser currentUser = ChatUser(id: '0', firstName: "User");
 ChatUser geminiUser = ChatUser(id: "1", firstName: "Zylo", profileImage: "https://res.cloudinary.com/dr8csfvlj/image/upload/v1712400455/Chat_app/iron_chat_2_enbliw.jpg");

 @override
 void initState() {
    super.initState();
    _loadMessages();
 }

 Future<void> _loadMessages() async {
    List<ChatMessage> loadedMessages = await _dbHelper.getChats();
    setState(() {
      messages = loadedMessages;
    });
 }

 void _sendMessage(ChatMessage chatMessage) async {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    _dbHelper.insertChat(chatMessage); // Save to database

    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [File(chatMessage.medias!.first.url).readAsBytesSync()];
      }
      String accumulatedResponse = "";
      gemini.streamGenerateContent(question, images: images).listen((event) {
        String part = event.content?.parts?.first.text ?? "";
        accumulatedResponse += " " + part;
      }).onDone(() {
        ChatMessage responseMessage = ChatMessage(
          user: geminiUser,
          createdAt: DateTime.now(),
          text: accumulatedResponse,
        );
        setState(() {
          messages = [responseMessage, ...messages];
        });
        _dbHelper.insertChat(responseMessage); // Save response to database
      });
    } catch (e) {
      print("Error sending message: $e");
    }
 }

 void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      final String? description = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          final TextEditingController controller = TextEditingController();
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Text('Describe this picture', style: TextStyle(color: Color(0xFF00FFF6))),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Enter your description here",
                hintStyle: TextStyle(color: Color(0xFF00FFF6)),
                fillColor: Colors.black,
                filled: true,
              ),
              style: TextStyle(color: Color(0xFF00FFF6)),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel', style: TextStyle(color: Color(0xFF00FFF6))),
                onPressed: () {
                 Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Send', style: TextStyle(color: Color(0xFF00FFF6))),
                onPressed: () {
                 Navigator.of(context).pop(controller.text);
                },
              ),
            ],
          );
        },
      );
      if (description != null && description.isNotEmpty) {
        ChatMessage chatMessage = ChatMessage(
          user: currentUser,
          createdAt: DateTime.now(),
          text: description,
          medias: [ChatMedia(url: file.path, fileName: "", type: MediaType.image)]
        );
        _sendMessage(chatMessage);
      }
    }
 }

 @override
 Widget build(BuildContext context) {
      return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "ZYLOFYTE",
              style: TextStyle(
                fontFamily: 'Silkscreen',
                fontWeight: FontWeight.bold,
                color: const Color(0xFF00FFF6),
              ),
            ),
            backgroundColor: Colors.black, // Set the AppBar background color to black
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Color(0xFF00FFF6)), // Custom back button with desired color
              onPressed: () async {
                bool? confirmExit = await showDialog(
                 context: context,
                 builder: (context) => AlertDialog(
                    title: Text('Confirm Exit'),
                    content: Text('Do you want to exit?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('No'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('Yes'),
                      ),
                    ],
                 ),
                );
                if (confirmExit == true) {
                 SystemNavigator.pop(); // Exit the app
                }
              },
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.logout, color: Color(0xFF00FFF6)), // Logout icon with desired color
                onPressed: () async {
                 bool? confirmLogout = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Confirm Logout'),
                      content: Text('Are you sure you want to logout?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('No'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('Yes'),
                        ),
                      ],
                    ),
                 );
                 if (confirmLogout == true) {
                    AuthMethods().signOut(context);
                 }
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                 image: DecorationImage(
                    image: AssetImage('assets/background_1.jpeg'),
                    fit: BoxFit.cover,
                 ),
                ),
              ),
              Container(
                child: _buildUI(),
              ),
            ],
          ),
        ),
      );
 }

 Widget _buildUI() {
    return DashChat(
      inputOptions: InputOptions(
        trailing: [
          IconButton(
            onPressed: _sendMediaMessage,
            icon: const Icon(
              Icons.image,
              color: Color(0xFF00FFF6),
            ),
          ),
        ],
      ),
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
    );
 }

 Future<bool> _onBackPressed() async {
    return (
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Confirm'),
          content: Text('Do you want to exit?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Yes'),
            ),
          ],
        ),
      )
    ) ?? false;
 }
}
