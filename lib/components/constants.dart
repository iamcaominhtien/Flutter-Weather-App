import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/my_weather_provider.dart';

const kTempTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 100.0,
  fontWeight: FontWeight.w900,
  color: Colors.white,
);

const kMessageTextStyle = TextStyle(
  fontFamily: 'Spartan MB',
  fontSize: 60.0,
  fontWeight: FontWeight.w900,
  color: Colors.white,
);

const kButtonTextStyle = TextStyle(
  fontSize: 30.0,
  fontFamily: 'Spartan MB',
);

const kConditionTextStyle = TextStyle(
  fontSize: 100.0,
  fontWeight: FontWeight.w900,
  color: Colors.white,
);

//weather.dart
const kOpenWeatherMapAPIOneCall =
    'https://api.openweathermap.org/data/2.5/onecall?';
const kOpenWeatherMapAPICurrent =
    'https://api.openweathermap.org/data/2.5/weather?';

const kApiKey = "916e6631661d85ee0831cf126e346e86";

const kTextFieldInputDecoration = InputDecoration(
    filled: true,
    fillColor: Colors.white,
    icon: Icon(
      Icons.location_city,
      color: Colors.white,
    ),
    hintText: 'Enter city name',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide.none,
    ));

const kNumberOfWeatherDays = 7;

const kBackgroundGradient = DecorationImage(
  image: AssetImage('assets/bg_card1.jfif'),
  fit: BoxFit.fill,
);
