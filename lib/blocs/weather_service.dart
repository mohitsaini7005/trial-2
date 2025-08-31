import 'dart:convert';
import 'dart:developer' as developer;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?q=$cityName&appid=$apiKey&units=metric'));

      if (response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load weather data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Log the error for debugging purposes
      developer.log('Error fetching weather', error: e, name: 'WeatherService.getWeather');
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();

    // get permission from the user if not granted
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    try {
      // fetch the current location
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      // convert the location into a list of placemark objects
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      // extract the city name from the first placemark
      String? city = placemarks.isNotEmpty ? placemarks[0].locality : null;

      return city ?? "";
    } catch (e) {
      // Handle geolocation errors
      developer.log('Error fetching current location', error: e, name: 'WeatherService.getCurrentCity');
      return "Error fetching current location";
    }
  }
}
