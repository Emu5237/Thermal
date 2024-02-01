import 'dart:async';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:thermal1/blue_print.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:thermal1/device_screen.dart';
//import 'package:thermal1/ff1.dart';
import 'package:thermal1/utils/extra.dart';
import 'package:thermal1/utils/snackbar.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
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
      // android is slow when asking for all advertisements,
      // so instead we only ask for 1/8 of them
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
                  // (e.advertisementData.connectable) ? widget.onTap : null;
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
              // ElevatedButton(
              //     child: const Text('Open route'),
              //     onPressed: () {
              //       Navigator.push(context,
              //           MaterialPageRoute(builder: (context) => HomePage()));
              //     }),
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

void printWithDevice(BluetoothDevice device) async {
  Map<String, dynamic> data1 = {
    'Date': '21 jan 2024',
    'Txn No': '1234567890123333336666',
    'Txn Type': 'Deposit',
    'A/C No': '888888',
    'A/C Title': 'abc',
    'Amount': 900,
    'Status': 'success',
  };

  await device.connect();
  final gen = Generator(PaperSize.mm58, await CapabilityProfile.load());
  final printer = BluePrint();
  printer.add(
    gen.emptyLines(2),
  );
  printer.add(
    gen.text('BRAC BANK PLC.', styles: const PosStyles(align: PosAlign.center)),
  );

  printer.add(gen.text('==============================',
      styles: const PosStyles(align: PosAlign.center)));
  printer.add(gen.text('(Duplicate Copy)',
      styles: const PosStyles(align: PosAlign.center)));
  printer.add(gen.text('Baroyarhat Agent Banking Outlet',
      styles: const PosStyles(align: PosAlign.center)));
  printer.add(
    gen.emptyLines(2),
  );

  data1.forEach(
    (key, value) {
      //  print('$key : $value');

      printer.add(gen.row([
        PosColumn(
          text: '$key',
          
          width: 4,
        ),
        PosColumn(
          text: ': $value'.toString(),
          width: 8,
        ),
      ]));
    },
  );
  printer.add(
    gen.emptyLines(2),
  );
  printer.add(gen.text('*****************************',
      styles: const PosStyles(align: PosAlign.center)));
  printer.add(gen.text('Customer Copy',
      styles: const PosStyles(align: PosAlign.center)));
  printer.add(gen.text('Thank You | Agent Banking',
      styles: const PosStyles(align: PosAlign.center)));
  printer.add(gen.text('Powered by mFino',
      styles: const PosStyles(align: PosAlign.center)));
  printer.add(gen.feed(4));
  await printer.printData(device);
  device.disconnect();
}
