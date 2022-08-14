import 'package:climate_app/services/my_weather_provider.dart';
import 'package:flutter/material.dart';
import '../services/networking.dart';
import 'package:provider/provider.dart';
import 'other_weather_info_card.dart';

class OtherWidgetInformation extends StatelessWidget {
  const OtherWidgetInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MyWeatherProvider>(
      builder: (context, provider, child) {
        var data = CurrentOneCallOpenWeather.fromJson(
            provider.detailedWeatherDataJson['current']);
        return Column(
          children: [
            SizedBox(
              height: 160,
              child: Row(
                children: [
                  OtherWidgetInformationCard(
                    bodyIcon: 'gauge',
                    value: data.pressure,
                    metric: 'hPA',
                    title: 'Áp suất khí quyển',
                    titleIcon: 'at_press',
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  OtherWidgetInformationCard(
                    title: 'Bình minh',
                    titleIcon: 'sunrise',
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          data.sunRise ?? "Unknown",
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 25,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Center(
                          child: Image.asset(
                            'assets/sunrise2.png',
                            width: 60,
                          ),
                        ),
                        Text('Hoàng hôn: ${data.sunSet ?? "Unknown"}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 160,
              child: Row(
                children: [
                  OtherWidgetInformationCard(
                    value: data.uvi,
                    title: 'Mức UV',
                    bodyIcon: 'uvi_white_black_2',
                    titleIcon: 'uv_white_black',
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  OtherWidgetInformationCard(
                    value: data.clouds,
                    metric: '%',
                    title: 'Mây phủ',
                    bodyIcon: 'cloud_icon',
                    titleIcon: 'partly-cloudy',
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      },
    );
  }
}
