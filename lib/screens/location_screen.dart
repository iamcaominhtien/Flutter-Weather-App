import 'package:flutter/material.dart';
import '../components/constants.dart';
import '../components/weather_card.dart';
import '../services/location.dart';
import '../services/networking.dart';
import '../services/weather.dart';
import '../components/air_quality_card.dart';
import '../components/other_weather_info.dart';
import '../components/hours_weather.dart';
import 'city_picker.dart';

class LocationScreen extends StatefulWidget {
  final dynamic currentWeatherData;
  final dynamic detailedWeatherData;
  final MyLocation? location;
  const LocationScreen(
      {Key? key,
      required this.currentWeatherData,
      required this.detailedWeatherData,
      this.location})
      : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  MyLocation? location;
  var weatherModel = WeatherModel();
  dynamic currentWeatherData;
  dynamic detailedWeatherData;
  String labelUpdateButton = "update";
  IconData switchButton = Icons.light_mode;
  dynamic colorSwitchButton = Colors.yellow;
  bool darkMode = false;
  String cityName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentWeatherData = widget.currentWeatherData;
    detailedWeatherData = widget.detailedWeatherData;
    location = widget.location;
    cityName = currentWeatherData['name'].toUpperCase();
    debugPrint(widget.detailedWeatherData.toString());
  }

  Future<bool> updateWeather({Map<String, dynamic>? geo}) async {
    try {
      WeatherModel weatherModel = WeatherModel();
      MyLocation getLocation;
      if (geo == null) {
        getLocation = await weatherModel.getCurrentWeatherByLocation();
      } else {
        getLocation = await weatherModel.getCurrentWeatherByLocation(geo: geo);
      }

      if (weatherModel.currentWeatherData != null &&
          weatherModel.detailWeatherData != null) {
        setState(() {
          currentWeatherData = weatherModel.currentWeatherData;
          debugPrint(weatherModel.detailWeatherData.toString());
          detailedWeatherData = weatherModel.detailWeatherData;
          // cityName = currentWeatherData['name'].toUpperCase();
          location = getLocation;
          labelUpdateButton = 'update';
        });
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() {
        labelUpdateButton = 'update';
      });
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Failed update'),
        duration: Duration(seconds: 3),
      ),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    NavigatorState navigator = Navigator.of(context);
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
              CapturedThemes themes =
                  InheritedTheme.capture(from: context, to: navigator.context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => themes.wrap(
                    CityPicker(
                      latitude: location?.latitude ?? 0,
                      longtitude: location?.longitude ?? 0,
                      darkTheme: darkMode,
                    ),
                  ),
                ),
              ).then(
                (value) {
                  if (value == null ||
                      !value.containsKey('lat') ||
                      !value.containsKey('lon')) {
                    debugPrint('null');
                  } else {
                    debugPrint(value.toString());
                    setState(() {
                      labelUpdateButton = 'updating...';
                    });
                    updateWeather(geo: value).then((updateResult) {
                      if (updateResult == true) {
                        cityName = value['name'];
                      }
                    });
                  }
                },
              );
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
              cityName,
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
                      labelUpdateButton = 'updating...';
                    });
                    updateWeather().then((value) {
                      if (value == true) {
                        setState(() {
                          cityName = currentWeatherData['name'].toUpperCase();
                        });
                      }
                    });
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
