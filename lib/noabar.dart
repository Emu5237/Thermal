// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:ui' as ui;
// import 'dart:io';
// import 'dart:typed_data';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
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

// // void printWithDevice(BluetoothDevice device) async {
// //   await device.connect();
// //   final gen = Generator(PaperSize.mm58, await CapabilityProfile.load());
// //   final printer = BluePrint();

// //   ////////////////////////////////////////////////////
// //   ///header
// //   final headerBuilder = ui.ParagraphBuilder(
// //     ui.ParagraphStyle(
// //       textAlign: TextAlign.center,
// //       fontSize: 20.0,
// //       textDirection: TextDirection.ltr,
// //     ),
// //   )
// //     ..pushStyle(ui.TextStyle(color: ui.Color(0xFF000000)))
// //     ..addText(
// //         'ব্র্যাক ব্যাংক পিএলসি (BRAC Bank PLC) বাংলাদেশের স্বায়ত্তশাসিত বাণিজ্যিক ব্যাংকগুলোর মধ্যে অন্যতম। এটি মূলত; বেসরকারি\n\n');

// //   final header = headerBuilder.build();
// //   header.layout(ui.ParagraphConstraints(width: 350));
// //   final recorder = ui.PictureRecorder();
// //   final canvas = Canvas(recorder);
// //   canvas.drawRect(Rect.fromLTWH(0, 0, header.width, header.height),
// //       Paint()..color = Colors.white);
// //   canvas.drawParagraph(header, Offset.zero);
// //   final picture = recorder.endRecording();
// //   final image =
// //       await picture.toImage(header.width.toInt(), header.height.toInt());
// //   final byteDataForHeader =
// //       await image.toByteData(format: ui.ImageByteFormat.png);
// //   if (byteDataForHeader != null) {
// //     final Uint8List pngBytesForHeader = byteDataForHeader.buffer.asUint8List();
// //     printer.add(gen.imageRaster(img.decodeImage(pngBytesForHeader)!,
// //         highDensityVertical: true));
// //     printer.add(gen.feed(1));

// //     ////////////////////////////////////////////////////////

// //     final cashDeposit = {
// //       // 'ক্যাশ ডিপোজিট': '১২৩৪৪৫৬৭৮৯০',
// //       // 'ডিজিটাল সোনার বাংলাদেশ': 'আমার সোনার বাংলাদেশ আমি তোমায় ভালোবাসি',
// //       // 'ট্রানজেকশন নং': 'আমার নাম তাসলিমা ইয়াসমিন ইমি',
// //       // 'এনআইডি নং': '৬৩৬৭৮৮৯২১',
// //       // 'ঠিকানা': 'শাহজাদপুর বাসতলা, গুলশান, ধাকা-১২১২',

// //       'স্ট্যাটাস': 'সাক্সেস',
// //       'এ/সি নম্বর': '১২৩৪৪৫৬৭৮৯০',
// //       'এ/সি শিরোনাম': '১২৩৪৪৫৬৭৮৯০',
// //       'উপলভ্য ব্যালেন্স': '১২৩৪৪৫,৬৭৮৯০.১২৩৪৪৫৬৭৮৯০',
// //       'তারিখ': '২১ জানুয়ারি ২০২৪',
// //     };

// //     final paragraphWidth1 = 150.0; // Width for the first paragraph
// //     final paragraphWidth2 = 200.0; // Width for the second paragraph

// //     for (final entry in cashDeposit.entries) {
// //       final String key = entry.key;
// //       final String value = entry.value;

// //       final paragraphBuilder1 = ui.ParagraphBuilder(
// //         ui.ParagraphStyle(
// //           textAlign: TextAlign.left,
// //           fontSize: 20.0,
// //           textDirection: TextDirection.ltr,
// //         ),
// //       )
// //         ..pushStyle(ui.TextStyle(color: ui.Color(0xFF000000)))
// //         ..addText('$key :');

// //       final paragraphBuilder2 = ui.ParagraphBuilder(
// //         ui.ParagraphStyle(
// //           textAlign: TextAlign.left,
// //           fontSize: 20.0,
// //           textDirection: TextDirection.ltr,
// //         ),
// //       )
// //         ..pushStyle(ui.TextStyle(color: ui.Color(0xFF000000)))
// //         ..addText('$value');

