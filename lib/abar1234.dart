import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:image/image.dart';
import 'package:image/image.dart' as img;
import 'package:thermal1/blue_print.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:thermal1/device_screen.dart';
import 'package:thermal1/function1.dart';
import 'package:thermal1/utils/extra.dart';
import 'package:thermal1/utils/snackbar.dart';
import 'package:translator/translator.dart';

class thermalprinter207 extends StatefulWidget {
  const thermalprinter207({Key? key}) : super(key: key);

  @override
  State<thermalprinter207> createState() => _thermalprinter207State();
}

class _thermalprinter207State extends State<thermalprinter207> {
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

void printWithDevice(BluetoothDevice device) async {
  await device.connect();
  final gen = Generator(PaperSize.mm58, await CapabilityProfile.load());
  final printer = BluePrint();
  final ByteData data = await rootBundle.load('assets/ab3.png');
  final Uint8List bytes = data.buffer.asUint8List();
  final image22 = decodeImage(bytes);
  printer.add(gen.imageRaster(image22!));
  printer.add(gen.text('\n'));

  bool isEnglish = true;

// 'BRAC BANK PLC\n============================\n(Duplicate Copy)\nBaroyarhat Agent Banking Outlet'
  ///header example one///
  await printSingleText(
      isEnglish
          ? 'BRAC BANK PLC\n============================\n(Duplicate Copy)\nBaroyarhat Agent Banking Outlet'
          : 'ব্র্যাক ব্যাংক পিএলসি\n===========================\n(ডুপ্লিকেট কপি)\nবারোইয়ারহাট এজেন্ট ব্যাংকিং আউটলেট',
      printer,
      gen);

  printer.add(gen.text('\n'));

  final translator = GoogleTranslator();
  //for title, using translate package

  var titleTranslationforCashDeposit =
      await translator.translate("Taslima Yeasmin", from: 'en', to: 'bn');

  final List<Map<String, String>> cashDeposit = [
    {
      isEnglish ? "Date" : translations["Date"]!: isEnglish
          ? '07 Jan 2024 15:06'
          : convertDateToBengali('07 Jan 2024 15:06'),
      isEnglish ? "Txn No." : translations["Txn No."]!: isEnglish
          ? '888836748930029828'
          : convertToBengali('888836748930029828'),
      isEnglish ? "Txn Type" : translations["Txn Type"]!:
          isEnglish ? 'Cash Deposit' : translations["Cash Deposit"]!,
      isEnglish ? "A/C No." : translations["A/C No."]!:
          isEnglish ? '2056025810001' : convertToBengali('2056025810001'),
      isEnglish ? "A/C Title" : translations["A/C Title"]!:
          isEnglish ? "Taslima Yeasmin" : titleTranslationforCashDeposit.text,
      isEnglish ? "Amount" : translations["Amount"]!: isEnglish
          ? 'BDT 363,000.00'
          : convertCurrencyToBengali('BDT 363,000.00'),
      isEnglish ? "Status" : translations["Status"]!:
          isEnglish ? 'Success' : translations["Success"]!
    }
  ];
  var titleTranslationforCashWithdrawal =
      await translator.translate("Taslima Yeasmin", from: 'en', to: 'bn');

  final List<Map<String, String>> cashWithdrawal = [
    {
      isEnglish ? "Date" : translations["Date"]!: isEnglish
          ? '07 Jan 2024 15:06'
          : convertDateToBengali('07 Jan 2024 15:06'),
      isEnglish ? "Txn No." : translations["Txn No."]!: isEnglish
          ? '888836748930029828'
          : convertToBengali('888836748930029828'),
      isEnglish ? "Txn Type" : translations["Txn Type"]!:
          isEnglish ? 'Cash Withdrawal' : translations["Cash Withdrawal"]!,
      isEnglish ? "A/C No." : translations["A/C No."]!:
          isEnglish ? '2056025810001' : convertToBengali('2056025810001'),
      isEnglish ? "A/C Title" : translations["A/C Title"]!: isEnglish
          ? "Taslima Yeasmin"
          : titleTranslationforCashWithdrawal.text,
      isEnglish ? "Amount" : translations["Amount"]!: isEnglish
          ? 'BDT 363,000.00'
          : convertCurrencyToBengali('BDT 363,000.00'),
      isEnglish ? "Status" : translations["Status"]!:
          isEnglish ? 'Success' : translations["Success"]!
    }
  ];
  var titleTranslationforLoanInstallment =
      await translator.translate("Taslima Yeasmin", from: 'en', to: 'bn');

  final List<Map<String, String>> loanInstallment = [
    {
      isEnglish ? "Date" : translations["Date"]!: isEnglish
          ? '07 Jan 2024 15:06'
          : convertDateToBengali('07 Jan 2024 15:06'),
      isEnglish ? "Txn No." : translations["Txn No."]!: isEnglish
          ? '888836748930029828'
          : convertToBengali('888836748930029828'),
      isEnglish ? "Txn Type" : translations["Txn Type"]!:
          isEnglish ? 'Loan Installment' : translations["Loan Installment"]!,
      isEnglish ? "Operating A/C" : translations["Operating A/C"]!:
          isEnglish ? '2056025810001' : convertToBengali('2056025810001'),
      isEnglish ? "Loan A/C No." : translations["Loan A/C No."]!:
          isEnglish ? '2056025810001' : convertToBengali('2056025810001'),
      isEnglish ? "Loan A/C Title" : translations["Loan A/C Title"]!: isEnglish
          ? "Taslima Yeasmin"
          : titleTranslationforLoanInstallment.text,
      isEnglish ? "Amount" : translations["Amount"]!: isEnglish
          ? 'BDT 363,000.00'
          : convertCurrencyToBengali('BDT 363,000.00'),
      isEnglish ? "Status" : translations["Status"]!:
          isEnglish ? 'Success' : translations["Success"]!
    }
  ];
  var titleTranslationforLoanDisbursement =
      await translator.translate("Taslima Yeasmin", from: 'en', to: 'bn');

  final List<Map<String, String>> loanDisbursement = [
    {
      isEnglish ? "Date" : translations["Date"]!: isEnglish
          ? '07 Jan 2024 15:06'
          : convertDateToBengali('07 Jan 2024 15:06'),
      isEnglish ? "Txn No." : translations["Txn No."]!: isEnglish
          ? '888836748930029828'
          : convertToBengali('888836748930029828'),
      isEnglish ? "Txn Type" : translations["Txn Type"]!:
          isEnglish ? 'Loan Disbursement' : translations["Loan Disbursement"]!,
      isEnglish ? "Operating A/C" : translations["Operating A/C"]!:
          isEnglish ? '2056025810001' : convertToBengali('2056025810001'),
      isEnglish ? "Loan A/C Title" : translations["Loan A/C Title"]!: isEnglish
          ? "Taslima Yeasmin"
          : titleTranslationforLoanDisbursement.text,
      isEnglish ? "Withdrawal Amt." : translations["Withdrawal Amt."]!:
          isEnglish
              ? 'BDT 363,000.00'
              : convertCurrencyToBengali('BDT 363,000.00'),
      isEnglish ? "Status" : translations["Status"]!:
          isEnglish ? 'Success' : translations["Success"]!
    }
  ];

  var titleTranslationforDistributorBill =
      await translator.translate("Renata Feni", from: 'en', to: 'bn');

  final List<Map<String, String>> distributorBill = [
    {
      isEnglish ? "Date" : translations["Date"]!: isEnglish
          ? '07 Jan 2024 15:06'
          : convertDateToBengali('07 feb 2024 15:06'),
      isEnglish ? "Txn No." : translations["Txn No."]!: isEnglish
          ? '888836748930029828'
          : convertToBengali('888836748930029828'),
      isEnglish ? "Txn Type" : translations["Txn Type"]!:
          isEnglish ? 'Distributor Bill' : translations["Distributor Bill"]!,
      isEnglish ? "Company Name" : translations["Company Name"]!:
          isEnglish ? "Renata Feni" : titleTranslationforDistributorBill.text,
      isEnglish ? "Distributor Code" : translations["Distributor Code"]!:
          isEnglish ? 'F50' : convertToBengali('F50'),
      isEnglish ? "Amount" : translations["Amount"]!: isEnglish
          ? 'BDT 363,000.00'
          : convertCurrencyToBengali('BDT 363,000.00'),
      isEnglish ? "Status" : translations["Status"]!:
          isEnglish ? 'Success' : translations["Success"]!
    }
  ];
  // var titleTranslationforCreditCard =
  //     await translator.translate("Taslima Yeasmin", from: 'en', to: 'bn');

  final List<Map<String, String>> creditCard = [
    {
      isEnglish ? "Date" : translations["Date"]!: isEnglish
          ? '07 Jan 2024 15:06'
          : convertDateToBengali('07 Jan 2024 15:06'),
      isEnglish ? "Txn No." : translations["Txn No."]!: isEnglish
          ? '888836748930029828'
          : convertToBengali('888836748930029828'),
      isEnglish ? "Txn Type" : translations["Txn Type"]!:
          isEnglish ? 'Credit Card' : translations["Credit Card"]!,
      isEnglish ? "Card No." : translations["Card No."]!: isEnglish
          ? '888836748930029828'
          : convertToBengali('888836748930029828'),
      isEnglish ? "Card Holder" : translations["Card Holder"]!:
          isEnglish ? 'undefined' : translations["undefined"]!,
      isEnglish ? "Amount" : translations["Amount"]!: isEnglish
          ? 'BDT 363,000.00'
          : convertCurrencyToBengali('BDT 363,000.00'),
      isEnglish ? "Status" : translations["Status"]!:
          isEnglish ? 'Success' : translations["Success"]!
    }
  ];

  var titleTranslationforFremittance =
      await translator.translate("Taslima Yeasmin", from: 'en', to: 'bn');

  final List<Map<String, String>> remittance = [
    {
      isEnglish ? "Date" : translations["Date"]!: isEnglish
          ? '07 Jan 2024 15:06'
          : convertDateToBengali('07 Jan 2024 15:06'),
      isEnglish ? "Txn No." : translations["Txn No."]!: isEnglish
          ? '888836748930029828'
          : convertToBengali('888836748930029828'),
      isEnglish ? "Txn Type" : translations["Txn Type"]!:
          isEnglish ? 'F.remittance' : translations["F.remittance"]!,
      isEnglish ? "Exchange House" : translations["Exchange House"]!:
          isEnglish ? 'Trans-Fast' : translations["Trans-Fast"]!,
      isEnglish ? "Sender Name" : translations["Sender Name"]!:
          isEnglish ? "Taslima Yeasmin" : titleTranslationforFremittance.text,
      isEnglish ? "Ben.Name" : translations["Ben.Name"]!:
          isEnglish ? "Taslima Yeasmin" : titleTranslationforFremittance.text,
      isEnglish ? "Ben Mobile" : translations["Ben Mobile"]!: isEnglish
          ? '888836748930029828'
          : convertToBengali('888836748930029828'),
      isEnglish ? "Amount" : translations["Amount"]!: isEnglish
          ? 'BDT 363,000.00'
          : convertCurrencyToBengali('BDT 363,000.00'),
      isEnglish ? "Status" : translations["Status"]!:
          isEnglish ? 'Failure' : translations["Failure"]!
    }
  ];
  var titleTranslationforBranchCustomer =
      await translator.translate("Taslima Yeasmin Emi", from: 'en', to: 'bn');
  final List<Map<String, String>> branchCustomer = [
    {
      isEnglish ? "Date" : translations["Date"]!: isEnglish
          ? '07 Jan 2024 15:06'
          : convertDateToBengali('07 Jan 2024 15:06'),
      isEnglish ? "Txn No." : translations["Txn No."]!: isEnglish
          ? '888836748930029828'
          : convertToBengali('888836748930029828'),
      isEnglish ? "Txn Type" : translations["Txn Type"]!:
          isEnglish ? 'Loan Installment' : translations["Loan Installment"]!,
      isEnglish ? "A/C No." : translations["A/C No."]!:
          isEnglish ? '2056025810001' : convertToBengali('2056025810001'),
      isEnglish ? "A/C Title" : translations["A/C Title"]!: isEnglish
          ? "Taslima yeasmin emi"
          : titleTranslationforBranchCustomer.text,
      isEnglish ? "Amount" : translations["Amount"]!: isEnglish
          ? 'BDT 363,000.00'
          : convertCurrencyToBengali('BDT 363,000.00'),
      isEnglish ? "Total Amount" : translations["Total Amount"]!: isEnglish
          ? 'BDT 63,000.00'
          : convertCurrencyToBengali('BDT 63,000.00'),
      isEnglish ? "Agent Fee" : translations["Agent Fee"]!:
          isEnglish ? 'BDT 5,000.00' : convertCurrencyToBengali('BDT 5,000.00'),
      isEnglish ? "Status" : translations["Status"]!:
          isEnglish ? 'Success' : translations["Success"]!
    }
  ];
  await printDualText(cashDeposit, printer, gen, false);
  // await printDualText(cashWithdrawal, printer, gen, false);
  // await printDualText(loanInstallment, printer, gen, false);
  //await printDualText(loanDisbursement, printer, gen, false);
  //await printDualText(distributorBill, printer, gen, false);
  // await printDualText(creditCard, printer, gen, false);
  // await printDualText(remittance, printer, gen, false);
  // await printDualText(branchCustomer, printer, gen, false);
  // await printDualText(branchCustomer, printer, gen, false);

  printer.add(gen.text('\n'));
  printer.add(gen.text('********************************'));
  printer.add(gen.text('\n'));
  printer.add(gen.qrcode('taslimaemi038@gmail.com'));
  await printSingleText(
      isEnglish
          ? '\nCustomer Copy\nThank You | Agent Banking'
          : '\nগ্রাহক কপি\nধন্যবাদ । এজেন্ট ব্যাংকিং',
      printer,
      gen);
  printer.add(gen.text('\n\n\n'));

  ///array print///

  var titleTranslationforMiniStatement =
      await translator.translate("Taslima Yeasmin Emi", from: 'en', to: 'bn');
  final List<Map<String, String>> header = [
    {
      isEnglish ? "Account No" : translations["Account No"]!:
          isEnglish ? '2056025810001' : convertToBengali('2056025810001'),
      isEnglish ? "Account Title" : translations["Account Title"]!: isEnglish
          ? "Taslima yeasmin emi"
          : titleTranslationforMiniStatement.text,
      isEnglish ? "Date" : translations["Date"]!: isEnglish
          ? '07 Jan 2024 15:06'
          : convertDateToBengali('07 Jan 2024 15:06'),
      isEnglish ? "Available Balance" : translations["Available Balance"]!:
          isEnglish ? 'BDT 5,000.00' : convertCurrencyToBengali('BDT 5,000.00'),
    },
  ];
  await printDualText(header, printer, gen, false);
  printer.add(gen.text('==============================='));

  final List<Map<String, String>> miniStatement = [
    {
      isEnglish ? "Trn Date" : translations["Trn Date"]!: isEnglish
          ? '07 Jan 2024 15:06'
          : convertDateToBengali('07 Jan 2024 15:06'),
      isEnglish ? "Trn Amount" : translations["Trn Amount"]!:
          isEnglish ? 'BDT 5,000.00' : convertCurrencyToBengali('BDT 5,000.00'),
      isEnglish ? "Particulars" : translations["Particulars"]!: isEnglish
          ? 'YTR/VVVV/114008/Taslima Yeasmin'
          : await splitText('YTR/VVVV/114008/Taslima Yeasmin'),
      isEnglish ? "Type" : translations["Type"]!:
          isEnglish ? 'DEBIT' : translations["DEBIT"]!,
    },
    {
      isEnglish ? "Trn Date" : translations["Trn Date"]!: isEnglish
          ? '07 Jan 2024 15:06'
          : convertDateToBengali('07 Jan 2024 15:06'),
      isEnglish ? "Trn Amount" : translations["Trn Amount"]!:
          isEnglish ? 'BDT 5,000.00' : convertCurrencyToBengali('BDT 5,000.00'),
      isEnglish ? "Particulars" : translations["Particulars"]!: isEnglish
          ? "Taslima yeasmin emi"
          : titleTranslationforMiniStatement.text,
      isEnglish ? "Type" : translations["Type"]!:
          isEnglish ? 'DEBIT' : translations["DEBIT"]!,
    },
  ];
  await printDualText(miniStatement, printer, gen, true);
// //tran history
  var titleTranslationforTranHistory =
      await translator.translate("Taslima Yeasmin Emi", from: 'en', to: 'bn');
  final List<Map<String, String>> header1 = [
    {
      isEnglish ? "Account No" : translations["Account No"]!:
          isEnglish ? '2056025810001' : convertToBengali('2056025810001'),
      isEnglish ? "Account Title" : translations["Account Title"]!: isEnglish
          ? "Taslima yeasmin emi"
          : titleTranslationforMiniStatement.text,
      isEnglish ? "Date" : translations["Date"]!: isEnglish
          ? '07 Jan 2024 15:06'
          : convertDateToBengali('07 Jan 2024 15:06'),
      isEnglish ? "Available Balance" : translations["Available Balance"]!:
          isEnglish ? 'BDT 5,000.00' : convertCurrencyToBengali('BDT 5,000.00'),
    },
  ];
  await printDualText(header1, printer, gen, false);
  printer.add(gen.text('==============================='));

  final List<Map<String, String>> tranHistory = [
    {
      isEnglish ? "Trn Date" : translations["Trn Date"]!: isEnglish
          ? '07 Jan 2024 15:06'
          : convertDateToBengali('07 Jan 2024 15:06'),
      isEnglish ? "Trn Amount" : translations["Trn Amount"]!:
          isEnglish ? 'BDT 5,000.00' : convertCurrencyToBengali('BDT 5,000.00'),
      isEnglish ? "Particulars" : translations["Particulars"]!: isEnglish
          ? "Taslima yeasmin emi"
          : titleTranslationforTranHistory.text,
      isEnglish ? "Type" : translations["Type"]!:
          isEnglish ? 'DEBIT' : translations["DEBIT"]!,
    },
    {
      isEnglish ? "Trn Date" : translations["Trn Date"]!: isEnglish
          ? '07 Jan 2024 15:06'
          : convertDateToBengali('07 Jan 2024 15:06'),
      isEnglish ? "Trn Amount" : translations["Trn Amount"]!:
          isEnglish ? 'BDT 5,000.00' : convertCurrencyToBengali('BDT 5,000.00'),
      isEnglish ? "Particulars" : translations["Particulars"]!: isEnglish
          ? "Taslima yeasmin emi"
          : titleTranslationforMiniStatement.text,
      isEnglish ? "Type" : translations["Type"]!:
          isEnglish ? 'DEBIT' : translations["DEBIT"]!,
    },
  ];
  await printDualText(tranHistory, printer, gen, true);

  //footer///

  printer.add(gen.qrcode('taslimaemi038@gmail.com'));

  await printSingleText(
      '\nঅনুসন্ধানের জন্য কল করুন ১৬২২১ (২৪/৭ খোলা)\nধন্যবাদ । এজেন্ট ব্যাংকিং',
      printer,
      gen);
  printer.add(gen.text('\n\n\n'));

  await printer.printData(device);
  device.disconnect();
}

Future<void> printSingleText(
    String text, BluePrint printer, Generator gen) async {
  final headerBuilder = ui.ParagraphBuilder(
    ui.ParagraphStyle(
        textAlign: TextAlign.center,
        fontSize: 23.0,
        textDirection: TextDirection.ltr,
        fontWeight: ui.FontWeight.w500),
  )
    ..pushStyle(ui.TextStyle(
        color: ui.Color(0xFF000000), fontWeight: ui.FontWeight.w500))
    ..addText(text);

  final header = headerBuilder.build();
  header.layout(ui.ParagraphConstraints(width: 350));
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  canvas.drawRect(Rect.fromLTWH(0, 0, header.width, header.height),
      Paint()..color = Colors.white);
  canvas.drawParagraph(header, Offset.zero);
  final picture = recorder.endRecording();
  final image =
      await picture.toImage(header.width.toInt(), header.height.toInt());
  final byteDataForHeader =
      await image.toByteData(format: ui.ImageByteFormat.png);
  if (byteDataForHeader != null) {
    final Uint8List pngBytesForHeader = byteDataForHeader.buffer.asUint8List();
    printer.add(gen.imageRaster(img.decodeImage(pngBytesForHeader)!,
        highDensityVertical: true));
    printer.add(gen.feed(2));
  }
}

Future<void> printDualText(List<Map<String, String>> textMaps,
    BluePrint printer, Generator gen, bool isMultiple) async {
  final paragraphWidth1 = 150.0; // Width for the first paragraph
  final paragraphWidth2 = 200.0; // Width for the second paragraph

  for (final textMap in textMaps) {
    for (final entry in textMap.entries) {
      final String key = entry.key;
      final String value = entry.value;

      final paragraphBuilder1 = ui.ParagraphBuilder(
        ui.ParagraphStyle(
            textAlign: TextAlign.left,
            fontSize: 23.0,
            textDirection: TextDirection.ltr,
            fontWeight: ui.FontWeight.w500),
      )
        ..pushStyle(ui.TextStyle(
            color: ui.Color(0xFF000000), fontWeight: ui.FontWeight.w500))
        ..addText('$key');

      final paragraphBuilder2 = ui.ParagraphBuilder(
        ui.ParagraphStyle(
            textAlign: TextAlign.left,
            fontSize: 23.0,
            textDirection: TextDirection.ltr,
            fontWeight: ui.FontWeight.w400),
      )
        ..pushStyle(ui.TextStyle(
            color: ui.Color(0xFF000000), fontWeight: ui.FontWeight.w500))
        ..addText(' : $value');

      final paragraph1 = paragraphBuilder1.build();
      final paragraph2 = paragraphBuilder2.build();

      paragraph1.layout(ui.ParagraphConstraints(width: paragraphWidth1));
      paragraph2.layout(ui.ParagraphConstraints(width: paragraphWidth2));

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      // Get max paragraph height
      final maxParagraphHeight = (paragraph1.height > paragraph2.height
          ? paragraph1.height
          : paragraph2.height);

      // Draw the first paragraph
      canvas.drawRect(Rect.fromLTWH(0, 0, paragraph1.width, maxParagraphHeight),
          Paint()..color = Colors.white);
      canvas.drawParagraph(paragraph1, Offset.zero);

      // Draw the second paragraph next to the first one
      canvas.translate(paragraphWidth1, 0);

      canvas.drawRect(Rect.fromLTWH(0, 0, paragraph2.width, maxParagraphHeight),
          Paint()..color = Colors.white);
      canvas.drawParagraph(paragraph2, Offset.zero);

      final picture = recorder.endRecording();
      final image = await picture.toImage(
          (paragraphWidth1 + paragraphWidth2).toInt(),
          maxParagraphHeight.toInt());

      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final Uint8List pngBytes = byteData.buffer.asUint8List();

        printer.add(gen.imageRaster(img.decodeImage(pngBytes)!,
            highDensityVertical: true));
        printer.add(gen.feed(2));
      }
    }
    if (isMultiple) printer.add(gen.text('==============================='));
  }
}
