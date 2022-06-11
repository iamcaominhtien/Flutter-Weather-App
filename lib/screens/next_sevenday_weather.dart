import 'package:climate_app/services/networking.dart';
import 'package:flutter/material.dart';
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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: widget.darkModel == true ? Colors.white : Colors.black,
          ),
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text(
            '7 ngày tới',
            style: TextStyle(
              color: widget.darkModel == true ? Colors.white : Colors.black,
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
                data: DailyWeatherData.fromJson(widget.weatherData['daily'][1]),
              ),
              const SizedBox(
                height: 15,
              ),
              AirQualityCard(
                  data:
                      DailyWeatherData.fromJson(widget.weatherData['daily'][1]),
                  daily: true),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var data = DailyWeatherData.fromJson(
                        widget.weatherData['daily'][index]);

                    if (index > 0) {
                      TextStyle textStyle = TextStyle(
                        color: widget.darkModel == true
                            ? Colors.white
                            : const Color(0xFF717171),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      );
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              data.getDayOfWeek ?? "Unknown",
                              style: textStyle,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    data.getWeatherIconOfOpenWeather ?? "",
                                    width: 70,
                                    // scale: 1.2,
                                  ),
                                  Flexible(
                                    child: Text(
                                      data.getMainDescription ?? "Unknown",
                                      textAlign: TextAlign.right,
                                      style: textStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '${data.minTemp}°C-${data.maxTemp}°C',
                              textAlign: TextAlign.right,
                              style: textStyle,
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox(
                      height: 0,
                    );
                  },
                  itemCount: 8,
                  scrollDirection: Axis.vertical,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
