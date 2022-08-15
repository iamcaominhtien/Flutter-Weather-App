import 'dart:convert';
import 'package:climate_app/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'list_chose_city.dart';
import 'location.dart';
import 'networking.dart';

class MyWeatherProvider extends ChangeNotifier {
  MyLocation? location;
  var weatherModel = WeatherModel();
  dynamic currentWeatherDataJson;
  dynamic detailedWeatherDataJson;
  dynamic currentWeatherDataFromJson;
  dynamic detailedWeatherDataFromJson;
  String cityName = '';
  bool darkMode = false;
  bool myLocation = true;
  Widget? listNextWeather;
  dynamic listJsonCities;
  List<MyCity>? listSearchedCities;
  DateTime? listSearchedCitiesLastUpdate;

  Future<bool> initialCurrentWeatherData() async {
    try {
      location = await weatherModel.getCurrentWeatherByLocation();
      if (weatherModel.currentWeatherData != null &&
          weatherModel.detailWeatherData != null) {
        currentWeatherDataJson = weatherModel.currentWeatherData;
        detailedWeatherDataJson = weatherModel.detailWeatherData;
        currentWeatherDataFromJson =
            CurrentWeatherData.fromJson(currentWeatherDataJson);
        cityName = currentWeatherDataFromJson!.getCityName ?? "Unknown";
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
    getNextSevenDayWeather();
    return true;
  }

  Future<bool> updateWeather({Map<String, dynamic>? geo}) async {
    MyLocation? getLocation;

    try {
      if (geo == null && location == null) {
        getLocation = await weatherModel.getCurrentWeatherByLocation();
      } else {
        //priority for cityName search
        if (geo != null) {
          getLocation =
              await weatherModel.getCurrentWeatherByLocation(geo: geo);
        } else {
          //update by current location
          getLocation = await weatherModel.getCurrentWeatherByLocation(
              geo: {'lat': location!.latitude, 'lon': location!.longitude});
        }
      }

      if (weatherModel.currentWeatherData != null &&
          weatherModel.detailWeatherData != null) {
        currentWeatherDataJson = weatherModel.currentWeatherData;
        detailedWeatherDataJson = weatherModel.detailWeatherData;
        currentWeatherDataFromJson =
            CurrentWeatherData.fromJson(currentWeatherDataJson);

        if (geo == null && location == null) {
          cityName = currentWeatherDataFromJson!.getCityName ??
              "Unknown".toUpperCase();
        } else {
          if (geo != null) {
            cityName = geo['name'];
          }
        }
        location = getLocation;
        getNextSevenDayWeather();
        notifyListeners();
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  void updateDarkMode() {
    darkMode = !darkMode;
    notifyListeners();
  }

  void getNextSevenDayWeather() {
    listNextWeather = ListView.builder(
      itemBuilder: (context, index) {
        var data =
            DailyWeatherData.fromJson(detailedWeatherDataJson['daily'][index]);

        if (index > 0) {
          TextStyle textStyle = TextStyle(
            color: darkMode == true ? Colors.white : const Color(0xFF717171),
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
    );
    // notifyListeners();
  }

  void updateMyLocationStatus(bool status) {
    myLocation = status;
    // notifyListeners();
  }

  Future<void> loadSearchedCityToJson() async {
    if (listJsonCities == null) {
      String jsonString = await rootBundle.loadString("assets/cities.json");
      listJsonCities = jsonDecode(jsonString);
    }
    if (listSearchedCities == null||DateTime.now().difference(listSearchedCitiesLastUpdate!).inHours > 1) {
      listSearchedCities = await CityList.readCityList();
      listSearchedCitiesLastUpdate = DateTime.now();
    }
  }

  void updateSearchedListCity({MyCity? city}) async {
    // listSearchedCities = await CityList.readCityList();
    MyCity myCity = city ??
        MyCity(
          lat: location!.latitude!,
          lon: location!.longitude!,
          name: cityName,
          myLocation: myLocation,
        );
    CityList.saveCity(
      myCity,
    ).then((value) async {
      if (value == true) {
        listSearchedCities = await CityList.readCityList();
        listSearchedCitiesLastUpdate = DateTime.now();

        // if (listSearchedCities != null) {
        //   for (int i = 0; i < listSearchedCities!.length; i++) {
        //     debugPrint(
        //         '${listSearchedCities![i].name} ${listSearchedCities![i].lat} ${listSearchedCities![i].lon}');
        //   }
        // }
      }
    });

    // notifyListeners();
  }

  void delItemOfListSearchedCity(MyCity city) {
    listSearchedCities?.remove(city);
    notifyListeners();
  }
}
