// import 'dart:async';
// import 'dart:io';

// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:thermal1/blue_print.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:thermal1/device_screen.dart';
// import 'package:thermal1/footer.dart';
// import 'package:thermal1/header.dart';
// //import 'package:thermal1/ff1.dart';
// import 'package:thermal1/utils/extra.dart';
// import 'package:thermal1/utils/snackbar.dart';

// class ScanScreen10 extends StatefulWidget {
//   const ScanScreen10({Key? key}) : super(key: key);

//   @override
//   State<ScanScreen10> createState() => _ScanScreen10State();
// }

// class _ScanScreen10State extends State<ScanScreen10> {
//   List<BluetoothDevice> _systemDevices = [];
//   List<ScanResult> _scanResults = [];
//   bool _isScanning = false;
//   late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
//   late StreamSubscription<bool> _isScanningSubscription;

//   @override
//   void initState() {
//     super.initState();

//     _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
//       _scanResults = results;
//       if (mounted) {
//         setState(() {
//           _scanResults = results;
//         });
//       }
//     }, onError: (e) {
//       Snackbar.show(ABC.b, prettyException("Scan Error:", e), success: false);
//     });

//     _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
//       _isScanning = state;
//       if (mounted) {
//         setState(() {});
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _scanResultsSubscription.cancel();
//     _isScanningSubscription.cancel();
//     super.dispose();
//   }

