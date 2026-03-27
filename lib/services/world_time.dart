import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  // location name for the UI
  String? location;
  //the time in that location
  String? time;
  // url for an asset flag icon
  String? flag;
  // location url for api endpoint
  String? url;
  // true or false if daytime or not
  bool? isDaytime;

  WorldTime({this.location, this.flag, this.url});

  Future<void> getTime() async {
    try {
      // make a request
      Response response = await get(
        Uri.parse("https://time.now/developer/api/timezone/$url"),
        headers: {"User-Agent": "Mozilla/5.0", "Accept": "application/json"},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to load timezone data: ${response.statusCode}');
      }

      Map data = jsonDecode(response.body);
      //print(data);
      // get properties from data
      String datetime = data["utc_datetime"];
      String utcOffset = data["utc_offset"];
      int offsetHours = int.parse(utcOffset.substring(1, 3));
      if (utcOffset.startsWith('-')) {
        offsetHours = -offsetHours;
      }
      // print(datetime);
      // print(offset);

      // create DateTime object
      DateTime now = DateTime.parse(datetime);
      now = now.add(Duration(hours: offsetHours));

      // set time property
      isDaytime = (now.hour > 6 && now.hour < 20) ? true : false;
      time = DateFormat.jm().format(now);
    } catch (e) {
      time = "could not get time data";
    }
  }
}
