import 'package:flutter/material.dart';

class MySearch extends SearchDelegate {
  List<Map<String, dynamic>> searchItem(String template) {
    List<Map<String, dynamic>> result = [];
    if (template.isNotEmpty) {
      int n = jsonResponse.length, count = 8;
      for (int i = 0; i < n; i++) {
        if (jsonResponse[i]['name']
            .toUpperCase()
            .contains(template.toUpperCase())) {
          var item = {
            'name': jsonResponse[i]['name'],
            'lon': jsonResponse[i]['lng'],
            'lat': jsonResponse[i]['lat'],
          };
          result.add(item);
          count--;
          if (count == 0) {
            break;
          }
        }
      }
    }
    return result;
  }

  BuildContext? popContext;
  final dynamic jsonResponse;
  final bool? darkTheme;

  MySearch({this.popContext, required this.jsonResponse, this.darkTheme});

  Map<String, dynamic> geo = {};

  @override
  ThemeData appBarTheme(BuildContext context) {
    // TODO: implement appBarTheme
    return ThemeData(
      textTheme: TextTheme(
          headline6: TextStyle(
              color: darkTheme == true ? Colors.white : Colors.black)),
      hintColor: darkTheme == true ? Colors.white : Colors.black,
      appBarTheme: AppBarTheme(
        color: darkTheme == true ? const Color(0xFF0B0C1E) : Colors.white,
      ),
    );
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      onPressed: () => close(context, null),
      icon: Icon(
        Icons.arrow_back,
        color: darkTheme == true ? Colors.white : Colors.black,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    var sug = searchItem(query);

    return Container(
      color: darkTheme == true ? const Color(0xFF0B0C1E) : Colors.white,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              // query = sug[index]['name'];
              geo['lat'] = double.parse(sug[index]['lat']);
              geo['lon'] = double.parse(sug[index]['lon']);
              geo['name'] = sug[index]['name'];
              geo['myLocation'] = false;
              // showResults(context);
              query = '';
              close(context, query);
              Navigator.pop(popContext!, geo);
            },
            title: Text(
              sug[index]['name'],
              style: TextStyle(
                  color: darkTheme == true ? Colors.white : Colors.black),
            ),
          );
        },
        itemCount: sug.length,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, query);
          } else {
            query = '';
            close(context, query);
            Navigator.pop(popContext!, geo);
          }
        },
        icon: Icon(
          query.isEmpty ? Icons.clear : Icons.search,
          color: darkTheme == true ? Colors.white : Colors.black,
        ),
      )
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    // throw UnimplementedError();
    return Container(
      color: darkTheme == true ? const Color(0xFF0B0C1E) : Colors.white,
    );
  }
}
