import 'package:get/get.dart';

const List<String> lettersToDeburr = <String>[
  'ě',
  'š',
  'č',
  'ř',
  'ž',
  'ý',
  'á',
  'í',
  'é',
  'ú',
  'ů',
  'ď',
  'ň',
  'ó',
  'ť',
  'ć',
  'ę',
  'ł',
  'ś',
  'ź',
  'ż',
  'ľ',
  'ą'
];

const List<String> lettersDeburred = <String>[
  'e',
  's',
  'c',
  'r',
  'z',
  'y',
  'a',
  'i',
  'e',
  'u',
  'u',
  'd',
  'n',
  'o',
  't',
  'c',
  'e',
  'l',
  's',
  'z',
  'z',
  'l',
  'a'
];

String deburr(String s) {
  final StringBuffer buffer = StringBuffer();
  s.split('').forEach((String c) {
    final int index = lettersToDeburr.indexOf(c);
    buffer.write(index != -1 ? lettersDeburred.elementAt(index) : c);
  });
  return buffer.toString();
}

class SearchController extends GetxController {
  var search = ''.obs;
}
