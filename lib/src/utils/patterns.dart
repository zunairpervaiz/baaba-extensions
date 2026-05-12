/// Predefined Patterns for different validation
class Patterns {
  static String url = r'^(https?|ftp):\/\/[a-zA-Z0-9\-\.]+(?:\.[a-zA-Z]{2,})(?::\d{1,5})?(?:\/[^\s?#]*)?(?:\?[^\s#]*)?(?:#[^\s]*)?$';

  static String phone = r'(^(?:[+0]9)?[0-9]{10,12}$)';

  // Specifically for 03xxxxxxxxx format
  static const String pkMobileLocal = r'^(03[0-9]{9})$';

  // If you ever need to allow +92 as well:
  static const String pkMobileGlobal = r'^((\+92)|(0092)|0)3[0-9]{9}$';

  static String email = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  static String emailEnhanced =
      r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';

  static String image = r'.(jpeg|jpg|gif|png|bmp)$';

  /// Audio regex
  static String audio = r'.(mp3|wav|wma|amr|ogg|opus|aac|flac|alac)$';

  /// Video regex
  static String video = r'.(mp4|avi|wmv|rmvb|mpg|mpeg|3gp|mkv|webm|flv|ogg|ogv)$';

  /// Txt regex
  static String txt = r'.txt$';

  /// Document regex
  static String doc = r'.(doc|docx)$';

  /// Excel regex
  static String excel = r'.(xls|xlsx)$';

  /// PPT regex
  static String ppt = r'.(ppt|pptx)$';

  /// Document regex
  static String apk = r'.apk$';

  /// PDF regex
  static String pdf = r'.pdf$';

  /// HTML regex
  static String html = r'.html$';

  /// Pakistani CNIC — format: 00000-0000000-0
  static const String cnic = r'^\d{5}-\d{7}-\d{1}$';

  /// Pakistani NTN (National Tax Number) — format: 0000000-0
  static const String ntn = r'^\d{7}-\d{1}$';

  /// IPv4 address
  static const String ipv4 =
      r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$';

  /// Common credit/debit card number (Visa, Mastercard, Amex, Discover, JCB)
  static const String creditCard =
      r'^(?:4[0-9]{12}(?:[0-9]{3})?'
      r'|5[1-5][0-9]{14}'
      r'|3[47][0-9]{13}'
      r'|3(?:0[0-5]|[68][0-9])[0-9]{11}'
      r'|6(?:011|5[0-9]{2})[0-9]{12}'
      r'|(?:2131|1800|35\d{3})\d{11})$';

  /// Hex color code — #fff or #ffffff
  static const String hexColor = r'^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$';
}
