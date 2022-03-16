
import 'dart:async';

import 'package:all_platform_demo/transfer/broadcast_manager.dart';
import 'package:flutter/cupertino.dart';

class ScanModel extends ChangeNotifier with DeviceStatusListener{
  BroadcastManager _broadcastManager = BroadcastManager();
  Completer<bool>? _bindCompleter;

  ScanModel() {
    _broadcastManager.addRefreshUICallback(() {
      notifyListeners();
    });
    _broadcastManager.setOnDeviceStatusListener(this);
  }

  get devices => _broadcastManager.devices;

  @override
  void onBindReceive(String targetIp) {
    // TODO: implement onBindReceive
  }

  @override
  void onBindSend() {
    // TODO: implement onBindSend
  }

  @override
  void onBindSuccess(String targetIp) {
    _bindCompleter!.complete(true);
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
      if(_bindCompleter!.isCompleted){
        return;
      } else {
        _bindCompleter!.complete(false);
      }
    });
    return _bindCompleter!.future;
  }

}