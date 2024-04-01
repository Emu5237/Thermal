// import 'dart:async';
// import 'dart:ui' as ui;
// import 'dart:io';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:image/image.dart';
// import 'package:image/image.dart' as img;
// import 'package:thermal1/blue_print.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:thermal1/device_screen.dart';
// import 'package:thermal1/utils/extra.dart';
// import 'package:thermal1/utils/snackbar.dart';

// class thermalprinter20 extends StatefulWidget {
//   const thermalprinter20({Key? key}) : super(key: key);

//   @override
//   State<thermalprinter20> createState() => _thermalprinter20State();
// }

// class _thermalprinter20State extends State<thermalprinter20> {
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

// void printWithDevice(BluetoothDevice device) async {
//   await device.connect();
//   final gen = Generator(PaperSize.mm58, await CapabilityProfile.load());
//   final printer = BluePrint();
//   final ByteData data = await rootBundle.load('assets/ab3.png');
//   final Uint8List bytes = data.buffer.asUint8List();
//   final image22 = decodeImage(bytes);
//   printer.add(gen.imageRaster(image22!));
//   printer.add(gen.text('\n'));

//   ///header example one///
//   await printSingleText(
//       'ব্র্যাক ব্যাংক পিএলসি\n===========================\n(ডুপ্লিকেট কপি)\nবারোইয়ারহাট এজেন্ট ব্যাংকিং আউটলেট',
//       printer,
//       gen);
//   printer.add(gen.text('\n'));

