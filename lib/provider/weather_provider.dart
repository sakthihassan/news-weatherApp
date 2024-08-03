import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather_news_app/model/forecast_model.dart';
import 'package:weather_news_app/model/weather_model.dart';

class WeatherProvider extends ChangeNotifier {
  final dio = Dio();
  WeatherData? weatherData;
  List<ForecastList> forecast=[];
  LatLng? currentPostion;
  bool isLoading = false;
  String? countryName;
  bool celsius = true;
  var temperature = 'Celsius';
  var changedData = '';
  Future<void> getUserLocation() async {
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPostion = LatLng(position.latitude, position.longitude);
    print('${currentPostion?.latitude} ${currentPostion?.longitude}');
    notifyListeners();
  }

  Future<void> currentWeatherData() async {
    if (currentPostion == null) {
      await getUserLocation();
    }
    isLoading = true;
    notifyListeners();
    try {
      final response = await dio.get(
          "https://api.openweathermap.org/data/2.5/weather?lat=${currentPostion?.latitude}&lon=${currentPostion?.longitude}&appid=d17e2066b915b9332e576ca547bbd04c");

      if (response.statusCode == 200) {
        final data = response.data;
        weatherData = WeatherData.fromJson(data);
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> currentLocForeCast() async {
    if (currentPostion == null) {
      await getUserLocation();
    }
    isLoading = true;
    notifyListeners();
    try {
      final response = await dio.get(
        "https://api.openweathermap.org/data/2.5/forecast?lat=${currentPostion?.latitude}&lon=${currentPostion?.longitude}&appid=d17e2066b915b9332e576ca547bbd04c",
      );

      if (response.statusCode == 200) {
        final data = response.data;
        ForecastModel forecastModel = ForecastModel.fromJson(data);
        forecast = forecastModel.list ?? [];
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
    isLoading = false;
    notifyListeners();
  }
  Future<void> countryLocForeCast() async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await dio.get(
        "https://api.openweathermap.org/data/2.5/forecast?q=$countryName&appid=d17e2066b915b9332e576ca547bbd04c",
      );

      if (response.statusCode == 200) {
        final data = response.data;
        ForecastModel forecastModel = ForecastModel.fromJson(data);
        forecast = forecastModel.list ?? [];
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
    isLoading = false;
    notifyListeners();
  }



  Future<void> countryWeatherData() async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await dio.get(
        "https://api.openweathermap.org/data/2.5/weather?q=$countryName&appid=d17e2066b915b9332e576ca547bbd04c",
      );

      if (response.statusCode == 200) {
        final data = response.data;
        weatherData = WeatherData.fromJson(data);
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
    isLoading = false;
    notifyListeners();
  }

  String kelvinToCelsius(double tempKelvin) {
    double tempCelsius = tempKelvin - 273.15;
    return tempCelsius.toStringAsFixed(2);
  }

  String kelvinToFahrenheit(double tempKelvin) {
    double tempFahrenheit = (tempKelvin - 273.15) * 9 / 5 + 32;
    return tempFahrenheit.toStringAsFixed(2);
  }

}



final weatherProvider =
    ChangeNotifierProvider<WeatherProvider>((ref) => WeatherProvider());
