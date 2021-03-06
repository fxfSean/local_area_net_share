
import 'dart:async';
import 'dart:io';

import 'package:all_platform_demo/transfer/broadcast_manager.dart';
import 'package:all_platform_demo/transfer/device_bean.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ChatModel extends ChangeNotifier with DeviceStatusListener{

  BroadcastManager _broadcastManager = BroadcastManager();
  List<MessageItem> messageItems = [];
  Timer? _timer;

  var scrollController = ScrollController();

  ChatModel() {
    initMessageItems();
    _broadcastManager.setOnDeviceStatusListener(this);

  }

  bool _fingerAttached = false;
  set fingerAttached(bool fingerAttached) {
    _fingerAttached = fingerAttached;
  }

  Future<void> initMessageItems() async {
    bool flag = false;
    _timer = Timer.periodic(Duration(seconds: 2), (timer) async {
      flag = !flag;
      messageItems.add(MessageItem(flag ? ChatUserType.self : ChatUserType.other, 'content-timer'));
      if (!_fingerAttached) {
        scrollToBottom();
      }
      notifyListeners();
    });
    notifyListeners();
  }

  void scrollToBottom() {
    Timer(Duration(milliseconds: 500), () {
      scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.ease
          );
    });
  }

  void sendMessage(String data) {
    messageItems.add(MessageItem(ChatUserType.self, data));
    scrollToBottom();
    notifyListeners();
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      print(files);
    } else {
      // User canceled the picker
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void onBindReceive(DeviceBean targetBean) {
  }

  @override
  void onBindSend() {
  }

  @override
  void onBindSuccess(DeviceBean targetBean) {
  }

  @override
  void onReceiveData(String data) {
    messageItems.add(MessageItem(ChatUserType.other, data));
    notifyListeners();
  }

  @override
  void onScanning() {
  }
}

class MessageItem {
  final ChatUserType userType;
  final String content;

  MessageItem(this.userType, this.content);
}

enum ChatUserType {
  self,
  other
}

enum ChatMsgType {
  text,
  image,
  file,
  sound,
  video,
}
