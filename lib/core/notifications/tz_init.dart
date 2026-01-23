import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

Future<void> initLocalTimeZone() async {
  tzdata.initializeTimeZones();
  try {
    final timezoneInfo = await FlutterTimezone.getLocalTimezone();
    final identifier = timezoneInfo.identifier;
    print('🕐 [TZ] Local timezone identifier: $identifier');
    tz.setLocalLocation(tz.getLocation(identifier));
    print('🕐 [TZ] Successfully set local timezone to: ${tz.local.name}');
  } catch (e) {
    // Fallback to UTC if local timezone not found
    // This can happen on Windows with non-IANA timezone names
    print('🕐 [TZ] Error setting timezone, falling back to UTC: $e');
    tz.setLocalLocation(tz.getLocation('UTC'));
  }
}
