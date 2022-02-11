
import 'dart:io';

import 'package:all_platform_demo/cmd_coder.dart';
import 'package:all_platform_demo/device_bean.dart';
import 'package:all_platform_demo/multicast.dart';
import 'package:device_info_plus/device_info_plus.dart';

class BroadcastManager {
  Multicast multicast = Multicast();
  List<DeviceBean> devices = [];
  String deviceName = '';
  bool isBind = false;
  String localIp = '';
  String bindIp = '';

  Function? refreshUICallback;
  DeviceStatusListener? _deviceStatusListener;

  static final BroadcastManager _manager = BroadcastManager._();
  factory BroadcastManager() => _manager;
  BroadcastManager._();

  Future<void> startScan() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var info = await deviceInfo.androidInfo;
      _printDeviceInfo(info);
    }
    if (Platform.isMacOS) {
      var info = await deviceInfo.macOsInfo;
      _printIosDeviceInfo(info);
    }
    multicast.addListener((CmdBean cmdBean) async {
      if (isBind && cmdBean.ip != bindIp) {
        return;
      }
      print('cmdCode: ${cmdBean.cmdCode} data: ${cmdBean.data} address: ${cmdBean.ip}');
      /// 从设备，发送反馈成功给主设备
      if (cmdBean.cmdCode == CmdCoder.CMD_BIND) {
        bindIp = cmdBean.ip;
        _deviceStatusListener?.onBindReceive(bindIp);
        isBind = true;
        sendData('bindSuccess', cmdBean.ip);
        print('reply bindSuccess');
      }
      /// 主设备，接收反馈成功
      if (cmdBean.cmdCode == CmdCoder.CMD_BIND_SUCCESS) {
        _deviceStatusListener?.onBindSuccess(cmdBean.ip);
        bindIp = cmdBean.ip;
        isBind = true;
        print('receive bindSuccess');
      }
      if (cmdBean.cmdCode == CmdCoder.CMD_DATA) {
        print('receive data');
        _deviceStatusListener?.onReceiveData(cmdBean.data);
      }
      if (cmdBean.cmdCode == CmdCoder.CMD_SCAN) {
        if (cmdBean.ip == localIp) {
          print('skip');
          return;
        }
        if (cmdBean.data == deviceName) {
          localIp = cmdBean.ip;
          print('local ip: ${cmdBean.ip}');
        } else {
          final m = DeviceBean(cmdBean.data, cmdBean.ip);
          if (!devices.contains(m)) {
            devices.add(m);
            refreshUICallback?.call();
            print('find other ip: ${cmdBean.ip}');
          }
        }
      }
    });
    _deviceStatusListener?.onScanning();
    multicast.startSendBroadcast(deviceName);
  }

  void setOnDeviceStatusListener(DeviceStatusListener listener) {
    _deviceStatusListener = listener;
  }

  void sendData(String data, String ip) {
    send(CmdCoder.CMD_DATA, data, ip);
  }

  void send(String cmdCode, String data, String ip) {
    print('send: $localIp -----> $ip code: $cmdCode data: $data');
    final c = CmdBean(cmdCode, ip, data);
    multicast.sendData(c);
  }

  void bind(String devicesIp) {
    _deviceStatusListener?.onBindSend();
    send(CmdCoder.CMD_BIND,'',devicesIp);
  }

  void _printDeviceInfo(AndroidDeviceInfo info) {
    print(info.type);
    print(info.model);
    deviceName = info.model!;
    print(info.id);
    print(info.board);
    print(info.bootloader);
    print(info.brand);
    print(info.device);
    print(info.display);
    print(info.fingerprint);
    print(info.hardware);
    print(info.host);
    print(info.isPhysicalDevice);
    print(info.manufacturer);
    print(info.product);
    print(info.tags);
  }

  void _printIosDeviceInfo(MacOsDeviceInfo info) {
    print(info.model);
    deviceName = info.model;
    print(info.activeCPUs);
    print(info.arch);
    print(info.computerName);
    print(info.hostName);
  }

  void addRefreshUICallback(void Function() listener) {
    refreshUICallback = listener;
  }

}

mixin DeviceStatusListener {
  void onScanning();
  void onBindSend();
  void onBindReceive(String targetIp);
  void onBindSuccess(String targetIp);
  void onReceiveData(String data);
}
