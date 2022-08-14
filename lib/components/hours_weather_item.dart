import 'package:flutter/material.dart';

import '../services/networking.dart';
import 'constants.dart';

class HourWeatherItem extends StatelessWidget {
  const HourWeatherItem({
    Key? key,
    required this.data,
    required this.index,
  }) : super(key: key);

  final HoursWeatherData data;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            color: (index == 0) ? null : Colors.grey[300],
            image: index == 0 ? kBackgroundGradient : null,
          ),
          margin: const EdgeInsets.only(right: 20, bottom: 10, top: 10),
          width: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //'°C'
              Text(
                '${data.temp}°C',
                style: TextStyle(
                  color: index == 0 ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Image.network(
                data.getWeatherIconOfOpenWeather!,
                width: 80,
              ),
              Text(
                data.getHour! + ':00',
                style: TextStyle(
                  color: index == 0 ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
