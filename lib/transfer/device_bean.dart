
class DeviceBean {
  final String deviceName;
  final String ip;

  DeviceBean(this.deviceName, this.ip);


  @override
  String toString() {
    return 'DeviceBean{'
        'deviceName: $deviceName, '
        'ip: $ip,'
        '}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DeviceBean &&
              deviceName == other.deviceName &&
              ip == other.ip;

  @override
  int get hashCode {
    return ip.hashCode ^ deviceName.hashCode;
  }
}
