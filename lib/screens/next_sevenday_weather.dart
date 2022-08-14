import 'package:climate_app/services/my_weather_provider.dart';
import 'package:climate_app/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/air_quality_card.dart';
import '../components/weather_card.dart';

class NextSevenDayWeather extends StatefulWidget {
  const NextSevenDayWeather(
      {Key? key, this.weatherData, required this.darkModel})
      : super(key: key);

  @override
  State<NextSevenDayWeather> createState() => _NextSevenDayWeatherState();
  final dynamic weatherData;
  final bool darkModel;
}

class _NextSevenDayWeatherState extends State<NextSevenDayWeather> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            widget.darkModel == true ? const Color(0xFF0B0C1E) : Colors.white,
      ),
      child: Consumer<MyWeatherProvider>(
        builder: (context, provider, child) => Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: provider.darkMode == true ? Colors.white : Colors.black,
            ),
            elevation: 0.0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: Text(
              '7 ngày tới',
              style: TextStyle(
                color: provider.darkMode == true ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                WeatherCard(
                  data: DailyWeatherData.fromJson(
                      provider.detailedWeatherDataJson['daily'][1]),
                ),
                const SizedBox(
                  height: 15,
                ),
                AirQualityCard(
                    data: DailyWeatherData.fromJson(
                        provider.detailedWeatherDataJson['daily'][1]),
                    daily: true),
                Expanded(
                  child: provider.listNextWeather!,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
