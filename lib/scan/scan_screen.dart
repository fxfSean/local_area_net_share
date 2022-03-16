

import 'package:all_platform_demo/chat/chat_screen.dart';
import 'package:all_platform_demo/scan/scan_model.dart';
import 'package:all_platform_demo/transfer/broadcast_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('扫描'),
      ),
      body: ChangeNotifierProvider(
        create: (context) => ScanModel(),
        child: _ScanView(),
      )
    );
  }
}

class _ScanView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var scanModel = context.watch<ScanModel>();
    return Center(
      child: Column(
        children: [
          Container(
            width: 600,
            height: 300,
          ),
          TextButton(
            child: Text('Start Scan'),
            onPressed: () async {
              Provider.of<ScanModel>(context, listen: false).startScan();
            },
          ),
          TextButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
                ChatScreen(deviceName: 'Chat')));
          }, child: Text('Go Chat')
          ),
          Expanded(child: ListView.separated(
              itemBuilder: (context, index) {
                var deviceBean = scanModel.devices[index];
                return GestureDetector(
                  onTap: () async {
                    print('点击：${deviceBean.deviceName}—$index');
                    var bindSuccess = await scanModel.bind(deviceBean.ip);
                    if (bindSuccess) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
                          ChatScreen(deviceName: deviceBean.deviceName)));
                    }
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
              itemCount: scanModel.devices.length)
          ),
        ],
      ),
    );
  }
}

