library multicast;

import 'dart:convert';
import 'dart:io';

import 'cmd_coder.dart';

InternetAddress _mDnsAddressIPv4 = InternetAddress('224.0.0.251');
const int _port = 5545;
typedef MessageCall = void Function(CmdBean cmdBean);

Future<List<String>> _localAddress() async {
  List<String> address = [];
  final List<NetworkInterface> interfaces = await NetworkInterface.list(
    includeLoopback: false,
    type: InternetAddressType.IPv4,
  );
  for (final NetworkInterface netInterface in interfaces) {
    // 遍历网卡
    for (final InternetAddress netAddress in netInterface.addresses) {
      // 遍历网卡的IP地址
      if (netAddress.address.isIPv4) {
        address.add(netAddress.address);
      }
    }
  }
  return address;
}

bool _hasMatch(String? value, String pattern) {
  return (value == null) ? false : RegExp(pattern).hasMatch(value);
}

/// 抄的getx
extension IpString on String {
  bool get isIPv4 =>
      _hasMatch(this, r'^(?:(?:^|\.)(?:2(?:5[0-5]|[0-4]\d)|1?\d?\d)){4}$');
}

extension Boardcast on RawDatagramSocket {
  Future<void> broadcast(String msg, int port) async {
    final c = CmdBean(CmdCoder.CMD_SCAN, _mDnsAddressIPv4.address, msg);
    sendEncoded(c, port);
    await Future.delayed(const Duration(milliseconds: 10));
    final List<String> address = await _localAddress();
    for (final String addr in address) {
      final tmp = addr.split('.');
      tmp.removeLast();
      final String addrPrfix = tmp.join('.');
      final InternetAddress address = InternetAddress(
        '$addrPrfix.255',
      );
      final c = CmdBean(CmdCoder.CMD_SCAN, address.address, msg);
      sendEncoded(
        c,
        port,
      );
    }
  }

  int sendEncoded(CmdBean cmdBean, int port) {
    return send(utf8.encode(CmdCoder.encode(cmdBean)), InternetAddress(cmdBean.ip), port);
  }
}

/// 通过组播+广播的方式，让设备能够相互在局域网被发现
class Multicast {
  final int port;
  final List<MessageCall> _callback = [];
  RawDatagramSocket? _socket;
  bool _isStartSend = false;
  bool _isStartReceive = false;

  Multicast({this.port = _port});

  /// 停止对 udp 发送消息
  void stopSendBroadcast() {
    if (!_isStartSend) {
      return;
    }
    _isStartSend = false;
  }

  void closeSocket() {
    _socket?.close();
  }

  /// 接收udp广播消息
  Future<void> _receiveBroadcast() async {
    RawDatagramSocket.bind(
      InternetAddress.anyIPv4,
      port,
      reuseAddress: true,
      ttl: 255,
    ).then((RawDatagramSocket socket) {
      // 接收组播消息
      socket.joinMulticast(_mDnsAddressIPv4);
      // 开启广播支持
      socket.broadcastEnabled = true;
      socket.readEventsEnabled = true;
      socket.listen((RawSocketEvent rawSocketEvent) async {
        final Datagram? datagram = socket.receive();
        if (datagram == null) {
          return;
        }

        _notifyAll(CmdCoder.decode(datagram));
      });
    });
  }

  void _notifyAll(cmdBean) {
    for (MessageCall call in _callback) {
      call(cmdBean);
    }
  }

  Future<void> startSendBroadcast(String data, {Duration? duration}) async {
    if (_isStartSend) {
      return;
    }
    _isStartSend = true;
    _socket = await RawDatagramSocket.bind(
      InternetAddress.anyIPv4,
      0,
      ttl: 255,
      reuseAddress: true,
    );
    _socket?.broadcastEnabled = true;
    _socket?.readEventsEnabled = true;
    while (true) {
      _socket!.broadcast(data, port);
      if (!_isStartSend) {
        break;
      }
      await Future.delayed(duration ?? const Duration(seconds: 1));
    }
  }

  void sendData(CmdBean cmdBean) {
    var send = _socket!.sendEncoded(cmdBean, port);
    print('send ret: $send');
  }

  void addListener(MessageCall listener) {
    if (!_isStartReceive) {
      _receiveBroadcast();
      _isStartReceive = true;
    }
    _callback.add(listener);
  }

  void removeListener(MessageCall listener) {
    if (_callback.contains(listener)) {
      _callback.remove(listener);
    }
  }
}
