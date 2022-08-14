import 'package:flutter/material.dart';
import '../components/constants.dart';

class WeatherCard extends StatefulWidget {
  final dynamic data;
  const WeatherCard({Key? key, this.data}) : super(key: key);

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  @override
  Widget build(BuildContext context) {
    var data = widget.data;

    return Container(
      height: 200,
      decoration: BoxDecoration(
          color: const Color(0xFF5564F0),
          image: kBackgroundGradient,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9F62E9).withOpacity(.5),
              offset: const Offset(0, 25),
              blurRadius: 10,
              spreadRadius: -12,
            )
          ]),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -40,
            left: 20,
            child: Image.asset(
              data.getWeatherIcon,
              width: 160.0,
            ),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.getDescription,
                  style: const TextStyle(
                      leadingDistribution: TextLeadingDistribution.proportional,
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  data.getDate,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        '${data.temp}°C',
                        style: const TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  'Feels like ${data.feelLike}°C',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