// //       final paragraph1 = paragraphBuilder1.build();
// //       final paragraph2 = paragraphBuilder2.build();

// //       paragraph1.layout(ui.ParagraphConstraints(width: paragraphWidth1));
// //       paragraph2.layout(ui.ParagraphConstraints(width: paragraphWidth2));

// //       final recorder = ui.PictureRecorder();
// //       final canvas = Canvas(recorder);

// //       //get max paragraph height
// //       final maxParagraphHeight = (paragraph1.height > paragraph2.height
// //           ? paragraph1.height
// //           : paragraph2.height);

// //       // Draw the first paragraph
// //       canvas.drawRect(Rect.fromLTWH(0, 0, paragraph1.width, maxParagraphHeight),
// //           Paint()..color = Colors.white);
// //       canvas.drawParagraph(paragraph1, Offset.zero);

// //       // Draw the second paragraph next to the first one
// //       canvas.translate(paragraphWidth1, 0);
// //       canvas.drawRect(Rect.fromLTWH(0, 0, paragraph2.width, maxParagraphHeight),
// //           Paint()..color = Colors.white);
// //       canvas.drawParagraph(paragraph2, Offset.zero);

// //       final picture = recorder.endRecording();
// //       final image = await picture.toImage(
// //           (paragraphWidth1 + paragraphWidth2).toInt(),
// //           maxParagraphHeight.toInt());

// //       final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
// //       if (byteData != null) {
// //         final Uint8List pngBytes = byteData.buffer.asUint8List();

// //         printer.add(gen.imageRaster(img.decodeImage(pngBytes)!,
// //             highDensityVertical: true));
// //         printer.add(gen.feed(1));
// //       }
// //     }

// //     ////////////////////////////////////////////////////
// //     ///footer
// //     final footerBuilder = ui.ParagraphBuilder(
// //       ui.ParagraphStyle(
// //         textAlign: TextAlign.center,
// //         fontSize: 20.0,
// //         textDirection: TextDirection.ltr,
// //       ),
// //     )
// //       ..pushStyle(ui.TextStyle(color: ui.Color(0xFF000000)))
// //       ..addText('\n\nব্র্যাক ব্যাংক পিএলসি (BRAC Bank PLC)');

// //     final header = footerBuilder.build();
// //     header.layout(ui.ParagraphConstraints(width: 350));
// //     final recorder = ui.PictureRecorder();
// //     final canvas = Canvas(recorder);
// //     canvas.drawRect(Rect.fromLTWH(0, 0, header.width, header.height),
// //         Paint()..color = Colors.white);
// //     canvas.drawParagraph(header, Offset.zero);
// //     final picture = recorder.endRecording();
// //     final image =
// //         await picture.toImage(header.width.toInt(), header.height.toInt());
// //     final byteDataForFooter =
// //         await image.toByteData(format: ui.ImageByteFormat.png);
// //     if (byteDataForFooter != null) {
// //       final Uint8List pngBytesForFooter =
// //           byteDataForFooter.buffer.asUint8List();
// //       printer.add(gen.imageRaster(img.decodeImage(pngBytesForFooter)!,
// //           highDensityVertical: true));
// //       printer.add(gen.feed(1));

// //       ////////////////////////////////////////////////////////

// //       await printer.printData(device);
// //       device.disconnect();
// //     }
// //   }
// // }

// void printWithDevice(BluetoothDevice device) async {
//   await device.connect();
//   final gen = Generator(PaperSize.mm58, await CapabilityProfile.load());
//   final printer = BluePrint();

//   ///header example one///
//   await printSingleText(
//       'ব্র্যাক ব্যাংক পিএলসি (BRAC Bank PLC) বাংলাদেশের স্বায়ত্তশাসিত বাণিজ্যিক ব্যাংকগুলোর মধ্যে অন্যতম\n\n',
//       printer,
//       gen);
//   printer.add(gen.text('\n'));

