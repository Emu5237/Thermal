// import 'package:flutter/material.dart';

// class HomePage extends StatelessWidget {
//   final List<Map<String, dynamic>> data = [
//     {'title': 'Date :'},
//     {'title': 'Txn No :'},
//     {'title': 'Txn Type :'},
//     {'title': 'A/C No :'},
//     {'title': 'A/C Title :'},
//     {'title': 'Amount :'},
//     {'title': 'Status :'},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('BRAC Bank PLC'),
//         backgroundColor: Colors.blue[700],
//       ),
//       body: Column(
//         children: [
//           Text('BRAC BANK PLC'),
//           Text('*****************************'),
//           Text('Duplicate copy'),
//           Text('Agent Banking Outlet'),
//           Container(
//             height: MediaQuery.of(context).size.height / 2.7,
//             child: Expanded(
//               flex: 1,
//               child: ListView.builder(
//                 padding: EdgeInsets.fromLTRB(50, 20, 50, 0),
//                 itemCount: data.length,
//                 itemBuilder: (c, i) {
//                   return ListTile(
//                     dense: true,
//                     visualDensity: VisualDensity(horizontal: 0, vertical: -4),
//                     title: Text(
//                       data[i]['title'].toString(),
//                       style: TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.normal,
//                           fontFamily: "Georgia"),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//           Column(
//             children: [
//               Text('*****************************'),
//               Text('Customer Copy'),
//               Text('Thank You | Agent Banking'),
//               Text('Powered by mFino'),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
