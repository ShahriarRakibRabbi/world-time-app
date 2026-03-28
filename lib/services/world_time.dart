import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String? location;
  String? time;
  String? date;
  String? countryCode;
  String? url;
  bool? isDaytime;

  WorldTime({this.location, this.countryCode, this.url});

  String getFlagImageUrl() {
    final code = (countryCode ?? 'UN').toLowerCase();
    return 'https://flagcdn.com/w80/$code.png';
  }

  Future<void> getTime() async {
    try {
      Response response = await get(
        Uri.parse('https://time.now/developer/api/timezone/$url'),
        headers: {'User-Agent': 'Mozilla/5.0', 'Accept': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load timezone data: ${response.statusCode}');
      }

      final Map<String, dynamic> data = jsonDecode(response.body);
      final String datetime =
          data['utc_datetime']?.toString() ??
          data['datetime']?.toString() ??
          '';
      final String utcOffset = data['utc_offset']?.toString() ?? '+00:00';

      if (datetime.isEmpty) {
        throw Exception('Datetime missing from API response');
      }

      DateTime now = DateTime.parse(datetime);

      final int sign = utcOffset.startsWith('-') ? -1 : 1;
      final int offsetHours = int.parse(utcOffset.substring(1, 3));
      final int offsetMinutes = int.parse(utcOffset.substring(4, 6));
      now = now.add(
        Duration(hours: sign * offsetHours, minutes: sign * offsetMinutes),
      );

      isDaytime = now.hour >= 6 && now.hour < 19;
      time = DateFormat.jm().format(now);
      date = DateFormat('EEE, dd MMM yyyy').format(now);
    } catch (e) {
      time = 'Could not load time';
      date = 'Please try another location';
      isDaytime = true;
    }
  }
}
