import 'package:climate_app/services/my_weather_provider.dart';
import 'package:climate_app/services/useful_func.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
              var provider =
                  Provider.of<MyWeatherProvider>(context, listen: false);
              provider.initialCurrentWeatherData().then((value) {
                if (value == true) {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LocationScreen(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  UsefulFunction.showSnackBar(
                      context: context, message: 'Failed again');
                }
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
