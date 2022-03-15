import 'dart:io';

import 'package:all_platform_demo/chat/chat_screen.dart';
import 'package:all_platform_demo/transfer/broadcast_manager.dart';
import 'package:all_platform_demo/transfer/multicast.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'socket',
      home: _HomeWidget(),
    );
  }
}

class _HomeWidget extends StatefulWidget {
  const _HomeWidget({Key? key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<_HomeWidget> {
  BroadcastManager _broadcastManager = BroadcastManager();

  @override
  void initState() {
    super.initState();
    _broadcastManager.addRefreshUICallback(() {
      setState(() {
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('扫描'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: 600,
              height: 300,
            ),
            TextButton(
              child: Text('Start Scan'),
              onPressed: () async {
                _broadcastManager.startScan();
              },
            ),
            TextButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
                  ChatScreen(deviceName: 'Chat')));
            }, child: Text('Go Chat')
            ),
            Expanded(child: ListView.separated(
                itemBuilder: (context, index) {
                  var deviceBean = _broadcastManager.devices[index];
                  return GestureDetector(
                    onTap: () {
                      print('点击：${deviceBean.deviceName}—$index');
                      _broadcastManager.bind(deviceBean.ip);
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
                          ChatScreen(deviceName: deviceBean.deviceName)));
                    },
                    child: Container(
                      height: 60,
                      child: Text(
                        'data: ${deviceBean.deviceName}—${deviceBean.ip}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(
                    height: 1,
                    color: Colors.grey,
                  );
                },
                itemCount: _broadcastManager.devices.length)
            ),
          ],
        ),
      ),
    );
  }

}


