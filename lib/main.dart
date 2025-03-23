import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:weather_app/Presentaion/Home.dart';
import 'package:weather_app/Services/certificate_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Client getHttpClient = await SslCertificate.getSSLPinningClient();
  runApp(HomePage(
    httpClient: getHttpClient,
  ));
}
