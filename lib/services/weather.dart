import 'package:flutter/material.dart';
import '../components/constants.dart';
import 'location.dart';
import 'networking.dart';

///Trích xuất các thông tin về thời tiết dựa trên
///tọa độ GPS hoặc theo tên thành phố
class WeatherModel {
  MyLocation location = MyLocation();
  dynamic currentWeatherData;
  dynamic detailWeatherData;

  void getCityWeather(String cityName) async {
    String url;
    url = kOpenWeatherMapAPICurrent + "q=$cityName&appid=$kApiKey&units=metric";
    debugPrint(url);
    NetworkingHelper networkingHelper = NetworkingHelper(url: url);
    var weatherData = await networkingHelper.getData();
    if (weatherData.toString() != '404') {
      double lon = weatherData['coord']['lon'];
      double lat = weatherData['coord']['lat'];
      currentWeatherData = weatherData;

      //Get detailed weather
      url = kOpenWeatherMapAPIOneCall +
          "lat=$lat&lon=$lon&exclude=minutely&appid=$kApiKey&units=metric";
      networkingHelper = NetworkingHelper(url: url);
      weatherData = await networkingHelper.getData();
      if (weatherData.toString() != '404') {
        detailWeatherData = weatherData;
      } else {
        detailWeatherData = null;
      }
    } else {
      currentWeatherData = null;
      detailWeatherData = null;
    }
  }

  //Theo GPS
  Future<void> getCurrentWeatherByLocation() async {
    String url;
    //Get current weather
    await location.getCurrentLocation();
    debugPrint(location.longitude.toString());
    debugPrint(location.latitude.toString());
    url = kOpenWeatherMapAPICurrent +
        "lat=${location.latitude}&lon=${location.longitude}&appid=$kApiKey&units=metric&lang=vi";
    debugPrint(url);

    NetworkingHelper networkingHelper = NetworkingHelper(url: url);
    var weatherData = await networkingHelper.getData();
    if (weatherData.toString() != '404') {
      currentWeatherData = weatherData;

      //Get detailed weather
      url = kOpenWeatherMapAPIOneCall +
          "lat=${location.latitude}&lon=${location.longitude}&exclude=minutely&appid=$kApiKey&units=metric&lang=vi";
      debugPrint(url);
      networkingHelper = NetworkingHelper(url: url);
      weatherData = await networkingHelper.getData();
      if (weatherData.toString() != '404') {
        detailWeatherData = weatherData;
      }
    } else {
      currentWeatherData = null;
      detailWeatherData = null;
    }
  }

  static String getWeatherIcon(int condition) {
    if (condition < 300) {
      return 'assets/thunderstorm.png';
    }
    if (condition < 400) {
      return 'assets/drizzle.png';
    }
    if (condition < 600) {
      if (condition < 502) {
        return 'assets/lightrain.png';
      }
      if (condition == 521) {
        return 'assets/showers.png';
      }
      return 'assets/heavyrain.png';
    }
    if (condition < 700) {
      return 'assets/snow.png';
    }
    if (condition < 800) {
      if (condition == 701) {
        return 'assets/mist.png';
      }
      if (condition == 711) {
        return 'assets/smoke.png';
      }
      if (condition == 721) {
        return 'assets/haze.png';
      }
      if (condition == 731) {
        return 'assets/sand.png';
      }
      if (condition == 741) {
        return 'assets/fog.png';
      }
      if (condition == 751) {
        return 'assets/sand.png';
      }
      if (condition == 761) {
        return 'assets/dust.png';
      }
      if (condition == 762) {
        return 'assets/volcano.png';
      }
      if (condition == 771) {
        return 'assets/squalls.png';
      }
      if (condition == 781) {
        return 'assets/tornado.png';
      }
    }
    if (condition == 800) {
      return 'assets/clear.png';
    }
    if (condition == 801) {
      return 'assets/cloudy.png';
    }
    return 'assets/heavycloud.png';
  }
}
