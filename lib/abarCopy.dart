// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/services.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:image/image.dart';
// import 'package:thermal1/blue_print.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:thermal1/device_screen.dart';
// import 'package:thermal1/utils/extra.dart';
// import 'package:thermal1/utils/snackbar.dart';
// import 'package:image/image.dart' as img;
// import 'dart:ui' as ui;

// class thermalprinter101 extends StatefulWidget {
//   const thermalprinter101({Key? key}) : super(key: key);

//   @override
//   State<thermalprinter101> createState() => _thermalprinter101State();
// }

// class _thermalprinter101State extends State<thermalprinter101> {
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
//   final gen = Generator(PaperSize.mm80, await CapabilityProfile.load());
//   final printer = BluePrint();

//   // final textToImageee = await textToImage("আমার সোনার বাংলা", fontSize: 24);

//   // final ByteData? byteData =
//   //     await textToImageee.toByteData(format: ui.ImageByteFormat.png);
//   // final img.Image? image = img.decodeImage(byteData as List<int>);

//   // printer.add(gen.imageRaster(image!));
//   // printer.add(gen.text('hello'));
//   // printer.add(gen.feed(1));
//   // await printer.printData(device);
//   // device.disconnect();

//   final ByteData data = await rootBundle.load('assets/ok.png');
//   final Uint8List bytes = data.buffer.asUint8List();
//   final img.Image? image = img.decodeImage(bytes);

//   // final ByteData data2 = await rootBundle.load('assets/bangla2.png');
//   // final Uint8List bytes2 = data2.buffer.asUint8List();
//   // final img.Image? image2 = img.decodeImage(bytes2);

//   printer.add(gen.imageRaster(image!,
//       align: PosAlign.left,
//       highDensityVertical: true,
//       // imageFn: PosImageFn.graphics,
//       highDensityHorizontal: true));
//   //printer.add(gen.imageRaster(image2!, align: PosAlign.left));

//   // printer.add(gen.image(image));
//   // printer.add(gen.text('hello'));

//   printer.add(gen.feed(1));
//   await printer.printData(device);
//   device.disconnect();
// }