//   ///single print///
//   //1
//   final cashDepositInEnglish = [
//     {
//       'Date': '07 Feb 2024 15:06',
//       'Txn No.': '888810436796400122222',
//       'Txn Type': 'Cash Deposit',
//       'A/C No.': '2056025810001',
//       'A/C Title': '01882135394',
//       'Amount': 'BDT 363,000.00',
//       'Status': 'Success'
//     }
//   ];
//   final cashDeposit = [
//     {
//       'তারিখ': '২১ জানুয়ারি ২০২৪',
//       'লেনদেন নম্বর': '২৭২০৩৬৩৪৪০৬৭',
//       'লেনদেন প্রকার': 'নগদ আমানত',
//       'একাউন্ট নাম্বার': '২০৫৬০২৫৮১০০০১',
//       'একাউন্ট শিরোনাম': '০১৮৮২১৩৫৩৯৪',
//       'পরিমান': '৩৬৬,০০০.০০০ টাকা',
//       'অবস্থা': 'সফল'
//     }
//   ];
//   final cashWithdrawal = [
//     {
//       'তারিখ': '২১ জানুয়ারি ২০২৪',
//       'লেনদেন নম্বর': '২৭২০৩৬৩৪৪০৬৭',
//       'লেনদেন প্রকার': 'নগদ উত্তোলন',
//       'একাউন্ট নাম্বার': '২০৫৬০২৫৮১০০০১',
//       'একাউন্ট শিরোনাম': '০১৮৮২১৩৫৩৯৪',
//       'পরিমান': '৩৬৬,০০০.০০০ টাকা',
//       'অবস্থা': 'সফল'
//     }
//   ];
//   final loanInstallment = [
//     {
//       'তারিখ': '২১ জানুয়ারি ২০২৪',
//       'লেনদেন নম্বর': '২৭২০৩৬৩৪৪০৬৭',
//       'লেনদেন প্রকার': 'লোনের কিস্তি',
//       'পরিচালিত একাউন্ট': '৮৮৮৮২০৪৮২৩০৯৯০০১',
//       'লোন একাউন্ট নাম্বার': '৬০৪৮২৩০৯৯০০০৩',
//       'লোন একাউন্ট শিরোনাম': 'শামছুদ্দিন ইন্টারপ্রাইস',
//       'পরিমান': '৫৪,৫০০.০০ টাকা',
//       'অবস্থা': 'সফল'
//     }
//   ];
//   final loanDisbursement = [
//     {
//       'তারিখ': '২১ জানুয়ারি ২০২৪',
//       'লেনদেন নম্বর': '২৭২০৩৬৩৪৪০৬৭',
//       'লেনদেন প্রকার': 'লোন বিতরণ',
//       'পরিচালিত একাউন্ট': '৮৮৮৮২০৪৮২৩০৯৯০০১',
//       'লোন একাউন্ট শিরোনাম': 'শামছুদ্দিন ইন্টারপ্রাইস',
//       'উত্তোলনের পরিমান': '৫৪,৫০০.০০ টাকা',
//       'অবস্থা': 'সফল'
//     }
//   ];
//   final distributorBill = [
//     {
//       'তারিখ': '২১ জানুয়ারি ২০২৪',
//       'লেনদেন নম্বর': '২৭২০৩৬৩৪৪০৬৭',
//       'লেনদেন প্রকার': 'বিতরণ বিল',
//       'প্রতিষ্ঠানের নাম': 'রেনাতা ফেনী',
//       'পরিবেশক কোড': 'ফ৫০',
//       'পরিমান': '৫৪,৫০০.০০ টাকা',
//       'অবস্থা': 'সফল'
//     }
//   ];
//   final creditCard = [
//     {
//       'তারিখ': '২১ জানুয়ারি ২০২৪',
//       'লেনদেন নম্বর': '২৭২০৩৬৩৪৪০৬৭',
//       'লেনদেন প্রকার': 'ক্রেডিট কার্ড',
//       'কার্ড নম্বর': '৫৪৮৮********১৬২০',
//       'কার্ড ধারক': 'অনির্ধারিত',
//       'পরিমান': '৫৪,৫০০.০০ টাকা',
//       'অবস্থা': 'সফল'
//     }
//   ];
//   final remittance = [
//     {
//       'তারিখ': '২১ জানুয়ারি ২০২৪',
//       'লেনদেন নম্বর': '২৭২০৩৬৩৪৪০৬৭',
//       'লেনদেন প্রকার': 'বৈদেশিক রেমিট্যান্স',
//       'বিনিময় ঘর': '৫৪৮৮********১৬২০',
//       'প্রেরকের নাম': 'শামছুদ্দিন',
//       'বেনিফিশিয়ারি নাম': 'শামছুদ্দিন',
//       'বেনিফিশিয়ারি মোবাইল নাম্বার': '০১৮৮২১৩৫৩৯৪',
//       'পরিমান': '৫৪,৫০০.০০ টাকা',
//       'অবস্থা': 'সফল'
//     }
//   ];
//   final branchCustomer = [
//     {
//       'তারিখ': '২১ জানুয়ারি ২০২৪',
//       'লেনদেন নম্বর': '২৭২০৩৬৩৪৪০৬৭',
//       'লেনদেন প্রকার': 'বৈদেশিক রেমিট্যান্স',
//       'একাউন্ট নাম্বার': '২০৫৬০২৫৮১০০০১',
//       'একাউন্ট শিরোনাম': '০১৮৮২১৩৫৩৯৪',
//       'পরিমান': '৫৪,৫০০.০০ টাকা',
//       'এজেন্ট ফি': '৫,৪৫০.০০ টাকা',
//       'মোট পরিমান': '৫৪,৫০০.০০ টাকা',
//       'অবস্থা': 'সফল'
//     }
//   ];
//   // await printDualText(cashDeposit, printer, gen, false);
//   // await printDualText(cashWithdrawal, printer, gen, false);
//   // await printDualText(loanInstallment, printer, gen, false);
//   // await printDualText(loanDisbursement, printer, gen, false);
//   // await printDualText(distributorBill, printer, gen, false);
//   // await printDualText(creditCard, printer, gen, false);
//   // await printDualText(remittance, printer, gen, false);
//   // await printDualText(branchCustomer, printer, gen, false);
//   await printDualText(cashDepositInEnglish, printer, gen, false);

//   printer.add(gen.text('\n'));
//   printer.add(gen.text('********************************'));
//   printer.add(gen.text('\n'));
//   printer.add(gen.qrcode('taslimaemi038@gmail.com'));
//   await printSingleText(
//       '\nগ্রাহক কপি\nধন্যবাদ । এজেন্ট ব্যাংকিং', printer, gen);
//   printer.add(gen.text('\n\n\n'));

//   ///array print///

//   //2
//   // final header = [
//   //   {
//   //     'একাউন্ট নাম্বার': '২০৫৬০২৫৮১০০০১',
//   //     'একাউন্ট শিরোনাম': '১২৩৪৪৫৬৭৮৯০',
//   //     'পর্যাপ্ত টাকা': '২২৪,৩৫৮.৫৬',
//   //     'তারিখ': '২১ জানুয়ারি ২০২৪',
//   //   }
//   // ];

//   // await printDualText(header, printer, gen, false);
//   // printer.add(gen.text('==============================='));

