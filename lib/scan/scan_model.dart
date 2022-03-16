
import 'dart:async';

import 'package:all_platform_demo/chat/chat_screen.dart';
import 'package:all_platform_demo/transfer/broadcast_manager.dart';
import 'package:all_platform_demo/transfer/cmd_coder.dart';
import 'package:all_platform_demo/transfer/device_bean.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScanModel extends ChangeNotifier with DeviceStatusListener{
  BroadcastManager _broadcastManager = BroadcastManager();
  late Completer<bool> _bindCompleter;
  final BuildContext context;

  ScanModel(this.context) {
    _broadcastManager.addRefreshUICallback(() {
      notifyListeners();
    });
    _broadcastManager.setOnDeviceStatusListener(this);
  }

  get devices => _broadcastManager.devices;

  @override
  void onBindReceive(DeviceBean target) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => ChatScreen(deviceName: target.deviceName
    )));
  }

  @override
  void onBindSend() {
    // TODO: implement onBindSend
  }

  @override
  void onBindSuccess(DeviceBean targetBean) {
    _bindCompleter.complete(true);
  }

  @override
  void onReceiveData(String data) {
    // TODO: implement onReceiveData
  }

  @override
  void onScanning() {
    // TODO: implement onScanning
  }

  void startScan() {
    _broadcastManager.startScan();
  }

  Future<bool> bind(ip) async {
    _bindCompleter = Completer<bool>();
    _broadcastManager.bind(ip);
    Timer(Duration(seconds: 5),() {
      if(_bindCompleter.isCompleted){
        return;
      } else {
        _bindCompleter.complete(false);
      }
    });
    return _bindCompleter.future;
  }

}