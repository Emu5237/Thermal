import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:image/image.dart';
import 'package:image/image.dart' as img;
import 'package:thermal1/blue_print.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:thermal1/device_screen.dart';
import 'package:thermal1/utils/extra.dart';
import 'package:thermal1/utils/snackbar.dart';

class thermalprinter10 extends StatefulWidget {
  const thermalprinter10({Key? key}) : super(key: key);

  @override
  State<thermalprinter10> createState() => _thermalprinter10State();
}

class _thermalprinter10State extends State<thermalprinter10> {
  List<BluetoothDevice> _systemDevices = [];
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  @override
  void initState() {
    super.initState();

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      if (mounted) {
        setState(() {
          _scanResults = results;
        });
      }
    }, onError: (e) {
      Snackbar.show(ABC.b, prettyException("Scan Error:", e), success: false);
    });

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    super.dispose();
  }

  Future onScanPressed() async {
    try {
      _systemDevices = await FlutterBluePlus.systemDevices;
    } catch (e) {
      Snackbar.show(ABC.b, prettyException("System Devices Error:", e),
          success: false);
    }
    try {
      int divisor = Platform.isAndroid ? 8 : 1;
      await FlutterBluePlus.startScan(
          timeout: const Duration(seconds: 15),
          continuousUpdates: true,
          continuousDivisor: divisor);
    } catch (e) {
      Snackbar.show(ABC.b, prettyException("Start Scan Error:", e),
          success: false);
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future onStopPressed() async {
    try {
      FlutterBluePlus.stopScan();
    } catch (e) {
      Snackbar.show(ABC.b, prettyException("Stop Scan Error:", e),
          success: false);
    }
  }

  void onConnectPressed(BluetoothDevice device) {
    device.connectAndUpdateStream().catchError((e) {
      Snackbar.show(ABC.c, prettyException("Connect Error:", e),
          success: false);
    });
    MaterialPageRoute route = MaterialPageRoute(
        builder: (context) => DeviceScreen(device: device),
        settings: RouteSettings(name: '/DeviceScreen'));
    Navigator.of(context).push(route);
  }

  Future onRefresh() {
    if (_isScanning == false) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    }
    if (mounted) {
      setState(() {});
    }
    return Future.delayed(Duration(milliseconds: 500));
  }

  Widget buildScanButton(BuildContext context) {
    if (FlutterBluePlus.isScanningNow) {
      return FloatingActionButton(
        child: const Icon(Icons.stop),
        onPressed: onStopPressed,
        backgroundColor: Colors.red,
      );
    } else {
      return FloatingActionButton(
          child: const Text("SCAN"), onPressed: onScanPressed);
    }
  }

  Iterable<Container> scanTiles(BuildContext context) {
    return _scanResults.map(
      (e) {
        return Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  printWithDevice(e.device);
                },
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(e.device.platformName),
                      SizedBox(
                        height: 10,
                      ),
                      Text(e.device.remoteId.str),
                    ],
                  ),
                ),
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: Snackbar.snackBarKeyB,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Find Devices'),
        ),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView(
            children: <Widget>[
              ...scanTiles(context),
            ],
          ),
        ),
        floatingActionButton: buildScanButton(context),
      ),
    );
  }
}

// void printWithDevice(BluetoothDevice device) async {
//   await device.connect();
//   final gen = Generator(PaperSize.mm58, await CapabilityProfile.load());
//   final printer = BluePrint();
//   final banglaText = 'বাংলা বাংলা বাংলা বাংলা বাংলা বাংলা';
//   final paragraphBuilder = ui.ParagraphBuilder(
//     ui.ParagraphStyle(
//       textAlign: TextAlign.left,
//       fontSize: 24.0,
//       textDirection: TextDirection.ltr,
//     ),
//   )
//     ..pushStyle(ui.TextStyle(color: ui.Color(0xFF000000)))
//     ..addText(banglaText);
//   final paragraph = paragraphBuilder.build();
//   paragraph.layout(ui.ParagraphConstraints(width: 300));
//   //final boundary = RenderRepaintBoundary();
//   final recorder = ui.PictureRecorder();
//   final canvas = Canvas(recorder);
//   canvas.drawRect(Rect.fromLTWH(0, 0, paragraph.width, paragraph.height),
//       Paint()..color = Colors.white);
//   canvas.drawParagraph(paragraph, Offset.zero);
//   final picture = recorder.endRecording();
//   final image =
//       await picture.toImage(paragraph.width.toInt(), paragraph.height.toInt());
//   final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//   if (byteData != null) {
//     //log('eeeeeeeeeeeeeeee' + byteData.toString());
//     final Uint8List pngBytes = byteData.buffer.asUint8List();
//     print('bytesssssssssssssssssssssssssssssssssssssss');
//     print(pngBytes);
//     printer.add(
//         gen.imageRaster(img.decodeImage(pngBytes)!, highDensityVertical: true));
//     printer.add(gen.feed(1));
//     await printer.printData(device);
//     device.disconnect();
//   }
// }

void printWithDevice(BluetoothDevice device) async {
  await device.connect();
  final gen = Generator(PaperSize.mm58, await CapabilityProfile.load());
  final printer = BluePrint();
  final cashDeposit = {
    'ডিজিটাল বাংলাদেশ': 'ডিজিটাল বাংলাদেশ',
    'বাংলাদেশ': 'ডিজিটাল বাংলাদেশ',
    'ডিজিটাল বাংলাদেশ ক': 'ডিজিটাল বাংলাদেশ',
    'ডিজিটাল বাংলাদেশ খ': 'ডিজিটাল বাংলাদেশ',
    'ডিজিটাল বাংলাদেশ গ': 'ডিজিটাল বাংলাদেশ',
    'ডিজিটাল বাংলাদেশ ঘ': 'ডিজিটাল বাংলাদেশ',
    'ডিজিটাল বাংলাদেশ চ': 'ডিজিটাল বাংলাদেশ',
    'ডিজিটাল বাংলাদেশ ছ': 'ডিজিটাল বাংলাদেশ',
    'ডিজিটাল বাংলাদেশ ম': 'ডিজিটাল বাংলাদেশ',
    'ডিজিটাল বাংলাদেশ ন': 'ডিজিটাল বাংলাদেশ',
  };
  for (final entry in cashDeposit.entries) {
    final String key = entry.key;
    final String value = entry.value;
    final paragraphBuilder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
        textAlign: TextAlign.left,
        fontSize: 22.0,
        textDirection: TextDirection.ltr,
      ),
    )
      ..pushStyle(ui.TextStyle(color: ui.Color(0xFF000000)))
      ..addText('$key: $value');
    final paragraph = paragraphBuilder.build();
    paragraph.layout(ui.ParagraphConstraints(width: 350));
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawRect(Rect.fromLTWH(0, 0, paragraph.width, paragraph.height),
        Paint()..color = Colors.white);
    canvas.drawParagraph(paragraph, Offset.zero);
    final picture = recorder.endRecording();
    final image = await picture.toImage(
        paragraph.width.toInt(), paragraph.height.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      final Uint8List pngBytes = byteData.buffer.asUint8List();
      printer.add(gen.imageRaster(img.decodeImage(pngBytes)!,
          highDensityVertical: true));
      printer.add(gen.feed(1));
    }
  }
  await printer.printData(device);
  device.disconnect();
}
