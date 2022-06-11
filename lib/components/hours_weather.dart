import 'package:climate_app/services/networking.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import '../screens/next_sevenday_weather.dart';

class HoursWeather extends StatefulWidget {
  const HoursWeather({
    Key? key,
    required this.detailedWeatherData,
    required this.darkMode,
  }) : super(key: key);

  final dynamic detailedWeatherData;
  final bool darkMode;

  @override
  State<HoursWeather> createState() => _HoursWeatherState();
}

class _HoursWeatherState extends State<HoursWeather> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                    color:
                        widget.darkMode == true ? Colors.white : Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NextSevenDayWeather(
                                  weatherData: widget.detailedWeatherData,
                                  darkModel: widget.darkMode,
                                )));
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
                    widget.detailedWeatherData['hourly'][index]);
                debugPrint(
                    widget.detailedWeatherData['hourly'][index].toString());

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(30)),
                        //color: (index == 0) ? null : Colors.white,
                        color: (index == 0) ? null : Colors.grey[300],
                        image: index == 0 ? kBackgroundGradient : null,
                      ),
                      margin:
                          const EdgeInsets.only(right: 20, bottom: 10, top: 10),
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
                          // Image.asset(
                          //   data.getWeatherIcon(),
                          //   width: 50,
                          // ),
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
