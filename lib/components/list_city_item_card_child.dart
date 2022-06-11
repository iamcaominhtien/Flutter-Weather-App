import 'package:climate_app/services/list_chose_city.dart';
import 'package:climate_app/services/networking.dart';
import 'package:climate_app/services/useful_func.dart';
import 'package:flutter/material.dart';

class ListCityItemCardChild extends StatelessWidget {
  const ListCityItemCardChild({
    Key? key,
    required this.item,
    required this.weatherData,
  }) : super(key: key);

  final MyCity item;
  final CurrentWeatherData weatherData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  item.myLocation
                      ? const Text(
                          'My Location',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          item.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                  item.myLocation
                      ? Text(
                          item.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          UsefulFunction.getHourAndMinute(
                              weatherData.dateTime, true),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ],
              ),
              Text(
                weatherData.getDescription ?? "Unknown",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${weatherData.temp}°C',
                style: const TextStyle(
                  fontSize: 26.0,
                  color: Colors.white,
                ),
              ),
              Image.network(
                weatherData.getWeatherIconOfOpenWeather!,
                width: 50,
              ),
            ],
          )
        ],
      ),
    );
  }
}