//   Future onScanPressed() async {
//     try {
//       _systemDevices = await FlutterBluePlus.systemDevices;
//     } catch (e) {
//       Snackbar.show(ABC.b, prettyException("System Devices Error:", e),
//           success: false);
//     }
//     try {
//       // android is slow when asking for all advertisements,
//       // so instead we only ask for 1/8 of them
//       int divisor = Platform.isAndroid ? 8 : 1;
//       await FlutterBluePlus.startScan(
//           timeout: const Duration(seconds: 15),
//           continuousUpdates: true,
//           continuousDivisor: divisor);
//     } catch (e) {
//       Snackbar.show(ABC.b, prettyException("Start Scan Error:", e),
//           success: false);
//     }
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   Future onStopPressed() async {
//     try {
//       FlutterBluePlus.stopScan();
//     } catch (e) {
//       Snackbar.show(ABC.b, prettyException("Stop Scan Error:", e),
//           success: false);
//     }
//   }

//   void onConnectPressed(BluetoothDevice device) {
//     device.connectAndUpdateStream().catchError((e) {
//       Snackbar.show(ABC.c, prettyException("Connect Error:", e),
//           success: false);
//     });
//     MaterialPageRoute route = MaterialPageRoute(
//         builder: (context) => DeviceScreen(device: device),
//         settings: RouteSettings(name: '/DeviceScreen'));
//     Navigator.of(context).push(route);
//   }

//   Future onRefresh() {
//     if (_isScanning == false) {
//       FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
//     }
//     if (mounted) {
//       setState(() {});
//     }
//     return Future.delayed(Duration(milliseconds: 500));
//   }

//   Widget buildScanButton(BuildContext context) {
//     if (FlutterBluePlus.isScanningNow) {
//       return FloatingActionButton(
//         child: const Icon(Icons.stop),
//         onPressed: onStopPressed,
//         backgroundColor: Colors.red,
//       );
//     } else {
//       return FloatingActionButton(
//           child: const Text("SCAN"), onPressed: onScanPressed);
//     }
//   }

//   Iterable<Container> scanTiles(BuildContext context) {
//     return _scanResults.map(
//       (e) {
//         return Container(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   printWithDevice(e.device);
//                   // (e.advertisementData.connectable) ? widget.onTap : null;
//                 },
//                 child: Container(
//                   decoration:
//                       BoxDecoration(borderRadius: BorderRadius.circular(10)),
//                   child: Column(
//                     children: [
//                       Text(e.device.platformName),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Text(e.device.remoteId.str),
//                     ],
//                   ),
//                 ),
//               ),
//               Divider(),
//               // ElevatedButton(
//               //     child: const Text('Open route'),
//               //     onPressed: () {
//               //       Navigator.push(context,
//               //           MaterialPageRoute(builder: (context) => HomePage()));
//               //     }),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ScaffoldMessenger(
//       key: Snackbar.snackBarKeyB,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Find Devices'),
//         ),
//         body: RefreshIndicator(
//           onRefresh: onRefresh,
//           child: ListView(
//             children: <Widget>[
//               ...scanTiles(context),
//             ],
//           ),
//         ),
//         floatingActionButton: buildScanButton(context),
//       ),
//     );
//   }
// }

// List<String> splitString(String input, int maxLineLength) {
//   List<String> result = [];
//   List<String> words = input.split(' ');

//   for (String word in words) {
//     if (word.length <= maxLineLength) {
//       result.add(word);
//     } else {
//       int start = 0;
//       while (start < word.length) {
//         int end = start + maxLineLength;
//         if (end > word.length) {
//           end = word.length;
//         }
//         result.add(word.substring(start, end));
//         start = end;
//       }
//     }
//   }

//   return result;
// }

// String getFormattedString(String input, int maxLineLength) {
//   // const int maxLineLength = maxLineLength;
//   print(input);
//   List<String> words = splitString(input, maxLineLength);
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

// int findLengthOfLargerArray(List<dynamic> array1, List<dynamic> array2) {
//   if (array1.length > array2.length) {
//     return array1.length;
//   } else {
//     return array2.length;
//   }
// }

// void printWithDevice(BluetoothDevice device) async {
//   await device.connect();
//   final gen = Generator(PaperSize.mm58, await CapabilityProfile.load());
//   final printer = BluePrint();
//   //await printHeader(gen, printer);
//   // await printHeader1(gen, printer);
// //Array data with one single data
//   Map<String, dynamic> singleData = {
//     'A/C No': 1056267460001,
//     'A/C title': '123456789012333333',
//     'Available Balance': '224,358.56',
//     'Date': '21 jan 2024',
//   };

//   singleData.forEach((key, value) {
//     List<String> formattedKeyLines =
//         getFormattedString(key.toString(), 11).split('\n');
//     List<String> formattedLines =
//         getFormattedString(':$value'.toString(), 17).split('\n');
//     printer.add(gen.row([
//       // PosColumn(
//       //   text: '',
//       //   width: 1,
//       // ),
//       PosColumn(
//         text: formattedKeyLines[0],
//         width: 5,
//       ),
//       PosColumn(
//         text: formattedLines[0],
//         width: 9,
//       ),
//     ]));

//     int count = 1;

//     for (int i = 1;
//         i < findLengthOfLargerArray(formattedLines, formattedKeyLines);
//         i++) {
//       printer.add(gen.row([
//         // PosColumn(
//         //   text: '',
//         //   width: 1,
//         // ),
//         PosColumn(
//           text: formattedKeyLines.length > count ? formattedKeyLines[i] : '',
//           width: 5,
//         ),
//         PosColumn(
//           text: ' ${formattedLines.length > count ? formattedLines[i] : ''}',
//           width: 9,
//         ),
//       ]));

//       count++;
//     }
//   });

//   printer.add(gen.text('==============================',
//       styles: const PosStyles(align: PosAlign.center)));

//   List<Map<String, dynamic>> dataArray = [
//     {
//       'Trn Date': '07 Feb 2024',
//       'Trn Amount': 'BDT 50,000.00',
//       'Particulars': 'AGB/FIFR/101505/TTTTT TTTT AAAA MMMM',
//       'Type': 'DEBIT',
//     },
//     // {
//     //   'Trn Date': '07 Feb 2024',
//     //   'Trn Amount': 'BDT 50,000.00',
//     //   'Particulars': 'AGB/FIFR/101505/TTTTT TTTT AAAA MMMM',
//     //   'Type': 'DEBIT',
//     // },
//     // {
//     //   'Trn Date': '07 Feb 2024',
//     //   'Trn Amount': 'BDT 50,000.00',
//     //   'Particulars': 'DPS Installment to 3056267460001',
//     //   'Type': 'DEBIT',
//     // },
//     // {
//     //   'Trn Date': '07 Feb 2024',
//     //   'Trn Amount': 'BDT 50,000.00',
//     //   'Particulars': 'DPS Installment to 3056267460001',
//     //   'Type': 'CREDIT',
//     // },
//     // {
//     //   'Trn Date': '07 Feb 2024',
//     //   'Trn Amount': 'BDT 50,000.00',
//     //   'Particulars': 'EFT/IC/AB-BANK/INDINC/FRINC',
//     //   'Type': 'DEBIT',
//     // },
//     // {
//     //   'Trn Date': '07 Feb 2024',
//     //   'Trn Amount': 'BDT 50,000.00',
//     //   'Particulars': 'AGB/CDWD/101505/TTTTT TTTT AAAA MMMM',
//     //   'Type': 'DEBIT',
//     // },
//     // {
//     //   'Trn Date': '07 Feb 2024',
//     //   'Trn Amount': 'BDT 50,000.00',
//     //   'Particulars': 'AGB/FIFR/101505/TTTTT TTTT AAAA MMMM',
//     //   'Type': 'DEBIT',
//     // },
//     // {
//     //   'Trn Date': '07 Feb 2024',
//     //   'Trn Amount': 'BDT 50,000.00',
//     //   'Particulars': 'AGB/FIFR/101505/TTTTT TTTT AAAA MMMM',
//     //   'Type': 'DEBIT',
//     // },
//     // {
//     //   'Trn Date': '07 Feb 2024',
//     //   'Trn Amount': 'BDT 50,000.00',
//     //   'Particulars': 'AGB/FIFR/101505/TTTTT TTTT AAAA MMMM',
//     //   'Type': 'DEBIT',
//     // },
//     // {
//     //   'Trn Date': '07 Feb 2024',
//     //   'Trn Amount': 'BDT 50,000.00',
//     //   'Particulars': 'AGB/FIFR/101505/TTTTT TTTT AAAA MMMM',
//     //   'Type': 'DEBIT',
//     // },
//   ];

//   dataArray.asMap().forEach((index, data) {
//     data.forEach((key, value) {
//       List<String> formattedKeyLines =
//           getFormattedString(key.toString(), 11).split('\n');
//       List<String> formattedLines =
//           getFormattedString(':$value'.toString(), 17).split('\n');
//       printer.add(gen.row([
//         // PosColumn(
//         //   text: '',
//         //   width: 1,
//         // ),
//         PosColumn(
//           text: formattedKeyLines[0],
//           width: 5,
//         ),
//         PosColumn(
//           text: formattedLines[0],
//           width: 9,
//         ),
//       ]));

//       int count = 1;

//       for (int i = 1;
//           i < findLengthOfLargerArray(formattedLines, formattedKeyLines);
//           i++) {
//         printer.add(gen.row([
//           // PosColumn(
//           //   text: '',
//           //   width: 1,
//           // ),
//           PosColumn(
//             text: formattedKeyLines.length > count ? formattedKeyLines[i] : '',
//             width: 5,
//           ),
//           PosColumn(
//             text: ' ${formattedLines.length > count ? formattedLines[i] : ''}',
//             width: 9,
//           ),
//         ]));

//         count++;
//       }
//     });

//     // printer.add(gen.text('==============================',
//     //     styles: const PosStyles(align: PosAlign.center)));
//   });

// // SINGLE
// // Map<String, dynamic> cashDeposit = {
// //     'Date': '07 Feb 2024 15:06',
// //     'Txn No.': '272036344067',
// //     'Txn Type': 'Cash Deposit',
// //     'A/C No.': '2056025810001',
// //     'A/C Title': '01882135394',
// //     'Amount': 'BDT 363,000.00',
// //     'Status': 'Success'
// //   };
// //   Map<String, dynamic> cashWithdrawal = {
// //     'Date': '07 Feb 2024 14:54',
// //     'Txn No.': '282051828371',
// //     'Txn Type': 'Cash Withdrawal',
// //     'A/C No.': '8888104367964001',
// //     'A/C Title': 'Taslima Yeasmin Emu',
// //     'Amount': 'BDT 300,000.00',
// //     'Status': 'Success'
// //   };
// //   Map<String, dynamic> loanInstallment = {
// //     'Date': '07 Feb 2024 14:44',
// //     'Txn No.': '01882135394',
// //     'Txn Type': 'Loan Installment',
// //     'Operating A/C': '8888104367964001',
// //     'Loan A/C No.': '6048230990003',
// //     'Loan A/C Title': 'ABCCCCCCCC Enterprise',
// //     'Amount': 'BDT 54,500.00',
// //     'Status': 'Success'
// //   };
// //   Map<String, dynamic> loanDisbursement = {
// //     'Date': '07 Feb 2024 12:42',
// //     'Txn No.': 353260786264,
// //     'Txn Type': 'Loan Disbursement',
// //     'Operating A/C': '1056267460001',
// //     'Loan A/C Title': 'ABCCCCCCCC Enterprise',
// //     'Withdrawal Amt.': 'BDT 300,000.00',
// //     'Status': 'Success'
// //   };
// //   Map<String, dynamic> creditCard = {
// //     'Date': '05 Feb 2024 17:20',
// //     'Txn No.': 461661436801,
// //     'Txn Type': 'Credit Card',
// //     'Card No.': '5488********1620',
// //     'Card Holder': 'undefined',
// //     'Distributor Code': 'F50',
// //     'Amount': 'BDT 45,000.00',
// //     'Status': 'Success'
// //   };
// //   Map<String, dynamic> Remittance = {
// //     'Date': '05 Feb 2024 17:20',
// //     'Txn No.': 215534971935,
// //     'Txn Type': 'F.Remittance',
// //     'Exchange House': 'Trans-Fast',
// //     'Sender Name': 'Taaaaaaaaasss Yassssssssss Emi',
// //     'Ben. Name': 'Emiiiiiiiii',
// //     'Ben Mobile': '01823552642',
// //     'Amount': 'BDT 20,670.40',
// //     'Status': 'Success'
// //   };
// //   Map<String, dynamic> branchCashDeposit = {
// //     'Date': '05 Feb 2024 11:20',
// //     'Txn No.': 924162052876,
// //     'Txn Type': 'Cash Deposit',
// //     'A/C No.': 1505203218138001,
// //     'A/C Title': 'Tasssssssssssss Emiiiiiiiiiiiii',
// //     'Amount': 'BDT 5,670.00',
// //     'Agent Fee': 'BDT 10.00',
// //     'Total Amount': 'BDT 5,670.00',
// //     'Status': 'Success'
// //   };
//   // Map<String, dynamic> data1 = {
//   //   'Date no very much threeee': '21 jan 2024 January February December, 2023',
//   //   'Txn No jani na kichui vai': '123456789012333333',
//   //   'A/C No onk boro length er data': '888888 9999999 200000 30000',
//   //   'A/C Title no title only numbers': 'abc defgh ijktlon erdsaf',
//   //   'Txn Type':
//   //       'Loremmmmmm ipsum dolor sit amet, tempor lorem ipsummm no limit',
//   //   'Amount': 90000000,
//   //   'StatussssssssssssssssssssssssPPPPPPPPRRRRRRwwwwwwwwww':
//   //       'success failure jani na vai onk kichu',
//   //   'A/C Noo': '888888 9999999 200000 30000',
//   //   'A/C Titlee': 'abc defgh ijktlon erdsaf',
//   // };

//   // data1.forEach((key, value) {
//   //   List<String> formattedKeyLines =
//   //       getFormattedString(key.toString(), 10).split('\n');
//   //   List<String> formattedLines =
//   //       getFormattedString(':$value'.toString(), 18).split('\n');
//   //   printer.add(gen.row([
//   //     PosColumn(
//   //       text: formattedKeyLines[0],
//   //       width: 4,
//   //     ),
//   //     PosColumn(
//   //       text: formattedLines[0],
//   //       width: 8,
//   //     ),
//   //   ]));

//   //   print(
//   //       'key array ${formattedKeyLines.length > 100 ? formattedKeyLines[100] : ''}');

//   //   int count = 1;

//   //   for (int i = 1;
//   //       i < findLengthOfLargerArray(formattedLines, formattedKeyLines);
//   //       i++) {
//   //     printer.add(gen.row([
//   //       PosColumn(
//   //         text: formattedKeyLines.length > count ? formattedKeyLines[i] : '',
//   //         width: 4,
//   //       ),
//   //       PosColumn(
//   //         text: ' ${formattedLines.length > count ? formattedLines[i] : ''}',
//   //         width: 8,
//   //       ),
//   //     ]));

//   //     count++;
//   //   }
//   // });
//   // await printfooter1(gen, printer);
//   // await printfooter(gen, printer);
//   printer.add(gen.feed(1));
//   await printer.printData(device);
//   device.disconnect();
// }
