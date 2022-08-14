import 'dart:async';
import 'package:climate_app/services/my_weather_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import '../components/widget_app_data.dart';
import '../screens/index.dart';
import 'networking.dart';
import 'weather.dart';
import 'package:provider/provider.dart';

Future<void> sendAndUpdate(WeatherModel myWeatherModel) async {
  debugPrint(
      'WeatherModel: current api:  ${myWeatherModel.currentWeatherData}');
  loadWidgetData(myWeatherModel: myWeatherModel).then((value) async {
    await sendData(value);
    await updateWidget();
  });
}

Future sendData(WidgetAppData? dataWeather) async {
  try {
    if (dataWeather != null) {
      return Future.wait([
        HomeWidget.saveWidgetData<String>('cityName', dataWeather.cityName),
        HomeWidget.saveWidgetData<String>(
            'description', dataWeather.description),
        HomeWidget.saveWidgetData<String>('day0', dataWeather.day0),
        HomeWidget.saveWidgetData<String>('day1', dataWeather.day1),
        HomeWidget.saveWidgetData<String>('day2', dataWeather.day2),
        HomeWidget.saveWidgetData<String>('day3', dataWeather.day3),
        HomeWidget.saveWidgetData<String>('day4', dataWeather.day4),
        HomeWidget.saveWidgetData<String>('temp0', dataWeather.temp0),
        HomeWidget.saveWidgetData<String>('temp1', dataWeather.temp1),
        HomeWidget.saveWidgetData<String>('temp2', dataWeather.temp2),
        HomeWidget.saveWidgetData<String>('temp3', dataWeather.temp3),
        HomeWidget.saveWidgetData<String>('temp4', dataWeather.temp4),
        HomeWidget.saveWidgetData<String>(
            'currentTemp', dataWeather.currentTemp),
      ]);
    }
  } on PlatformException catch (exception) {
    debugPrint('Error Sending Data. $exception');
  }
}

Future updateWidget() async {
  try {
    return HomeWidget.updateWidget(
        name: 'HomeWidgetExampleProvider', iOSName: 'HomeWidgetExample');
  } on PlatformException catch (exception) {
    debugPrint('Error Updating Widget. $exception');
  }
}

Future<WidgetAppData> loadWidgetData({WeatherModel? myWeatherModel}) async {
  var weatherModel = WeatherModel();
  if (myWeatherModel == null) {
    await weatherModel.getCurrentWeatherByLocation();
  } else {
    weatherModel = myWeatherModel;
  }
  DailyWeatherData daily0 =
      DailyWeatherData.fromJson(weatherModel.detailWeatherData['daily'][1]);
  DailyWeatherData daily1 =
      DailyWeatherData.fromJson(weatherModel.detailWeatherData['daily'][2]);
  DailyWeatherData daily2 =
      DailyWeatherData.fromJson(weatherModel.detailWeatherData['daily'][3]);
  DailyWeatherData daily3 =
      DailyWeatherData.fromJson(weatherModel.detailWeatherData['daily'][4]);
  DailyWeatherData daily4 =
      DailyWeatherData.fromJson(weatherModel.detailWeatherData['daily'][5]);
  CurrentWeatherData current =
      CurrentWeatherData.fromJson(weatherModel.currentWeatherData);
  var widgetApp = WidgetAppData(
    cityName: current.getCityName,
    day0: daily0.getOnlyDayNumber,
    day1: daily1.getOnlyDayNumber,
    day2: daily2.getOnlyDayNumber,
    day3: daily3.getOnlyDayNumber,
    day4: daily4.getOnlyDayNumber,
    currentTemp: current.temp.toString() + "°C",
    description: current.getDescription,
    temp0: daily0.temp.toString() + "°C",
    temp1: daily1.temp.toString() + "°C",
    temp2: daily2.temp.toString() + "°C",
    temp3: daily3.temp.toString() + "°C",
    temp4: daily4.temp.toString() + "°C",
  );
  return widgetApp;
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyWeatherProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Climate App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // HomeWidget.setAppGroupId('YOUR_GROUP_ID');
    // HomeWidget.registerBackgroundCallback(backgroundCallback);
    // getWidgetDataInitial();
    // // HomeWidget.initiallyLaunchedFromHomeWidget().then(_launchedFromWidget);
    // didChangeDependencies();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   _checkForWidgetLaunch();
  //   HomeWidget.widgetClicked.listen(_launchedFromWidget);
  // }

  void _checkForWidgetLaunch() {
    if (kDebugMode) {
      print('------');
    }
    HomeWidget.initiallyLaunchedFromHomeWidget().then(_launchedFromWidget);
  }

  void _launchedFromWidget(Uri? uri) {
    if (kDebugMode) {
      print(uri);
    }
  }

  /// Called when Doing Background Work initiated from Widget
  void backgroundCallback(Uri? data) async {
    if (kDebugMode) {
      print(data);
    }

    if (data?.host == 'titleclicked') {
      // final selectedGreeting = greetings[Random().nextInt(greetings.length)];
      loadWidgetData().then((dataWeather) async {
        debugPrint('cityName: ${dataWeather.cityName}');
        sendData(dataWeather).whenComplete(() async {
          await HomeWidget.updateWidget(
              name: 'HomeWidgetExampleProvider', iOSName: 'HomeWidgetExample');
        });
      });
    }
  }

  void getWidgetDataInitial() {
    loadWidgetData().then((dataWeather) async {
      debugPrint('cityName: ${dataWeather.cityName}');
      sendData(dataWeather).whenComplete(() async {
        await HomeWidget.updateWidget(
            name: 'HomeWidgetExampleProvider', iOSName: 'HomeWidgetExample');
      });
    });
  }
}
