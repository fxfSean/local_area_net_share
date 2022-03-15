
import 'dart:convert';
import 'dart:io';

class CmdCoder {
  static const String CMD_BIND = 'bind';
  static const String CMD_BIND_SUCCESS = 'bind_success';
  static const String CMD_SCAN = 'scan';
  static const String CMD_DATA = 'data';

  static const String separator = '5a5b**';

  static String encode(CmdBean cmdBean) {
    return cmdBean.cmdCode + separator + cmdBean.data;
  }

  static CmdBean decode(Datagram datagram) {
    final data = utf8.decode(datagram.data);
    var split = data.split(separator);
    return CmdBean(split[0], datagram.address.address, split[1]);
  }
}

class CmdBean {
  final String cmdCode;
  final String ip;
  final String data;

  CmdBean(this.cmdCode, this.ip, this.data,);

  @override
  String toString() {
    return 'CmdBean{cmdCode:$cmdCode,'
        'ip:$ip,'
        'data:$data,'
        '}';
  }
}
