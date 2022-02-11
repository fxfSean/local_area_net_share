
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
        builder: (context, model, _) {
          print('build--');
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.deviceName),
            ),
            body: Column(
              children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: model.messageItems.length,
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
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7
          ),
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color(0xfffde1e1),
            ),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white
          ),
          child: Text('Left'),
        ),
      ],
    );
  }
}

class _RightItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7
          ),
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xfffde1e1),
              ),
              borderRadius: BorderRadius.circular(5),
              color: Colors.lightGreen
          ),
          child: Text('Right'),
        ),
      ],
    );
  }
}

