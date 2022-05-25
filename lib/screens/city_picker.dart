// import 'package:flutter/material.dart';
// import 'package:flutter_typeahead/flutter_typeahead.dart';
//
// class CityPicker extends StatefulWidget {
//   const CityPicker({Key? key}) : super(key: key);
//
//   @override
//   State<CityPicker> createState() => _CityPickerState();
// }
//
// class _CityPickerState extends State<CityPicker> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: TypeAheadField(
//           textFieldConfiguration: TextFieldConfiguration(
//               autofocus: true,
//               style: DefaultTextStyle.of(context)
//                   .style
//                   .copyWith(fontStyle: FontStyle.italic),
//               decoration: InputDecoration(border: OutlineInputBorder())),
//           suggestionsCallback: (pattern) async {
//             return await BackendService.getSuggestions(pattern);
//           },
//           itemBuilder: (context, suggestion) {
//             return ListTile(
//               leading: Icon(Icons.shopping_cart),
//               title: Text(suggestion['name']),
//               subtitle: Text('\$${suggestion['price']}'),
//             );
//           },
//           onSuggestionSelected: (suggestion) {
//             Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) => ProductPage(product: suggestion)));
//           },
//         ),
//       ),
//     );
//   }
// }
