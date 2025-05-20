import 'dart:convert';
import 'dart:typed_data';

import 'package:custom_post_quantum/custom_post_quantum.dart';


Future<void> main() async {
  // Instantiate Kyber KEM.
var kyber = Kyber.kem512();

// Define a key generation seed.
var seed = base64Decode("AAECAwQFBgcICQoLDA0ODwABAgMEBQYHCAkKCwwNDg8AAQIDBAUGBwgJCgsMDQ4PAAECAwQFBgcICQoLDA0ODw==");

// Generate keys from seed.
var (pk, sk) = kyber.generateKeys(seed);
print('pk: ${pk.serialize()}');
print('sk: ${sk.serialize()}');

// Define a KEM nonce.
var nonce = base64Decode("Dw8ODg0NDAwLCwoKCQkICAcHBgYFBQQEAwMCAgEBAAA=");

// Encapsulate nonce and retrieve cipher and shared key.
var (cipher, sharedKey1) = kyber.encapsulate(pk, nonce);
print('1: $sharedKey1');

// Or decapsulate the cipher and retrieve the shared key.
var sharedKey2 = kyber.decapsulate(cipher, sk);
print('2: $sharedKey2');
}