import 'package:climate_app/services/list_chose_city.dart';
import 'package:flutter/material.dart';
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
  bool myLocation = true;
  String cityName = "";
  CurrentWeatherData? data;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentWeatherData = widget.currentWeatherData;
    detailedWeatherData = widget.detailedWeatherData;
    location = widget.location;
    data = CurrentWeatherData.fromJson(currentWeatherData);
    cityName = data!.getCityName ?? "Unknown";
    // CityList.delAll();
    CityList.saveCity(
      MyCity(
        lat: location!.latitude!,
        lon: location!.longitude!,
        name: cityName,
        myLocation: true,
      ),
    ).then((res) {
      debugPrint(res.toString());

      debugPrint("here");
      CityList.readCityList().then((value) {
        for (int i = 0; i < value.length; i++) {
          debugPrint('${value[i].name} ${value[i].lat} ${value[i].lon}');
        }
      });
    });
    // debugPrint(widget.detailedWeatherData.toString());
  }

  Future<bool> updateWeather({Map<String, dynamic>? geo}) async {
    try {
      WeatherModel weatherModel = WeatherModel();
      MyLocation getLocation;
      if (geo == null && location == null) {
        getLocation = await weatherModel.getCurrentWeatherByLocation();
      } else {
        //Ưu tiên tìm theo tên thành phố trước
        if (geo != null) {
          getLocation =
              await weatherModel.getCurrentWeatherByLocation(geo: geo);
        } else {
          //Nếu không search theo tên thành phố, cập nhật lại dữ liệu theo vị trí hiện tại
          getLocation = await weatherModel.getCurrentWeatherByLocation(
              geo: {'lat': location!.latitude, 'lon': location!.longitude});
        }
      }

      if (weatherModel.currentWeatherData != null &&
          weatherModel.detailWeatherData != null) {
        setState(() {
          currentWeatherData = weatherModel.currentWeatherData;
          debugPrint(weatherModel.detailWeatherData.toString());
          detailedWeatherData = weatherModel.detailWeatherData;
          // cityName = currentWeatherData['name'].toUpperCase();

          if (geo == null && location == null) {
            setState(() {
              data = CurrentWeatherData.fromJson(currentWeatherData);
              cityName = data!.getCityName ?? "Unknown".toUpperCase();
              // cityName = currentWeatherData['name'].toUpperCase();
            });
          } else {
            if (geo != null) {
              setState(() {
                cityName = geo['name'];
              });
            }
          }
          location = getLocation;
        });
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
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
            //bấm vô: đổi icon(mặt trời -> mặt trăng; mặt trăng -> mặt trời)
            //setState()
            //đổi giả trị cho switchButton:
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
              // CapturedThemes themes =
              //     InheritedTheme.capture(from: context, to: navigator.context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CityPicker(
                    latitude: location?.latitude ?? 0,
                    longtitude: location?.longitude ?? 0,
                    darkTheme: darkMode,
                  ),
                ),
              ).then(
                (value) async {
                  if (value == null ||
                      !value.containsKey('lat') ||
                      !value.containsKey('lon')) {
                    debugPrint('null');
                    if (value != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed search'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  } else {
                    debugPrint(value.toString());
                    myLocation = value['myLocation'];
                    bool updateSuccess = false;
                    if (myLocation == false) {
                      updateSuccess = await updateWeather(geo: value);
                    } else {
                      location = null;
                      updateSuccess = await updateWeather();
                    }
                    if (updateSuccess == true) {
                      debugPrint(value['myLocation'].toString());
                      CityList.saveCity(
                        MyCity(
                          lat: value['lat'],
                          lon: value['lon'],
                          name: value['name'],
                          myLocation: value['myLocation'],
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
        backgroundColor: darkMode == true
            ? const Color(0xFF0B0C1E)
            : const Color(0xDBDBF3F3),
        elevation: 0.0,
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            cityName.toUpperCase(),
            style: TextStyle(
              color: darkMode == true ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          if (myLocation == true) {
            location = null;
          }
          await updateWeather();
        },
        child: Container(
          color: darkMode == true
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
                    data: CurrentWeatherData.fromJson(currentWeatherData),
                  ),
                  AirQualityCard(
                      data: CurrentWeatherData.fromJson(currentWeatherData),
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
      ),
    );
  }
}
