import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'useful_func.dart';
import 'weather.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class NetworkingHelper {
  //Api
  final String url;
  NetworkingHelper({
    required this.url,
  });

  Future getData() async {
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      //Lấy dữ liệu thành công
      //response.body: String
      //encode: mã hóa
      //decode: giải mã hóa
      return jsonDecode(response.body);
    }
    //Trả về lỗi: 404: lấy dữ liệu không thành công
    //lấy được dữ liệu: -> json kiểu dynamic
    //không lấy được dữ liệu: trả về một con số
    return response.statusCode;
  }
}

//Dữ liệu lấy từ API one-call của OpenWeather
class DailyWeatherData {
  String? windSpeed,
      uvi,
      humidity,
      visibility,
      getDate,
      getMainDescription,
      getDayOfWeek,
      getDescription,
      getWeatherIcon,
      getOnlyDayNumber,
      getWeatherIconOfOpenWeather;

  int? temp, feelLike, maxTemp, minTemp;

  DailyWeatherData(
      {this.uvi,
      this.humidity,
      this.windSpeed,
      this.getWeatherIcon,
      this.getWeatherIconOfOpenWeather,
      this.maxTemp,
      this.minTemp,
      this.getMainDescription,
      this.getDayOfWeek,
      this.feelLike,
      this.temp,
      this.getDate,
      this.getOnlyDayNumber,
      this.getDescription,
      this.visibility});

  factory DailyWeatherData.fromJson(Map<String, dynamic> data) {
    return DailyWeatherData(
      windSpeed: data['wind_speed'].toString(),
      uvi: data['uvi'].round().toString(),
      humidity: data['humidity'].toString(),
      temp: data['temp']['day'].round(),
      feelLike: data['feels_like']['day'].round(),
      maxTemp: data['temp']['max'].round(),
      minTemp: data['temp']['min'].round(),
      getDate: UsefulFunction.getDate(
        DateTime.fromMillisecondsSinceEpoch(data['dt'].toInt() * 1000,
            isUtc: false),
      ),
      getOnlyDayNumber: UsefulFunction.getOnlyDayNumber(
        DateTime.fromMillisecondsSinceEpoch(data['dt'].toInt() * 1000,
            isUtc: false),
      ),
      getMainDescription: data['weather'][0]['main'],
      getDayOfWeek: UsefulFunction.getDayOfWeek(
        DateTime.fromMillisecondsSinceEpoch(
          data['dt'] * 1000,
        ),
      ),
      getDescription:
          UsefulFunction.capitalize(data['weather'][0]['description']),
      getWeatherIcon:
          WeatherModel.getWeatherIcon(data['weather'][0]['id'].toInt()),

      ///Use Image.network
      getWeatherIconOfOpenWeather:
          "http://openweathermap.org/img/wn/${data['weather'][0]['icon']}@2x.png",
    );
  }
}

///Dữ liệu lấy từ api one-call của open weather
class HoursWeatherData {
  int? temp, feelLike;
  String? getDescription, getHour, getWeatherIcon, getWeatherIconOfOpenWeather;

  HoursWeatherData(
      {this.getDescription,
      this.temp,
      this.feelLike,
      this.getWeatherIconOfOpenWeather,
      this.getWeatherIcon,
      this.getHour});

  factory HoursWeatherData.fromJson(Map<String, dynamic> data) {
    return HoursWeatherData(
      temp: data['temp'].round(),
      feelLike: data['feels_like'].round(),
      getHour: UsefulFunction.getHour(
        DateTime.fromMillisecondsSinceEpoch(data['dt'].toInt() * 1000,
            isUtc: false),
      ),
      getDescription:
          UsefulFunction.capitalize(data['weather'][0]['description']),
      getWeatherIcon:
          WeatherModel.getWeatherIcon(data['weather'][0]['id'].toInt()),
      getWeatherIconOfOpenWeather:
          "http://openweathermap.org/img/wn/${data['weather'][0]['icon']}@2x.png",
    );
  }
}

///Dữ liệu lấy từ API current của open weather
class CurrentWeatherData {
  String? windSpeed,
      humidity,
      visibility,
      pressure,
      sunRise,
      sunSet,
      getDate,
      getCityName,
      getDescription,
      getWeatherIconOfOpenWeather,
      getWeatherIcon;
  int? temp, feelLike;
  DateTime? dateTime;

  CurrentWeatherData({
    this.windSpeed,
    this.getWeatherIcon,
    this.feelLike,
    this.temp,
    this.getDescription,
    this.visibility,
    this.getDate,
    this.humidity,
    this.sunSet,
    this.sunRise,
    this.pressure,
    this.dateTime,
    this.getCityName,
    this.getWeatherIconOfOpenWeather,
  });

  factory CurrentWeatherData.fromJson(Map<String, dynamic> data) {
    return CurrentWeatherData(
      windSpeed: (data['wind']['speed']).toString(),
      humidity: (data['main']['humidity']).round().toString(),
      visibility: (data['visibility'] / 1000).round().toString(),
      temp: data['main']['temp'].round(),
      pressure: NumberFormat("###,###.###", 'tr_TR')
          .format(data['main']['pressure'])
          .toString(),
      sunRise: UsefulFunction.getHourAndMinute(
        DateTime.fromMillisecondsSinceEpoch(
            data['sys']['sunrise'].toInt() * 1000,
            isUtc: false),
      ),
      sunSet: UsefulFunction.getHourAndMinute(
        DateTime.fromMillisecondsSinceEpoch(
            data['sys']['sunset'].toInt() * 1000,
            isUtc: false),
      ),
      feelLike: data['main']['feels_like'].round(),
      getDate: UsefulFunction.getDate(
        DateTime.fromMillisecondsSinceEpoch(data['dt'].toInt() * 1000,
            isUtc: false),
      ),
      dateTime: DateTime.fromMillisecondsSinceEpoch(data['dt'].toInt() * 1000,
          isUtc: false),
      getDescription:
          UsefulFunction.capitalize(data['weather'][0]['description']),
      getCityName: data['name'],
      getWeatherIcon:
          WeatherModel.getWeatherIcon(data['weather'][0]['id'].toInt()),
      getWeatherIconOfOpenWeather:
          "http://openweathermap.org/img/wn/${data['weather'][0]['icon']}@2x.png",
    );
  }
}

class CurrentOneCallOpenWeather {
  String? uvi, sunRise, sunSet, pressure, clouds, windGust;
  CurrentOneCallOpenWeather(
      {this.pressure,
      this.sunRise,
      this.sunSet,
      this.uvi,
      this.clouds,
      this.windGust});

  factory CurrentOneCallOpenWeather.fromJson(Map<String, dynamic> data) {
    return CurrentOneCallOpenWeather(
      uvi: data['uvi'].round().toString(),
      sunRise: UsefulFunction.getHourAndMinute(
        DateTime.fromMillisecondsSinceEpoch(data['sunrise'].toInt() * 1000,
            isUtc: false),
      ),
      sunSet: UsefulFunction.getHourAndMinute(
        DateTime.fromMillisecondsSinceEpoch(data['sunset'].toInt() * 1000,
            isUtc: false),
      ),
      pressure: NumberFormat("###,###.###", 'tr_TR')
          .format(data['pressure'])
          .toString(),
      clouds: data['clouds'].toString(),
      windGust: data['wind_gust'].toString(),
    );
  }
}

// Xoa mu, lam list thanh pho, viet lai networking (toJson, fromJson)