//   // ///multiple print///
//   // List<Map<String, String>> miniStatement = [
//   //   {
//   //     'লেনদেনের তারিখ': '২১ জানুয়ারি ২০২৪',
//   //     'লেনদেনের পরিমান': '৫৪,৫০০.০০ টাকা',
//   //     'বিবরণ': 'আমার নাম তাসলিমা ইয়াসমিন ইমি',
//   //     'প্রকার': 'ডেবিট',
//   //   },
//   //   {
//   //     'লেনদেনের তারিখ': '২১ জানুয়ারি ২০২৪',
//   //     'লেনদেনের পরিমান': '৫৪,৫০০.০০ টাকা',
//   //     'বিবরণ': 'আমার নাম তাসলিমা ইয়াসমিন ইমি',
//   //     'প্রকার': 'ডেবিট',
//   //   },
//   //   {
//   //     'লেনদেনের তারিখ': '২১ জানুয়ারি ২০২৪',
//   //     'লেনদেনের পরিমান': '৫৪,৫০০.০০ টাকা',
//   //     'বিবরণ': 'আমার নাম তাসলিমা ইয়াসমিন ইমি',
//   //     'প্রকার': 'ডেবিট',
//   //   },
//   //   {
//   //     'লেনদেনের তারিখ': '২১ জানুয়ারি ২০২৪',
//   //     'লেনদেনের পরিমান': '৫৪,৫০০.০০ টাকা',
//   //     'বিবরণ': 'আমার নাম তাসলিমা ইয়াসমিন ইমি',
//   //     'প্রকার': 'ডেবিট',
//   //   },
//   //   {
//   //     'লেনদেনের তারিখ': '২১ জানুয়ারি ২০২৪',
//   //     'লেনদেনের পরিমান': '৫৪,৫০০.০০ টাকা',
//   //     'বিবরণ': 'আমার নাম তাসলিমা ইয়াসমিন ইমি',
//   //     'প্রকার': 'ডেবিট',
//   //   }
//   // ];

//   // List<Map<String, String>> tranHistory = [
//   //   {
//   //     'লেনদেনের তারিখ': '২১ জানুয়ারি ২০২৪',
//   //     'লেনদেনের পরিমান': '৫৪,৫০০.০০ টাকা',
//   //     'বিবরণ': 'আমার নাম তাসলিমা ইয়াসমিন ইমি',
//   //     'প্রকার': 'ডেবিট',
//   //   },
//   //   {
//   //     'লেনদেনের তারিখ': '২১ জানুয়ারি ২০২৪',
//   //     'লেনদেনের পরিমান': '৫৪,৫০০.০০ টাকা',
//   //     'বিবরণ': 'আমার নাম তাসলিমা ইয়াসমিন ইমি',
//   //     'প্রকার': 'ডেবিট',
//   //   },
//   //   {
//   //     'লেনদেনের তারিখ': '২১ জানুয়ারি ২০২৪',
//   //     'লেনদেনের পরিমান': '৫৪,৫০০.০০ টাকা',
//   //     'বিবরণ': 'আমার নাম তাসলিমা ইয়াসমিন ইমি',
//   //     'প্রকার': 'ডেবিট',
//   //   },
//   //   {
//   //     'লেনদেনের তারিখ': '২১ জানুয়ারি ২০২৪',
//   //     'লেনদেনের পরিমান': '৫৪,৫০০.০০ টাকা',
//   //     'বিবরণ': 'আমার নাম তাসলিমা ইয়াসমিন ইমি',
//   //     'প্রকার': 'ডেবিট',
//   //   },
//   //   {
//   //     'লেনদেনের তারিখ': '২১ জানুয়ারি ২০২৪',
//   //     'লেনদেনের পরিমান': '৫৪,৫০০.০০ টাকা',
//   //     'বিবরণ': 'আমার নাম তাসলিমা ইয়াসমিন ইমি',
//   //     'প্রকার': 'ডেবিট',
//   //   }
//   // ];
//   // await printDualText(miniStatement, printer, gen, true);
//   // await printDualText(tranHistory, printer, gen, true);

//   // //footer///

//   // printer.add(gen.qrcode('taslimaemi038@gmail.com'));

//   // await printSingleText(
//   //     '\nঅনুসন্ধানের জন্য কল করুন ১৬২২১ (২৪/৭ খোলা)\nধন্যবাদ । এজেন্ট ব্যাংকিং',
//   //     printer,
//   //     gen);
//   // printer.add(gen.text('\n\n\n'));

//   await printer.printData(device);
//   device.disconnect();
// }

