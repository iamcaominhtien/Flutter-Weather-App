import 'package:flutter/material.dart';
import '../components/constants.dart';
import '../components/weather_card.dart';
import '../services/location.dart';
import '../services/networking.dart';
import '../services/weather.dart';
import '../components/air_quality_card.dart';
import '../components/other_weather_info.dart';
import '../components/hours_weather.dart';

class LocationScreen extends StatefulWidget {
  final dynamic currentWeatherData;
  final dynamic detailedWeatherData;
  const LocationScreen(
      {Key? key,
      required this.currentWeatherData,
      required this.detailedWeatherData})
      : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  var location = MyLocation();
  var weatherModel = WeatherModel();
  dynamic currentWeatherData;
  dynamic detailedWeatherData;
  String labelUpdateButton = "update";
  IconData switchButton = Icons.light_mode;
  dynamic colorSwitchButton = Colors.yellow;
  bool darkMode = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentWeatherData = widget.currentWeatherData;
    detailedWeatherData = widget.detailedWeatherData;
    debugPrint(widget.detailedWeatherData.toString());
  }

  void updateWeather() async {
    WeatherModel weatherModel = WeatherModel();
    await weatherModel.getCurrentWeatherByLocation();
    setState(() {
      currentWeatherData = weatherModel.currentWeatherData;
      debugPrint(weatherModel.detailWeatherData.toString());
      detailedWeatherData = weatherModel.detailWeatherData;
      labelUpdateButton = 'update';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            switchButton,
            size: 40,
            color: colorSwitchButton,
          ),
          onPressed: () {
            setState(() {
              if (switchButton == Icons.light_mode) {
                switchButton = Icons.dark_mode;
                colorSwitchButton = Colors.white;
              } else {
                switchButton = Icons.light_mode;
                colorSwitchButton = Colors.yellow;
              }
              darkMode = !darkMode;
            });
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => const CityPicker()));
            },
            icon: const Icon(
              Icons.location_city,
              size: 30,
              color: Colors.blue,
            ),
          ),
        ],
        centerTitle: true,
        backgroundColor: darkMode == true
            ? const Color(0xFF0B0C1E)
            : const Color(0xDBDBF3F3),
        elevation: 0.0,
        title: Column(
          children: [
            Text(
              currentWeatherData['name'].toUpperCase(),
              style: TextStyle(
                color: darkMode == true ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: darkMode == true
            ? const Color(0xFF0B0C1E)
            : const Color(0xDBDBF3F3),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent),
                    elevation: MaterialStateProperty.all(0.0),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    child: Text(labelUpdateButton),
                    decoration: const BoxDecoration(
                      image: kBackgroundGradient,
                      borderRadius: BorderRadius.all(Radius.circular(18)),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      labelUpdateButton = 'updating';
                    });
                    updateWeather();
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                WeatherCard(
                  data: CurrentWeatherData(data: currentWeatherData),
                ),
                AirQualityCard(
                    data: CurrentWeatherData(data: currentWeatherData),
                    daily: false),
                HoursWeather(
                    detailedWeatherData: detailedWeatherData,
                    darkMode: darkMode),
                OtherWidgetInformation(data: detailedWeatherData),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
