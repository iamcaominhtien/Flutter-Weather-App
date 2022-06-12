import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'weather.dart';

class MyCity {
  String name;
  double lat, lon;
  bool myLocation;
  dynamic currentWeatherData;

  MyCity(
      {required this.lat,
      required this.lon,
      required this.name,
      required this.myLocation,
      this.currentWeatherData});

  factory MyCity.fromJson(Map<String, dynamic> json) {
    return MyCity(
        lat: json['lat'],
        lon: json['lon'],
        name: json['name'],
        myLocation: json['myLocation']);
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lon': lon,
      'name': name,
      'myLocation': myLocation,
    };
  }
}

class CityList {
  static String keyCityList = 'city';

  static Future<bool> saveCity(MyCity city) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String>? listCity = sharedPreferences.getStringList(keyCityList);

    if (listCity == null || listCity.isEmpty) {
      return await sharedPreferences
          .setStringList(keyCityList, [jsonEncode(city)]);
    } else {
      if (!listCity.contains(jsonEncode(city))) {
        listCity.add(jsonEncode(city));
        return await sharedPreferences.setStringList(keyCityList, listCity);
      }
      return true;
    }
  }

  static Future<List<MyCity>> readCityList() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String>? listCity = sharedPreferences.getStringList(keyCityList);
    var weatherModel = WeatherModel();

    List<MyCity> returnList = [];
    if (listCity != null) {
      int len = listCity.length;
      for (int i = 0; i < len; i++) {
        var city =
            MyCity.fromJson(jsonDecode(listCity[i]) as Map<String, dynamic>);
        await weatherModel.getCurrentWeatherByLocation(
            geo: {'lat': city.lat, 'lon': city.lon});
        city.currentWeatherData = weatherModel.currentWeatherData;
        returnList.add(city);
      }
    }

    return returnList;
  }

  static Future<bool> delCity(MyCity city) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String>? listCity = sharedPreferences.getStringList(keyCityList);
    if (listCity == null) {
      return Future.error('Failed when read list city');
    }
    listCity.remove(jsonEncode(city));
    return sharedPreferences.setStringList(keyCityList, listCity);
  }

  static Future delAll() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(keyCityList);
  }
}
