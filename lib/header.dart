import 'package:esc_pos_utils/esc_pos_utils.dart';

Future<void> printHeader(Generator gen, printer) async {
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
}

Future<void> printHeader1(Generator gen, printer) async {
  printer.add(
    gen.emptyLines(2),
  );
  printer.add(
    gen.text('BRAC BANK PLC.', styles: const PosStyles(align: PosAlign.center)),
  );
  printer.add(gen.text('Baroyarhat Agent Banking Outlet',
      styles: const PosStyles(align: PosAlign.center)));
  printer.add(
    gen.emptyLines(2),
  );
}
// Usage example:
// void main() async {
//   final device = // obtain your device
//   await device.connect();
//   final gen = Generator(PaperSize.mm58, await CapabilityProfile.load());
//   final printer = BluePrint();
//   await printHeader(gen, printer);
//   // Continue with other printing logic
// }