//   ///header example two///
//   final header = [
//     {
//       'স্ট্যাটাস': 'সাক্সেস',
//       'এ/সি নম্বর': '১২৩৪৪৫৬৭৮৯০',
//       'এ/সি শিরোনাম': '১২৩৪৪৫৬৭৮৯০',
//       'উপলভ্য ব্যালেন্স': '১২৩৪৪৫,৬৭৮৯০.১২৩৪৪৫৬৭৮৯০',
//       'তারিখ': '২১ জানুয়ারি ২০২৪',
//     }
//   ];

//   await printDualText(header, printer, gen, false);
//   printer.add(gen.text('\n'));

//   ///single print///
//   final cashDeposit = [
//     {
//       // 'স্ট্যাটাস': 'সাক্সেস',
//       // 'এ/সি নম্বর': '১২৩৪৪৫৬৭৮৯০',
//       // 'এ/সি শিরোনাম': '১২৩৪৪৫৬৭৮৯০',
//       // 'উপলভ্য ব্যালেন্স': '১২৩৪৪৫,৬৭৮৯০.১২৩৪৪৫৬৭৮৯০',
//       // 'তারিখ': '২১ জানুয়ারি ২০২৪',
//       'স্ট্যাটাস': 'সাক্সেস',
//       'এ/সি নম্বর': '১২৩৪৪৫৬৭৮৯০',
//       'এ/সি শিরোনাম': '১২৩৪৪৫৬৭৮৯০',
//       'উপলভ্য ব্যালেন্স': '১২৩৪৪৫,৬৭৮৯০.১২৩৪৪৫৬৭৮৯০',
//       'তারিখ': '২১ জানুয়ারি ২০২৪',
//     }
//   ];

//   // await printDualText(cashDeposit, printer, gen, false);

//   ///array print///
//   printer.add(gen.text('========================'));
//   List<Map<String, String>> cashDeposits = [
//     {
//       'ক্যাশ ডিপোজিট': '১২৩৪৪৫৬৭৮৯০',
//       'ডিজিটাল সোনার বাংলাদেশ': 'আমার সোনার বাংলাদেশ আমি তোমায় ভালোবাসি',
//       'ট্রানজেকশন নং': 'আমার নাম তাসলিমা ইয়াসমিন ইমি',
//       'এনআইডি নং': '৬৩৬৭৮৮৯২১',
//       'ঠিকানা': 'শাহজাদপুর বাসতলা, গুলশান, ধাকা-১২১২'
//     },
//     {
//       'স্ট্যাটাস': 'সাক্সেস',
//       'এ/সি নম্বর': '১২৩৪৪৫৬৭৮৯০',
//       'এ/সি শিরোনাম': '১২৩৪৪৫৬৭৮৯০',
//       'উপলভ্য ব্যালেন্স': '১২৩৪৪৫,৬৭৮৯০.১২৩৪৪৫৬৭৮৯০',
//       'তারিখ': '২১ জানুয়ারি ২০২৪',
//     }
//   ];

//   await printDualText(cashDeposits, printer, gen, true);

//   ///footer///
//   await printSingleText(
//       '\n\nব্র্যাক ব্যাংক পিএলসি (BRAC Bank PLC)', printer, gen);
//   printer.add(gen.text('\n\n\n'));
//   await printer.printData(device);
//   device.disconnect();
// }

// Future<void> printSingleText(
//     String text, BluePrint printer, Generator gen) async {
//   final headerBuilder = ui.ParagraphBuilder(
//     ui.ParagraphStyle(
//       textAlign: TextAlign.center,
//       fontSize: 20.0,
//       textDirection: TextDirection.ltr,
//     ),
//   )
//     ..pushStyle(ui.TextStyle(color: ui.Color(0xFF000000)))
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
//           textAlign: TextAlign.left,
//           fontSize: 20.0,
//           textDirection: TextDirection.ltr,
//         ),
//       )
//         ..pushStyle(ui.TextStyle(color: ui.Color(0xFF000000)))
//         ..addText('$key :');

//       final paragraphBuilder2 = ui.ParagraphBuilder(
//         ui.ParagraphStyle(
//           textAlign: TextAlign.left,
//           fontSize: 20.0,
//           textDirection: TextDirection.ltr,
//         ),
//       )
//         ..pushStyle(ui.TextStyle(color: ui.Color(0xFF000000)))
//         ..addText('$value');

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
//     if (isMultiple) printer.add(gen.text('========================='));
//   }
// }
