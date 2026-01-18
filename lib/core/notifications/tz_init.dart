import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

Future<void> initLocalTimeZone() async {
  tzdata.initializeTimeZones();
  try {
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    // Try to get IANA timezone identifier
    final identifier = timezoneInfo.identifier;
    tz.setLocalLocation(tz.getLocation(identifier));
  } catch (e) {
    // Fallback to UTC if local timezone not found
    // This can happen on Windows with non-IANA timezone names
    tz.setLocalLocation(tz.getLocation('UTC'));
  }
}
