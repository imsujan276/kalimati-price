// import 'dart:convert';
// import "package:flutter/material.dart";
// import 'package:kalimati_price/models/product_model.dart';
// import "package:http/http.dart" as http;
// import 'package:intl/intl.dart';
// import 'package:rounded_modal/rounded_modal.dart';
// import 'package:flutter_native_admob/flutter_native_admob.dart';

// class HomePage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return _HomePageState();
//   }
// }

// class _HomePageState extends State<HomePage> {
//   static const bannerAdID ="ca-app-pub-9000154121468885/2510720646";
//   final nativeAdMob = NativeAdmob();

//   Product product;
//   List<Result> results;

//   var selectedDate;
//   bool isToday = true;
//   var date;

//   @override
//   void initState() {
//     super.initState();
//     nativeAdMob.initialize(
//       appID: "ca-app-pub-9000154121468885~7244024653"
//     );
//     setState(() {
//       date = DateFormat('yyyy-MM-dd').format(new DateTime.now());
//     });
//   }

//   _showDateTimePicker() async {
//     var selectedDate = await showDatePicker(
//       context: context,
//       initialDate: new DateTime.now(),
//       firstDate: new DateTime(2019),
//       lastDate: new DateTime(2022),
//     );
//     print(selectedDate);
//     if (selectedDate != null) {
//       var date = formatDate(selectedDate.toString());
//       print(date);
//       _fetchProductsByDate(date, date);
//       setState(() {
//         isToday = false;
//       });
//     }
//   }

//   Future<void> _fetchProducts() async {
//     var uri = "http://realtime-api.opendatanepal.com/kalimati-price/api/today";
//     var response = await http.get(uri);
//     var decRes = json.decode(response.body);
//     product = Product.fromJson(decRes);
//     results = product.result;
//   }

//   Future<void> _fetchProductsByDate(from, to) async {
//     setState(() {
//       date = from;
//     });
//     var uri =
//         "http://realtime-api.opendatanepal.com/kalimati-price/api/archive?date_range=" +
//             from +
//             "," +
//             to;
//     var response = await http.get(uri);
//     var decRes = json.decode(response.body);
//     product = Product.fromJson(decRes);
//     results = product.result;
//   }

//   formatDate(dateString) {
//     var parsedDate = DateTime.parse(dateString);
//     String date = DateFormat('yyyy-MM-dd').format(parsedDate);
//     return date.toString();
//   }

//   Future<void> _refreshProducts() async {
//     setState(() {
//       results = null;
//       product = null;
//       isToday = true;
//       selectedDate = null;
//       date = DateFormat('yyyy-MM-dd').format(new DateTime.now());
//     });
//     _fetchProducts();
//   }

//   _showBottomSheetModal(){
//     showRoundedModalBottomSheet(
//       context: context,
//       radius: 10.0, // This is the default
//       color: Colors.white, // Also default
//       builder: (context) => Container(
//         child: Container(
//           child: Padding(
//             padding: EdgeInsets.all(10.0),
//             child: Column(
//               children: <Widget>[
//                 Text('About App',
//                     style: TextStyle(
//                       fontSize: 20.0,
//                       fontWeight: FontWeight.w500,
//                     )
//                 ),

//                 SizedBox(height: 10.0,),

//                 Text('Kalimati Price is the app made to know the price of Kalimati ',
//                   style: TextStyle(
//                     fontSize: 16.0
//                   ),
//                 )
//               ],
//             ),
//           ),
//         )
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Kalimati Prices"),
//           elevation: 0.0,
//           actions: <Widget>[
//             new IconButton(
//               icon: new Icon(
//                 Icons.help,
//                 color: Colors.white,
//               ),
//               onPressed: () => {
//                   _showBottomSheetModal()
//                 })
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           child: Icon(Icons.refresh),
//           onPressed: _refreshProducts,
//           backgroundColor: Colors.lightBlueAccent,
//           foregroundColor: Colors.black,
//         ),
//         body: SafeArea(
//           child: Container(
//             child: Column(
//               children: <Widget>[
//                 SizedBox(
//                   height: 5.0,
//                 ),
//                 FittedBox(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       FilterChip(
//                         backgroundColor:
//                             isToday ? Colors.grey[500] : Colors.grey[100],
//                         label: Text('Today'),
//                         onSelected: (b) {
//                           setState(() {
//                             isToday = true;
//                           });
//                         },
//                       ),
//                       SizedBox(
//                         width: 5.0,
//                       ),
//                       FilterChip(
//                         backgroundColor:
//                             isToday ? Colors.grey[100] : Colors.grey[500],
//                         label: Text(
//                           'Filter By Date',
//                         ),
//                         onSelected: (b) {
//                           print(b);
//                           _showDateTimePicker();
//                         },
//                       )
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10.0,
//                 ),
//                 Container(
//                   color: Colors.grey[500],
//                   height: 25.0,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Text(date.toString())
//                     ],
//                   ),
//                 ),

//                 SizedBox(
//                   height: 10.0,
//                 ),
//                 Expanded(
//                   child: RefreshIndicator(
//                     onRefresh: _refreshProducts,
//                     child: FutureBuilder(
//                         future: _fetchProducts(),
//                         builder:
//                             (BuildContext context, AsyncSnapshot snapshot) {
//                           switch (snapshot.connectionState) {
//                             case ConnectionState.none:
//                               return Text('Pull to reload');
//                             case ConnectionState.active:
//                             case ConnectionState.waiting:
//                               return Center(
//                                 child: CircularProgressIndicator(),
//                               );
//                             case ConnectionState.done:
//                               if (snapshot.hasError)
//                                 return errorDataUI(snapshot);
//                               return productsList();
//                           }
//                           return null;
//                         }),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ));
//   }

