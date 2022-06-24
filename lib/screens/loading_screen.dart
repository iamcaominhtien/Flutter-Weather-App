import 'package:climate_app/services/useful_func.dart';
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
      if (weatherModel.currentWeatherData != null &&
          weatherModel.detailWeatherData != null) {
        UsefulFunction.pushReplacement(
          context: context,
          page: LocationScreen(
            currentWeatherData: weatherModel.currentWeatherData,
            detailedWeatherData: weatherModel.detailWeatherData,
            location: location,
          ),
        );
      } else {
        UsefulFunction.pushReplacement(
            context: context, page: const ErrorPage());
      }
    } catch (e) {
      debugPrint(e.toString());
      UsefulFunction.pushReplacement(context: context, page: const ErrorPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/sunny.jfif'),
          colorFilter: ColorFilter.mode(Colors.blue, BlendMode.modulate),
          fit: BoxFit.fill,
        ),
        // color: Colors.black.withOpacity(1),
      ),
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SpinKitPouringHourGlassRefined(
            color: Colors.white,
            size: 300,
          ),
        ),
      ),
    );
  }
}