// Future<void> printSingleText(
//     String text, BluePrint printer, Generator gen) async {
//   final headerBuilder = ui.ParagraphBuilder(
//     ui.ParagraphStyle(
//         textAlign: TextAlign.center,
//         fontSize: 23.0,
//         textDirection: TextDirection.ltr,
//         fontWeight: ui.FontWeight.w500),
//   )
//     ..pushStyle(ui.TextStyle(
//         color: ui.Color(0xFF000000), fontWeight: ui.FontWeight.w500))
//     ..addText(text);

//   final header = headerBuilder.build();
//   header.layout(ui.ParagraphConstraints(width: 350));
//   final recorder = ui.PictureRecorder();
//   final canvas = Canvas(recorder);
//   canvas.drawRect(Rect.fromLTWH(0, 0, header.width, header.height),
//       Paint()..color = Colors.white);
//   canvas.drawParagraph(header, Offset.zero);
//   final picture = recorder.endRecording();
//   final image =
//       await picture.toImage(header.width.toInt(), header.height.toInt());
//   final byteDataForHeader =
//       await image.toByteData(format: ui.ImageByteFormat.png);
//   if (byteDataForHeader != null) {
//     final Uint8List pngBytesForHeader = byteDataForHeader.buffer.asUint8List();
//     printer.add(gen.imageRaster(img.decodeImage(pngBytesForHeader)!,
//         highDensityVertical: true));
//     printer.add(gen.feed(2));
//   }
// }

// Future<void> printDualText(List<Map<String, String>> textMaps,
//     BluePrint printer, Generator gen, bool isMultiple) async {
//   final paragraphWidth1 = 150.0; // Width for the first paragraph
//   final paragraphWidth2 = 200.0; // Width for the second paragraph

//   for (final textMap in textMaps) {
//     for (final entry in textMap.entries) {
//       final String key = entry.key;
//       final String value = entry.value;

//       final paragraphBuilder1 = ui.ParagraphBuilder(
//         ui.ParagraphStyle(
//             textAlign: TextAlign.left,
//             fontSize: 23.0,
//             textDirection: TextDirection.ltr,
//             fontWeight: ui.FontWeight.w500),
//       )
//         ..pushStyle(ui.TextStyle(
//             color: ui.Color(0xFF000000), fontWeight: ui.FontWeight.w500))
//         ..addText('$key');

//       final paragraphBuilder2 = ui.ParagraphBuilder(
//         ui.ParagraphStyle(
//             textAlign: TextAlign.left,
//             fontSize: 23.0,
//             textDirection: TextDirection.ltr,
//             fontWeight: ui.FontWeight.w400),
//       )
//         ..pushStyle(ui.TextStyle(
//             color: ui.Color(0xFF000000), fontWeight: ui.FontWeight.w500))
//         ..addText(' : $value');

//       final paragraph1 = paragraphBuilder1.build();
//       final paragraph2 = paragraphBuilder2.build();

//       paragraph1.layout(ui.ParagraphConstraints(width: paragraphWidth1));
//       paragraph2.layout(ui.ParagraphConstraints(width: paragraphWidth2));

//       final recorder = ui.PictureRecorder();
//       final canvas = Canvas(recorder);

//       // Get max paragraph height
//       final maxParagraphHeight = (paragraph1.height > paragraph2.height
//           ? paragraph1.height
//           : paragraph2.height);

//       // Draw the first paragraph
//       canvas.drawRect(Rect.fromLTWH(0, 0, paragraph1.width, maxParagraphHeight),
//           Paint()..color = Colors.white);
//       canvas.drawParagraph(paragraph1, Offset.zero);

//       // Draw the second paragraph next to the first one
//       canvas.translate(paragraphWidth1, 0);

//       canvas.drawRect(Rect.fromLTWH(0, 0, paragraph2.width, maxParagraphHeight),
//           Paint()..color = Colors.white);
//       canvas.drawParagraph(paragraph2, Offset.zero);

//       final picture = recorder.endRecording();
//       final image = await picture.toImage(
//           (paragraphWidth1 + paragraphWidth2).toInt(),
//           maxParagraphHeight.toInt());

//       final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//       if (byteData != null) {
//         final Uint8List pngBytes = byteData.buffer.asUint8List();

//         printer.add(gen.imageRaster(img.decodeImage(pngBytes)!,
//             highDensityVertical: true));
//         printer.add(gen.feed(2));
//       }
//     }
//     if (isMultiple) printer.add(gen.text('==============================='));
//   }
// }
