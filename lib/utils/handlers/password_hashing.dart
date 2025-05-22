import 'dart:convert';

import 'package:crypto/crypto.dart';

String hashPassword(String password) {
  final hashedPass = sha256.convert(utf8.encode(password)).toString();
  return hashedPass;
}
