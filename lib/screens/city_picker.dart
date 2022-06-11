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

  Future<String> _loadFromAsset() async {
    return await rootBundle.loadString("assets/cities.json");
  }

  Future parseJson() async {
    String jsonString = await _loadFromAsset();
    jsonResponse = jsonDecode(jsonString);
    return jsonResponse;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            // backgroundColor: ,
            body: Center(
              child: Text(snapshot.error.toString()),
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        }
        // dynamic data = snapshot.data;
        return Scaffold(
          backgroundColor:
              widget.darkTheme ? const Color(0xFF0B0C1E) : Colors.white,
          appBar: AppBar(
            backgroundColor:
                widget.darkTheme ? const Color(0xFF0B0C1E) : Colors.blue,
            title: const Text('Search'),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  showSearch(
                          context: context,
                          delegate: MySearch(
                              popContext: context, jsonResponse: jsonResponse))
                      .then((value) {
                    debugPrint(value);
                  });
                },
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: FutureBuilder<List<MyCity>>(
              future: CityList.readCityList(),
              builder: (context, snapShot) {
                if (snapShot.hasError) {
                  return const Center(
                    child: Text('Lỗi khi tải dữ liệu'),
                  );
                }
                if (!snapShot.hasData) {
                  return Center(
                    child: SpinKitDoubleBounce(),
                  );
                }
                var data = snapShot.data;
                return ListView.builder(
                  itemCount: data!.length,
                  itemBuilder: (context, index) {
                    var item = data[index];
                    var weatherData = CurrentWeatherData.fromJson(
                        data[index].currentWeatherData);

                    return Container(
                      height: 100,
                      margin: const EdgeInsets.symmetric(
                          vertical: 7, horizontal: 15),
                      decoration: const BoxDecoration(
                        // color: Colors.blue,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                        color: Color(0xFF5564F0),
                        image: kBackgroundGradient,
                      ),
                      // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: item.myLocation
                          ? ListCityItemCardChild(
                              item: item, weatherData: weatherData)
                          : Slidable(
                              key: const ValueKey(0),
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
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
                                              data.remove(item);
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
                    );
                  },
                );
              },
            ),
          ),
        );
        // return Container();
      },
      future: parseJson(),
    );
  }
}