//   Padding errorDataUI(AsyncSnapshot snapshot) {
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Text(
//             'Error: ${snapshot.error}',
//           ),
//           SizedBox(
//             height: 20.0,
//           ),
//           RaisedButton(
//             child: Text("Try Again"),
//             onPressed: () {
//               _fetchProducts();
//               setState(() {});
//             },
//           )
//         ],
//       ),
//     );
//   }

//   ListView productsList() {
//     return ListView.builder(
//       itemCount: results.length,
//       itemBuilder: (context, index) => Card(
//             color: Colors.white,
//             elevation: 0.0,
//             child: Container(
//               child: Column(
//                 children: <Widget>[
//                   (index > 0 && index%4 == 0)
//                   ?
//                       Column(
//                         children: <Widget>[
//                           NativeAdmobBannerView(
//                             adUnitID: bannerAdID,
//                             style: BannerStyle.light, // enum dark or light
//                             showMedia: true, // whether to show media view or not
//                             contentPadding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0), // content padding
//                           ),
//                           ExpansionTile(
//                             title: Padding(
//                               padding: const EdgeInsets.all(18.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                 children: <Widget>[
//                                   Text(
//                                     results[index].commodityName,
//                                     style: TextStyle(
//                                       fontSize: 18.0,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   SizedBox(height: 10.0),
//                                   Text(results[index].retailPrice.length > 0
//                                       ? "Retail Price: Rs." +
//                                       results[index].retailPrice[0].avg.toString()
//                                       : 'No Data'),
//                                 ],
//                               ),
//                             ),
//                             leading: CircleAvatar(
//                               backgroundColor: Colors.grey[100],
//                               child: Icon(Icons.show_chart),
//                             ),
//                             children: <Widget>[
//                               Padding(
//                                 padding: EdgeInsets.all(10.0),
//                                 child: Container(
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                     children: <Widget>[
//                                       buildHeader(results[index].retailPrice.length),
//                                       showPrice(results[index].retailPrice, 'No Retail Data',
//                                           'Retail'),
//                                       SizedBox(height: 10.0),
//                                       showPrice(results[index].wholesalePrice,
//                                           'No Wholesale Data', 'Wholesale')
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       )
//                   :
//                  ExpansionTile(
//         title: Padding(
//           padding: const EdgeInsets.all(18.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               Text(
//                 results[index].commodityName,
//                 style: TextStyle(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               SizedBox(height: 10.0),
//               Text(results[index].retailPrice.length > 0
//                   ? "Retail Price: Rs." +
//                   results[index].retailPrice[0].avg.toString()
//                   : 'No Data'),
//             ],
//           ),
//         ),
//         leading: CircleAvatar(
//           backgroundColor: Colors.grey[100],
//           child: Icon(Icons.show_chart),
//         ),
//         children: <Widget>[
//           Padding(
//             padding: EdgeInsets.all(10.0),
//             child: Container(
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   buildHeader(results[index].retailPrice.length),
//                   showPrice(results[index].retailPrice, 'No Retail Data',
//                       'Retail'),
//                   SizedBox(height: 10.0),
//                   showPrice(results[index].wholesalePrice,
//                       'No Wholesale Data', 'Wholesale')
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//                 ],
//               ),
//             )

//           ),
//     );
//   }

//   buildHeader(hasData) {
//     if (hasData == 0) {
//       return Container();
//     }
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: <Widget>[
//         Text(
//           "",
//           style: TextStyle(
//             fontSize: 16.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 10.0),
//         Text(
//           'Max Rate',
//           style: TextStyle(
//             fontSize: 16.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 10.0),
//         Text(
//           'Avg Rate',
//           style: TextStyle(
//             fontSize: 16.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 10.0),
//         Text(
//           'Min Rate',
//           style: TextStyle(
//             fontSize: 16.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 10.0),
//         Text(
//           'Date',
//           style: TextStyle(
//             fontSize: 16.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }

//   showPrice(data, emptyMsg, type) {
//     if (data.length == 0) {
//       return Center(
//         child: Text(emptyMsg),
//       );
//     }
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: <Widget>[
//         Text(
//           type + " Rate",
//           style: TextStyle(
//             fontSize: 16.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         SizedBox(height: 10.0),
//         Text(
//           "Rs." + data[0].max.toString() + "/" + data[0].unit,
//           style: TextStyle(
//             fontSize: 16.0,
//           ),
//         ),
//         SizedBox(height: 10.0),
//         Text(
//           "Rs." + data[0].avg.toString() + "/" + data[0].unit,
//           style: TextStyle(
//             fontSize: 16.0,
//           ),
//         ),
//         SizedBox(height: 10.0),
//         Text(
//           "Rs." + data[0].min.toString() + "/" + data[0].unit,
//           style: TextStyle(
//             fontSize: 16.0,
//           ),
//         ),
//         SizedBox(height: 10.0),
//         Text(
//           formatDate(data[0].date),
//           style: TextStyle(
//             fontSize: 16.0,
//           ),
//         ),
//       ],
//     );
//   }
// }
