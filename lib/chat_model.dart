
import 'dart:async';

import 'package:all_platform_demo/broadcast_manager.dart';
import 'package:flutter/material.dart';

class ChatModel extends ChangeNotifier with DeviceStatusListener{

  BroadcastManager _broadcastManager = BroadcastManager();
  List<MessageItem> messageItems = [];
  Timer? _timer;

  var scrollController = ScrollController();

  ChatModel() {
    initMessageItems();
    _broadcastManager.setOnDeviceStatusListener(this);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      messageItems.add(MessageItem(ChatUserType.self, 'content-timer'));
      if (!_fingerAttached) {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 500),
            curve: Curves.ease);
      }
      print('count --$_fingerAttached');
      notifyListeners();
    });
  }

  bool _fingerAttached = false;
  set fingerAttached(bool fingerAttached) {
    _fingerAttached = fingerAttached;
  }

  void initMessageItems() {
    for (var i = 0; i < 20; i++) {
      if (i % 2 == 0) {
        messageItems.add(MessageItem(ChatUserType.self, 'content $i'));
      } else {
        messageItems.add(MessageItem(ChatUserType.other, 'content $i'));
      }
    }
    notifyListeners();
  }

  void sendMessage(String data) {
    messageItems.add(MessageItem(ChatUserType.self, data));
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void onBindReceive(String targetIp) {
  }

  @override
  void onBindSend() {
  }

  @override
  void onBindSuccess(String targetIp) {
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
