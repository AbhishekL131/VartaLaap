import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vartalaap/components/my_drawer.dart';

import '../firebase_utilities/firebase_auth_methods.dart';
import 'login_screen.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Gemini gemini = Gemini.instance;

  List<ChatMessage> messages = [
    ChatMessage(
      user: ChatUser(id: "1", firstName: "gemini",profileImage: "https://seeklogo.com/images/G/google-gemini-logo-A5787B2669-seeklogo.com.png"),
      createdAt: DateTime.now(),
      text: "Welcome to Vartalaap",
    )
  ];

  ChatUser currentUser = ChatUser(id: "0", firstName: "Abhishek");
  ChatUser geminiUser = ChatUser(id: "1", firstName: "gemini", profileImage: "https://seeklogo.com/images/G/google-gemini-logo-A5787B2669-seeklogo.com.png");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Color(0xFF003366),
        title: Text(
          "Vartalaap",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(onPressed: () async {
            showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.white,
                    title: Text("Sign Out",style: TextStyle(),),
                    content: Text("Are you Sure?"),
                    actions: [
                      TextButton(
                          onPressed: () async{
                            await context.read<FirebaseAuthMethods>().signOut(context);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Yes",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          )
                      ),

                      TextButton(
                          onPressed: (){
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "No",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          )
                      )
                    ],
                  );
                }
            );
          },
              icon: Icon(Icons.logout,size: 25,color: Colors.white,)
          )
        ],
      ),
      body: _buildUI(),

      drawer: MyDrawer(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      inputOptions: InputOptions(trailing: [
        IconButton(
          onPressed: _sendMediaMessage,
          icon: const Icon(Icons.image),
        )
      ]),
      currentUser: currentUser,
      onSend: _sendMessage,
      messageOptions: MessageOptions(
        currentUserContainerColor: Color(0xFF146EB4),
      ),
      messages: messages,
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [File(chatMessage.medias!.first.url).readAsBytesSync()];
      }
      gemini.streamGenerateContent(question,images: images).listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts?.fold("", (previous, current) => "$previous ${current.text}") ?? "";
          lastMessage.text += response;
          setState(() {
            messages = [lastMessage!, ...messages];
          });
        } else {
          String response = event.content?.parts?.fold("", (previous, current) => "$previous ${current.text}") ?? "";
          ChatMessage message = ChatMessage(user: geminiUser, createdAt: DateTime.now(), text: response);
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        text: "Describe this picture?",
        medias: [
          ChatMedia(url: file.path, fileName: "", type: MediaType.image),
        ],
      );
      _sendMessage(chatMessage);
    }
  }
}