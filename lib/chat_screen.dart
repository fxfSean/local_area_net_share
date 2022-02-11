
import 'package:all_platform_demo/chat_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String deviceName;

  const ChatScreen({Key? key, required this.deviceName}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatModel(),
      child: Consumer<ChatModel>(
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.deviceName),
            ),
            body: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          if (model.messageItems[index].userType == ChatUserType.other) {
                            return _LeftItem();
                          } else  {
                            return _RightItem();
                          }
                        })
                ),

              ],
            ),
          );
        },
      ),
      );
  }
}

class _LeftItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Left'),
    );
  }
}

class _RightItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Right'),
    );
  }
}

