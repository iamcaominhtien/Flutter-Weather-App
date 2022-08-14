import 'package:auto_size_text/auto_size_text.dart';
import 'package:climate_app/services/list_chose_city.dart';
import 'package:climate_app/services/my_weather_provider.dart';
import 'package:climate_app/services/useful_func.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/weather_card.dart';
import '../../components/air_quality_card.dart';
import '../../components/other_weather_info.dart';
import '../../components/hours_weather.dart';
import '../../services/widget_app.dart';
import '../city_picker.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  IconData switchButton = Icons.light_mode;
  dynamic colorSwitchButton = Colors.yellow;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late MyWeatherProvider provider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    provider = Provider.of<MyWeatherProvider>(context, listen: false);
    provider.updateSearchedListCity();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyWeatherProvider>(
      builder: (context, provider, child) => Scaffold(
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
                provider.updateDarkMode();
              });
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CityPicker(
                      latitude: provider.location?.latitude ?? 0,
                      longtitude: provider.location?.longitude ?? 0,
                      darkTheme: provider.darkMode,
                    ),
                  ),
                ).then(
                  (value) async {
                    if (value == null ||
                        !value.containsKey('lat') ||
                        !value.containsKey('lon')) {
                      if (value != null) {
                        UsefulFunction.showSnackBar(
                            context: context, message: 'Failed search');
                      }
                    } else {
                      provider.myLocation = value['myLocation'];
                      bool updateSuccess = false;
                      if (provider.myLocation == false) {
                        updateSuccess = await updateWeather(geo: value);
                      } else {
                        provider.location = null;
                        updateSuccess = await updateWeather();
                      }

                      if (updateSuccess == true) {
                        provider.updateSearchedListCity(
                          city: MyCity(
                            lat: value['lat'],
                            lon: value['lon'],
                            name: value['name'],
                            myLocation: provider.myLocation,
                          ),
                        );
                      }
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
          backgroundColor: provider.darkMode == true
              ? const Color(0xFF0B0C1E)
              : const Color(0xDBDBF3F3),
          elevation: 0.0,
          title: AutoSizeText(
            provider.cityName.toUpperCase(),
            style: TextStyle(
              color: provider.darkMode == true ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
            maxLines: 1,
          ),
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () async {
            if (provider.myLocation == true) {
              provider.location = null;
            }
            await updateWeather();
          },
          child: Container(
            color: provider.darkMode == true
                ? const Color(0xFF0B0C1E)
                : const Color(0xDBDBF3F3),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    WeatherCard(
                      data: provider.currentWeatherDataFromJson,
                    ),
                    AirQualityCard(
                        data: provider.currentWeatherDataFromJson,
                        daily: false),
                    const HoursWeather(),
                    const OtherWidgetInformation(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> updateWeather({Map<String, dynamic>? geo}) async {
    return provider.updateWeather(geo: geo).then((value) {
      if (value == true) {
        if (provider.myLocation == true) {
          //Update widget app (only use for current location)
          sendAndUpdate(provider.weatherModel);
        }

        if (provider.myLocation == true) {
          provider.updateSearchedListCity();
        }
        // provider.
        return true;
      } else {
        UsefulFunction.showSnackBar(context: context, message: 'Failed update');
        return false;
      }
    }).catchError((onError) {
      debugPrint('Failed on updateWeather: ' + onError.toString());
      return false;
    });
  }
}
