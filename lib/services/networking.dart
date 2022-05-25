import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'useful_func.dart';
import 'weather.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class NetworkingHelper {
  final String url;
  NetworkingHelper({
    required this.url,
  });

  Future getData() async {
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return response.statusCode;
  }
}

//Dữ liệu lấy từ API one-call của OpenWeather
class DailyWeatherData {
  dynamic data;

  DailyWeatherData({this.data});

  String windSpeed() {
    return (data['wind_speed']).toString();
  }

  String uvi() {
    return data['uvi'].round().toString();
  }

  String humidity() {
    return data['humidity'].toString();
  }

  String visibility() {
    return (data['visibility'] / 1000).round().toString();
  }

  int temp() {
    return data['temp']['day'].round();
  }

  int feelLike() {
    return data['feels_like']['day'].round();
  }

  int maxTemp() {
    return data['temp']['max'].round();
  }

  int minTemp() {
    return data['temp']['min'].round();
  }

  String getDate() {
    return UsefulFunction.getDate(
      DateTime.fromMillisecondsSinceEpoch(data['dt'].toInt() * 1000,
          isUtc: false),
    );
  }

  String getMainDescription() {
    return data['weather'][0]['main'];
  }

  String getDayOfWeek() {
    return UsefulFunction.getDayOfWeek(
      DateTime.fromMillisecondsSinceEpoch(
        data['dt'] * 1000,
      ),
    );
  }

  String getDescription() {
    return UsefulFunction.capitalize(data['weather'][0]['description']);
  }

  String getWeatherIcon() {
    return WeatherModel.getWeatherIcon(data['weather'][0]['id'].toInt());
  }

  ///Use Image.network
  String getWeatherIconOfOpenWeather() {
    return "http://openweathermap.org/img/wn/${data['weather'][0]['icon']}@2x.png";
  }
}

///Dữ liệu lấy từ api one-call của open weather
class HoursWeatherData {
  dynamic data;

  HoursWeatherData({this.data});

  int temp() {
    return data['temp'].round();
  }

  int feelLike() {
    return data['main']['feels_like'].round();
  }

  String getHour() {
    return UsefulFunction.getHour(
      DateTime.fromMillisecondsSinceEpoch(data['dt'].toInt() * 1000,
          isUtc: false),
    );
  }

  String getDescription() {
    return UsefulFunction.capitalize(data['weather'][0]['description']);
  }

  String getWeatherIcon() {
    return WeatherModel.getWeatherIcon(data['weather'][0]['id'].toInt());
  }

  ///Use Image.network
  String getWeatherIconOfOpenWeather() {
    return "http://openweathermap.org/img/wn/${data['weather'][0]['icon']}@2x.png";
  }
}

///Dữ liệu lấy từ API current của open weather
class CurrentWeatherData {
  dynamic data;

  CurrentWeatherData({this.data});

  String windSpeed() {
    return (data['wind']['speed']).toString();
  }

  String humidity() {
    return (data['main']['humidity']).round().toString();
  }

  String visibility() {
    return (data['visibility'] / 1000).round().toString();
  }

  int temp() {
    return data['main']['temp'].round();
  }

  String pressure() {
    return NumberFormat("###,###.###", 'tr_TR')
        .format(data['main']['pressure'])
        .toString();
  }

  String sunRise() {
    return UsefulFunction.getHourAndMinute(DateTime.fromMillisecondsSinceEpoch(
        data['sys']['sunrise'].toInt() * 1000,
        isUtc: false));
  }

  String sunSet() {
    return UsefulFunction.getHourAndMinute(DateTime.fromMillisecondsSinceEpoch(
        data['sys']['sunset'].toInt() * 1000,
        isUtc: false));
  }

  int feelLike() {
    return data['main']['feels_like'].round();
  }

  String getDate() {
    return UsefulFunction.getDate(
      DateTime.fromMillisecondsSinceEpoch(data['dt'].toInt() * 1000,
          isUtc: false),
    );
  }

  String getDescription() {
    return UsefulFunction.capitalize(data['weather'][0]['description']);
  }

  String getWeatherIcon() {
    return WeatherModel.getWeatherIcon(data['weather'][0]['id'].toInt());
  }
}

class CurrentOneCallOpenWeather {
  dynamic data;
  CurrentOneCallOpenWeather({this.data});

  String uvi() {
    return data['uvi'].round().toString();
  }

  String sunRise() {
    return UsefulFunction.getHourAndMinute(DateTime.fromMillisecondsSinceEpoch(
        data['sunrise'].toInt() * 1000,
        isUtc: false));
  }

  String sunSet() {
    return UsefulFunction.getHourAndMinute(DateTime.fromMillisecondsSinceEpoch(
        data['sunset'].toInt() * 1000,
        isUtc: false));
  }

  String pressure() {
    return NumberFormat("###,###.###", 'tr_TR')
        .format(data['pressure'])
        .toString();
  }

  String clouds() {
    return data['clouds'].toString();
  }

  String windGust() {
    return data['wind_gust'].toString();
  }
}
