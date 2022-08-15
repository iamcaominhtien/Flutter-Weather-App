import 'package:climate_app/services/useful_func.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/my_weather_provider.dart';
import 'error_page.dart';
import 'location_screen.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late MyWeatherProvider provider;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<MyWeatherProvider>(context, listen: false);
    provider.initialCurrentWeatherData().then((value) {
      value == true
          ? UsefulFunction.pushReplacement(
              context: context,
              page: const LocationScreen(),
            )
          : UsefulFunction.pushReplacement(
              context: context, page: const ErrorPage());
    });
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
