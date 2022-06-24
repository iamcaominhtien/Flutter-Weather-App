import 'package:climate_app/services/useful_func.dart';
import 'package:flutter/material.dart';
import '../services/weather.dart';
import 'location_screen.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Sorry, something went wrong',
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
          Image.asset('assets/error_page.png'),
          ElevatedButton(
            onPressed: () async {
              UsefulFunction.showSnackBar(
                  context: context, message: 'Trying again...', seconds: 6000);
              var weatherModel = WeatherModel();
              await weatherModel.getCurrentWeatherByLocation().then((value) {
                if (weatherModel.currentWeatherData != null &&
                    weatherModel.detailWeatherData != null) {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LocationScreen(
                        currentWeatherData: weatherModel.currentWeatherData,
                        detailedWeatherData: weatherModel.detailWeatherData,
                        location: value,
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  UsefulFunction.showSnackBar(
                      context: context, message: 'Failed again');
                }
              }).catchError((onError) {
                debugPrint(onError.toString());
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                UsefulFunction.showSnackBar(
                      context: context, message: 'Failed again');
              });
            },
            child: const Text(
              'Try again',
              style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
//AIzaSyDnGfvByejGKhL0UccR8A63-7-bpow_6h8
