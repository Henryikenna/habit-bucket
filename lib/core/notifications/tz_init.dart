import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

Future<void> initLocalTimeZone() async {
  tzdata.initializeTimeZones();
  final name = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(name.localizedName?.name ?? ''));
}
