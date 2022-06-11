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

  MySearch({this.popContext,required this.jsonResponse});

  Map<String, dynamic> geo = {};

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.black,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    var sug = searchItem(query);

    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            query = sug[index]['name'];
            geo['lat'] = double.parse(sug[index]['lat']);
            geo['lon'] = double.parse(sug[index]['lon']);
            geo['name'] = sug[index]['name'];
            showResults(context);
          },
          title: Text(sug[index]['name']),
        );
      },
      itemCount: sug.length,
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
        icon:
            query.isEmpty ? const Icon(Icons.clear) : const Icon(Icons.search),
      )
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    // throw UnimplementedError();
    return Container();
  }
}
