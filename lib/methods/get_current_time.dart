import 'dart:convert';
import 'package:http/http.dart' as http;


Future<int> fetchSPMDate() async {
  String url = 'http://worldtimeapi.org/api/timezone/Asia/Kuala_Lumpur';
  try {
    var response = await http.get(
        Uri.encodeFull(url)
    );

    Map<String, dynamic> data = jsonDecode(response.body);
    return data['unixtime'];

  } catch (e) {
    return null;
  }

}