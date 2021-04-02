import 'package:device_info/device_info.dart';

Future<bool> isIpad() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  IosDeviceInfo info = await deviceInfo.iosInfo;
  if (info.name.toLowerCase().contains("ipad")) {
    return true;
  }
  return false;
}
