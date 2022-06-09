import 'package:climate_app/services/weather.dart';
import '../services/location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'error_page.dart';
import 'location_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  var location = MyLocation();
  var weatherModel = WeatherModel();
  dynamic currentWeatherData;
  dynamic detailedWeatherData;
  String labelUpdateButton = "update";

  @override
  void initState() {
    super.initState();
    getCurrentWeatherData();
  }

  Future getCurrentWeatherData() async {
    try {
      var location = await weatherModel.getCurrentWeatherByLocation();
      // debugPrint(weatherModel.currentWeatherData.toString());
      if (weatherModel.currentWeatherData != null &&
          weatherModel.detailWeatherData != null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => LocationScreen(
                      currentWeatherData: weatherModel.currentWeatherData,
                      detailedWeatherData: weatherModel.detailWeatherData,
                      location: location,
                    )));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ErrorPage(),
            ));
      }
    } catch (e) {
      debugPrint(e.toString());
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ErrorPage(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SpinKitWave(
        color: Colors.blue,
        size: 100,
      ),
    );
  }
}
