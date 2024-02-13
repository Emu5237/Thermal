import 'dart:math';

import 'package:flutter/material.dart';

class HomePage1 extends StatelessWidget {
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

// String getFormattedString(String input) {
//   const int maxLineLength = 18;

//   List<String> words = input.split(' ');

//   List<String> lines = [];
//   List<String> filteredList = [];
//   String currentLine = '';

//   for (String word in words) {
//     if ((currentLine.isEmpty ? 0 : currentLine.length + 1) + word.length <=
//         maxLineLength) {
//       currentLine += (currentLine.isEmpty ? '' : ' ') + word;
//     } else {
//       lines.add(currentLine);
//       currentLine = word;
//     }
//   }

//   if (currentLine.isNotEmpty) {
//     lines.add(currentLine);
//     filteredList = lines.where((element) => element.isNotEmpty).toList();
//   }

//   return filteredList.join('\n');
// }

// void getFormattedString1() {
//   print(getFormattedString(
//       'Lorem ipsumMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor'));
// }

List<String> splitString(String input) {
  List<String> result = [];
  List<String> words = input.split(' ');

  for (String word in words) {
    if (word.length <= 18) {
      result.add(word);
    } else {
      int start = 0;
      while (start < word.length) {
        int end = start + 18;
        if (end > word.length) {
          end = word.length;
        }
        result.add(word.substring(start, end));
        start = end;
      }
    }
  }

  return result;
}

String getFormattedString(String input) {
  Map<String, dynamic> data1 = {
    'Date': '21 jan 2024 January February December, 2023',
    'Txn No': '123456789012333333',
    'Txn Type': 'Lorem ipsum dolor sit amet, tempor lorem ipsummm no limit',
    'A/C No': '888888 9999999 200000 30000',
    'A/C Title': 'abc defgh ijktlon erdsaf',
    'Amount': 90000000,
    'Status': 'success failure jani na vai onk kichu',
  };
  int count = 0;
  print('{');
  data1.forEach((key, value) {
    if (count < data1.length) {
      print("  '$key': '$value',");
      count++;
    }
  });
  const int maxLineLength = 18;
  print(input);
  List<String> words = splitString(input);
  List<String> lines = [];
  List<String> filteredList = [];
  String currentLine = '';

  for (String word in words) {
    if ((currentLine.isEmpty ? 0 : currentLine.length + 1) + word.length <=
        maxLineLength) {
      currentLine += (currentLine.isEmpty ? '' : ' ') + word;
    } else {
      lines.add(currentLine);
      currentLine = word;
    }
  }

  if (currentLine.isNotEmpty) {
    lines.add(currentLine);
    filteredList = lines.where((element) => element.isNotEmpty).toList();
  }

  return filteredList.join('\n');
}

void getFormattedString1() {
  print(getFormattedString(
      'Lorem ipsum dolor sit ametaconsecteturadipiscing elit, sed do eiusmod tempor'));
}

// Lorem ipsummmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor

// // I want this string to print 18 characters in every new line only if the last character is empty string ' ' and if not I want you to consider till the last ' ' and it does not have to be 18 characters in the case and then also print the following word in the next line and the continue the process till the end

// // for example :
// Lorem ipsummmmmmmm
// mmmmmmmmmmmmmmmmmm
// mmmmmmmmmmmmmmmmmm
// mmmmmmmmmm dolor 
// sit amet, 
// consectetur
// adipiscing elit, 
// sed do eiusmod
// tempor

// write this function in dart 