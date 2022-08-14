import 'package:climate_app/services/my_weather_provider.dart';
import 'package:climate_app/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/next_sevenday_weather.dart';
import 'hours_weather_item.dart';

class HoursWeather extends StatelessWidget {
  const HoursWeather({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MyWeatherProvider>(
      builder: (context, provider, child) => SizedBox(
        height: 250,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '24h tới',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: provider.darkMode == true
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NextSevenDayWeather(
                            weatherData: provider.detailedWeatherDataJson,
                            darkModel: provider.darkMode,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      '7 ngày tới',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF9F62E9)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: 190,
              child: ListView.builder(
                itemCount: 24,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, int index) {
                  var data = HoursWeatherData.fromJson(
                      provider.detailedWeatherDataJson['hourly'][index]);

                  return HourWeatherItem(data: data, index: index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
