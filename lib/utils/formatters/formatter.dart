import 'package:intl/intl.dart';

class TFormatter {
  static formatDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('dd-MMM-YYYY').format(date);
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'en_KE', symbol: 'KSh').format(amount);
  }

  static String formatPhoneNumber(String phoneNumber) {
    // Format phone number to (07XX) XXX XXX for local or +254 7XX XXX XXX for international
    if (phoneNumber.length == 10 && phoneNumber.startsWith('07')) {
      // Local number format (07XX) XXX XXX
      return '(${phoneNumber.substring(0, 4)}) ${phoneNumber.substring(4, 7)} ${phoneNumber.substring(7)}';
    } else if (phoneNumber.length == 12 && phoneNumber.startsWith('254')) {
      // International format +254 7XX XXX XXX
      return '+254 ${phoneNumber.substring(3, 6)} ${phoneNumber.substring(6, 9)} ${phoneNumber.substring(9)}';
    } else if (phoneNumber.length == 13 && phoneNumber.startsWith('+254')) {
      // International format with +254 (e.g. +254 7XX XXX XXX)
      return '+254 ${phoneNumber.substring(4, 7)} ${phoneNumber.substring(7, 10)} ${phoneNumber.substring(10)}';
    }

    // If the phone number doesn't match expected formats, return the raw input
    return phoneNumber;
  }

  static String internationalFormatPhoneNumber(String phoneNumber) {
    // Remove any non-digit characters from the phone number
    var digitsOnly = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // Check for valid length (Kenyan numbers are typically 12 or 13 digits with country code)
    if (digitsOnly.length < 10) {
      return phoneNumber; // If too short, return the original input
    }

    // Extract the country code from the digits
    String countryCode = digitsOnly.startsWith('254')
        ? '+254'
        : '+${digitsOnly.substring(0, 2)}';

    // Adjust digitsOnly after extracting country code
    digitsOnly = digitsOnly.startsWith('254')
        ? digitsOnly.substring(3)
        : digitsOnly.substring(2);

    // Format the remaining digits (Kenyan phone numbers: XXX XXX XXX)
    final formattedNumber = StringBuffer();
    formattedNumber.write('($countryCode) ');

    int i = 0;
    while (i < digitsOnly.length) {
      int groupLength = 3;

      // Append groups of 3 digits
      if (i + groupLength < digitsOnly.length) {
        formattedNumber.write('${digitsOnly.substring(i, i + groupLength)} ');
      } else {
        formattedNumber
            .write(digitsOnly.substring(i)); // Last group (remaining digits)
      }
      i += groupLength;
    }

    return formattedNumber.toString().trim();
  }
}
