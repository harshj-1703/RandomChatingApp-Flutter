import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    home: MyApp(),
    title:
        'RANDOM CHATING', //app name shown from package name and for main title this is.
    theme: ThemeData(primarySwatch: Colors.cyan),
  )); //for run a code here class MyApp for run
}

//shortcut for stateless is stl
class MyApp extends StatelessWidget {
  //stateless widget class
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MyScreen(); //return to statefullwidget of MyScreen class
  }
}

//shortcut for stateless is stf
class MyScreen extends StatefulWidget {
  const MyScreen({Key? key}) : super(key: key);

  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  var chat = '';

  TextEditingController chatText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //scaffold
      appBar: AppBar(
        //appbar for show scaffold title
        iconTheme:
            IconThemeData(color: Color.fromARGB(255, 4, 245, 245), size: 32),
        centerTitle: true,
        title: const Text(
          'RANDOM CHATING',
          style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.bold),
        ), //title of scaffold
        backgroundColor: Color.fromARGB(255, 29, 69, 214),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              // Below is the code for Linear Gradient.
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                colors: [Colors.purple, Colors.blue],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              )),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: ((context, streamSnapshot) {
                  if (streamSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final chats = streamSnapshot.data!.docs;
                  return RawScrollbar(
                    radius: Radius.circular(50),
                    thumbColor: Colors.amber,
                    child: ListView.builder(
                        reverse: true,
                        itemCount: chats.length,
                        itemBuilder: (context, index) => Card(
                              shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: ListTile(
                                tileColor: Color.fromARGB(255, 132, 255, 251),
                                shape: BeveledRectangleBorder(
                                  side: BorderSide(width: 3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: Text(
                                  chats[index]['message'],
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 0, 0),
                                      fontSize: 18,
                                      fontFamily: 'Times New Roman',
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5),
                                ),
                              ),
                            )),
                  );
                }),
              ),
            ),
          ),
          Container(
            color: Colors.amber,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(
                          color: Color.fromARGB(255, 7, 51, 213),
                          fontSize: 18,
                          fontFamily: 'Courier New',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1),
                      controller: chatText,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(
                            fontSize: 17,
                            color: Color.fromARGB(255, 235, 6, 128),
                            letterSpacing: 2,
                            fontWeight: FontWeight.w600),
                        labelText: 'Enter Message Here...',
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: (() {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          chat = chatText.text;
                        });
                        chatText.clear();
                        send();
                      }),
                      color: Color.fromARGB(255, 29, 69, 214),
                      icon: Icon(Icons.send))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future send() async {
    if (chat != '' && chat.isNotEmpty) {
      final chatsCollection =
          FirebaseFirestore.instance.collection('chats').doc();
      final json = {'message': chat, 'createdAt': DateTime.now()};
      await chatsCollection.set(json);
    }
  }
}
