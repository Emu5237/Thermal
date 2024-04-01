import 'package:translator/translator.dart';

String convertToBengali(String input) {
  const Map<String, String> bengaliCharacters = {
    '0': '০',
    '1': '১',
    '2': '২',
    '3': '৩',
    '4': '৪',
    '5': '৫',
    '6': '৬',
    '7': '৭',
    '8': '৮',
    '9': '৯',
    '.': '.',
    ',': ',',
    'a': 'এ',
    'b': 'ব',
    'c': 'সি',
    'd': 'ডি',
    'e': 'ই',
    'f': 'এফ',
    'g': 'জি',
    'h': 'এইচ',
    'i': 'আই',
    'j': 'জে',
    'k': 'কে',
    'l': 'এল',
    'm': 'এম',
    'n': 'এন',
    'o': 'ও',
    'p': 'পি',
    'q': 'কিউ',
    'r': 'আর',
    's': 'এস',
    't': 'টি',
    'u': 'ইউ',
    'v': 'ভি',
    'w': 'ডাবলু',
    'x': 'এক্স',
    'y': 'ওয়াই',
    'z': 'জেড',
    '/': '/',
  };

  return input.split('').map((char) {
    final lowerChar = char.toLowerCase();
    return bengaliCharacters[lowerChar] ?? char;
  }).join('');
}

String convertDateToBengali(String date) {
  const List<String> englishMonths = [
    'jan',
    'feb',
    'mar',
    'apr',
    'may',
    'jun',
    'jul',
    'aug',
    'sep',
    'oct',
    'nov',
    'dec'
  ];
  const List<String> bengaliMonths = [
    'জানুয়ারি',
    'ফেব্রুয়ারি',
    'মার্চ',
    'এপ্রিল',
    'মে',
    'জুন',
    'জুলাই',
    'আগস্ট',
    'সেপ্টেম্বর',
    'অক্টোবর',
    'নভেম্বর',
    'ডিসেম্বর'
  ];

  List<String> parts = date.split(' ');
  String day = convertToBengali(parts[0]);
  String month = bengaliMonths[englishMonths.indexOf(parts[1].toLowerCase())];
  String year = convertToBengali(parts[2]);

  String time = '';
  if (parts.length > 3) {
    List<String> timeParts = parts[3].split(':');
    String hours = convertToBengali(timeParts[0]);
    String minutes = convertToBengali(timeParts[1]);
    time = '$hours:$minutes';
  }

  if (time.isNotEmpty)
    return '$day $month $year $time';
  else
    return '$day $month $year';
}

String convertCurrencyToBengali(String amount) {
  String result = convertToBengali(amount.replaceAll('BDT', '').trim());
  return '$result টাকা';
}

final Map<String, String> translations = {
  "Date": "তারিখ",
  "Txn No.": "লেনদেন নম্বর",
  "Txn Type": "লেনদেন প্রকার",
  "A/C No.": "একাউন্ট নাম্বার",
  "A/C Title": "একাউন্ট শিরোনাম",
  "Amount": "পরিমান",
  "Status": "অবস্থা",
  'Cash Deposit': "নগদ আমানত",
  'Cash Withdrawal': "নগদ উত্তোলন",
  'Loan Installment': "লোনের কিস্তি",
  'Success': "সফল",
  "Failure": "বিফল",
  'Agent Fee': 'এজেন্ট ফি',
  'Total Amount': 'মোট পরিমান',
  'Operating A/C': 'পরিচালিত একাউন্ট',
  'Loan A/C No.': 'লোন একাউন্ট নাম্বার',
  'Loan A/C Title': 'লোন একাউন্ট শিরোনাম',
  'Withdrawal Amt.': 'উত্তোলনের পরিমান',
  'Loan Disbursement': 'লোন বিতরণ',
  'Company Name': 'প্রতিষ্ঠানের নাম',
  'Distributor Code': 'পরিবেশক কোড',
  'Distributor Bill': 'পরিবেশক বিল',
  'Card No.': 'কার্ড নম্বর',
  'Card Holder': 'কার্ড ধারক',
  'Exchange House': 'বিনিময় ঘর',
  'Sender Name': 'প্রেরকের নাম',
  'Ben.Name': 'বেনিফিশিয়ারি নাম',
  'Ben Mobile': 'বেনিফিশিয়ারি মোবাইল নাম্বার',
  'Credit Card': 'ক্রেডিট কার্ড',
  'F.remittance': 'বৈদেশিক রেমিট্যান্স',
  'undefined': 'অনির্ধারিত',
  'Trans-Fast': 'ট্রান্স-ফাস্ট',
  'Trn Date': 'লেনদেনের তারিখ',
  'Trn Amount': 'লেনদেনের পরিমান',
  'Particulars': 'বিশেষ',
  'Type': 'প্রকার',
  'Available Balance': 'পর্যাপ্ত টাকা',
  'Account No': 'একাউন্ট নাম্বার',
  'Account Title': 'একাউন্ট শিরোনাম',
  'DEBIT': 'ডেবিট'
};
Future<String> splitText(String text) async {
  final translator = GoogleTranslator();
  RegExp pattern = RegExp(r'([A-Z]{3}/[A-Z]{4}/[0-9]{6}/)(.+)');
  Iterable<Match> matches = pattern.allMatches(text);

  if (matches.isNotEmpty) {
    for (Match match in matches) {
      String prefix = match.group(1)!;
      String suffix = match.group(2)!;
      String convertedPrefix =
          convertToBengali(prefix); // Convert prefix to Bengali
      var nameTranslation =
          await translator.translate(suffix, from: 'en', to: 'bn');
      String convertedText = convertedPrefix +
          nameTranslation.toString(); // Concatenate prefix and suffix
      return convertedText;
    }
  }
  return '';
}
