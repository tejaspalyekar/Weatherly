import 'dart:convert';
import 'dart:developer';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/Model/WeatherModel.dart';

class WeatherService {
  http.Client client = http.Client();
  WeatherService({this.apikey, required this.client});

  String? apikey;
  String url = 'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherModel> getWeather(String city) async {
    try {
      final uri = Uri.parse('$url?q=$city&appid=$apikey');
      final response = await client.get(uri);

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Unable to fetch data');
      }
    } catch (e) {
      log(e.toString());
      throw e;
    }
  }

  Future<String> currentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      Geolocator.requestPermission();
    }
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemaker =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    return placemaker[0].postalCode!;
  }
}
