import 'dart:async';
import 'dart:convert';
import 'package:climate_app/services/list_chose_city.dart';
import 'package:climate_app/services/networking.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../components/constants.dart';
import '../components/list_city_item_card_child.dart';
import '../components/my_search_delegate.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

dynamic jsonResponse;

class CityPicker extends StatefulWidget {
  const CityPicker(
      {Key? key,
      required this.latitude,
      required this.longtitude,
      required this.darkTheme})
      : super(key: key);
  final double latitude;
  final double longtitude;
  final bool darkTheme;

  @override
  State<CityPicker> createState() => _CityPickerState();
}

class _CityPickerState extends State<CityPicker> {
  // List<String> searchList = [];
  List<MyCity>? listCity;

  Future<String> _loadFromAsset() async {
    return await rootBundle.loadString("assets/cities.json");
  }

  Future<dynamic> parseJson() async {
    String jsonString = await _loadFromAsset();
    // jsonResponse = jsonDecode(jsonString);
    return jsonDecode(jsonString);
  }

  Future<int?> _loading() async {
    try {
      jsonResponse = await parseJson();
      listCity = await CityList.readCityList();
      if (jsonResponse != null && listCity != null) {
        return 1;
      } else {
        return null;
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int?>(
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor:
                widget.darkTheme ? const Color(0xFF0B0C1E) : Colors.white,
            body: Center(
              child: Text(
                snapshot.error.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.darkTheme ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        }
        if (!snapshot.hasData) {
          return Scaffold(
              backgroundColor:
                  widget.darkTheme ? const Color(0xFF0B0C1E) : Colors.white,
              body: const Center(
                child: SpinKitDoubleBounce(
                  color: Colors.blue,
                  size: 100,
                ),
              ));
        }

        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/sunny.jfif'),
              colorFilter: ColorFilter.mode(Colors.blue, BlendMode.modulate),
              fit: BoxFit.fill,
            ),
            // color: Colors.black.withOpacity(1),
          ),
          child: Scaffold(
              // backgroundColor:
              //     widget.darkTheme ? const Color(0xFF0B0C1E) : Colors.white,
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                // backgroundColor:
                //     widget.darkTheme ? const Color(0xFF0B0C1E) : Colors.blue,
                backgroundColor: Colors.transparent,
                title: const Text('Search'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: MySearch(
                            popContext: context,
                            jsonResponse: jsonResponse,
                            darkTheme: widget.darkTheme),
                      ).then((value) {
                        debugPrint(value);
                      });
                    },
                  )
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ListView.builder(
                  itemCount: listCity!.length,
                  itemBuilder: (context, index) {
                    var item = listCity![index];
                    var weatherData = CurrentWeatherData.fromJson(
                        listCity![index].currentWeatherData);

                    return Container(
                        height: 100,
                        margin: const EdgeInsets.symmetric(
                            vertical: 7, horizontal: 15),
                        decoration: const BoxDecoration(
                          // color: Colors.blue,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                          // color: null,
                          image: kBackgroundGradient,
                        ),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            shape: MaterialStateProperty.all(
                              const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20.0),
                                ),
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context, {
                              'lat': item.lat,
                              'lon': item.lon,
                              'name': item.name
                            });
                          },
                          child: item.myLocation
                              ? ListCityItemCardChild(
                                  item: item, weatherData: weatherData)
                              : Slidable(
                                  key: const ValueKey(0),
                                  endActionPane: ActionPane(
                                    extentRatio: 0.5,
                                    motion: const StretchMotion(),
                                    children: [
                                      Theme(
                                        data: ThemeData(
                                          iconTheme:
                                              const IconThemeData(size: 40.0),
                                        ),
                                        child: SlidableAction(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(20.0),
                                          ),
                                          onPressed: (context) {
                                            setState(() {
                                              CityList.delCity(item)
                                                  .whenComplete(() {
                                                setState(() {
                                                  listCity!.remove(item);
                                                });
                                              });
                                            });
                                          },
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          icon: Icons.delete_forever,
                                          // label: 'Save',
                                        ),
                                      ),
                                    ],
                                  ),
                                  child: ListCityItemCardChild(
                                      item: item, weatherData: weatherData),
                                ),
                        ));
                  },
                ),
              )),
        );
      },
      future: _loading(),
    );
  }
}
