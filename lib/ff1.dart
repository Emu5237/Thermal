import 'dart:math';

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BRAC Bank PLC'),
        backgroundColor: Colors.blue[700],
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              getFormattedString1();
              // (e.advertisementData.connectable) ? widget.onTap : null;
            },
            child: Text("press"),
          ),
        ],
      ),
    );
  }
}

//   String s1 =
//       'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor';

//   //String s2 = 'BRAC BANK PLC';
//   int lastSpace = s1.lastIndexOf(" ");

//   var trimmed = (s1.length < 10) ? s1 : s1.substring(0, min(s1.length, 10));
//   var trimmed1 = s1.substring(10, min(s1.length, 80));

//   // String resultText = (s2.length < 30) ? s2 : s2.substring(0, 30);
//   // print(resultText);
//   // if (s1.length > 20) {
//   //   var trimmed2 = s1.substring(21, firstSpace);
//   //   print(trimmed2);
//   // }

//   // var trimmed2 = s1.length > 20 ? s1.substring(20, s1.lastIndexOf(' ')) : s1;
//   // print(trimmed2);

//   // if (s1.length > 20) {
//   //   var v = s1.trim();
//   //   print(v);
//   // }
//   // var text =  ';
//   // print(
//   //   text.length > 12 ? text.substring(0, 12) : text,
//   // );

//   // print(s1.substring(20, firstSpace));
//   print(trimmed);
//   print(trimmed1);
//   var total = trimmed + trimmed1;
//   var total1 = total + "\n" + s1.substring(lastSpace);

//   // print(total);
//   print(total1);
//   // var total = trimmed + trimmed1;
//   //print(total);

//   // trimmed = s2.substring(0, min(s2.length, 10));
//   // print(trimmed);
// }

// // void printWithDevice() async {
// //   Map<String, dynamic> data1 = {
// //     // 'Date': '21 jan 2024',
// //     // 'Txn No': '1234567890123333336666',
// //     // 'Txn Type': 'Deposit',
// //     // 'A/C No': '888888',
// //     'A/C Title': 'BRAC BANK PLC',
// //     // 'Amount': 900,
// //     'Status': 'success success success success ',
// //   };

// //   data1.forEach((key, value) {
// //      int firstSpace = value.indexOf(" ");
// //     String resultText = (value.length < 10) ? value : value.substring(0, 10);

// //     String firstName = value.substring(0, resultText);

// //     //String middle = value.substring(firstSpace);
// //     String lastname = value.substring(resultText).trim();

// //     int CharacterRange = 18;
// //     var newString = value.substring((value.length - 5).clamp(0, value.length));
// //     if (CharacterRange < 19) {
// //       String Name = firstName + lastname;
// //       print(Name);
// //     } else {
// //       String Name1 = firstName + "\n" + lastname.trim();
// //       print(Name1);
// //     }
// //   });
// // }

// Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor
// Lorem ipsum dolor
// sit amet,
// consectetur
// adipiscing elit,
// sed do eiusmod
// tempor
String getFormattedString(String input) {
  const int maxLineLength = 18;

  List<String> words = input.split(' ');
  print('words => $words');

  List<String> lines = [];
  List<String> filteredList = [];
  String currentLine = '';

  for (String word in words) {
    print('currentLine => $currentLine');
    print('word => $word');

    if ((currentLine.isEmpty ? 0 : currentLine.length + 1) + word.length <=
        maxLineLength) {
      currentLine += (currentLine.isEmpty ? '' : ' ') + word;
      print('inside if => $currentLine');
    } else {
      lines.add(currentLine);
      print('lines => $lines');
      currentLine = word;
      print('inside else => $currentLine');
    }
  }

  if (currentLine.isNotEmpty) {
    lines.add(currentLine);
    filteredList = lines.where((element) => element.isNotEmpty).toList();
  }

  return filteredList.join('\n');
}

void getFormattedString1() {
  Map<String, dynamic> data1 = {
    'Date': '21 jan 2024',
    'Txn No': '1234567890123333336666',
    'Txn Type':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor',
    'A/C No': '888888',
    'A/C Title': 'abc',
    'Amount': 900,
    'Status': 'success',
  };

  data1.forEach(
    (key, value) {
      // print('$key : ${getFormattedString(value)}');
    },
  );

  getFormattedString(
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor');
}
