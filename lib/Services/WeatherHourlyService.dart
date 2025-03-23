import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/Model/HourlyWeatherModel.dart';

class HourlyService {
  http.Client client = http.Client();
  HourlyService({required this.apikey, client});

  String apikey;
  String url = 'https://api.openweathermap.org/data/2.5/forecast';

  Future<HourlyWeatherModel> fetchHourlydata(String city) async {
    final uri = Uri.parse('$url?q=$city&appid=$apikey');
    final response = await client.get(uri);
    if (response.statusCode == 200) {
      print(jsonDecode(response.body));
      return HourlyWeatherModel.fromJson(jsonDecode(response.body));
    } else {
      SnackBar(
        content: const Text("Unable to fetch data"),
        backgroundColor: Colors.grey[500],
      );
      throw Exception('unable to fetch data');
    }
  }
}
