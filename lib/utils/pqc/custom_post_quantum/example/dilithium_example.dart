import 'dart:convert';

import 'package:custom_post_quantum/custom_post_quantum.dart';

void main() {

  // Instantiate Dilithium.
  var dilithium = Dilithium.level2();

  // Define a key generation seed.
  var seed = base64Decode("AAECAwQFBgcICQoLDA0ODwABAgMEBQYHCAkKCwwNDg8=");

  // Generate keys from seed.
  var (pk, sk) = dilithium.generateKeys(seed);

  // Set the message.
  var msg = base64Decode("Dw4NDAsKCQgHBgUEAwIBAA8ODQwLCgkIBwYFBAMCAQA=");

  // Sign the message with the private key.
  var signature = dilithium.sign(sk, msg);

  // Verify the signature with the public key.
  var isValid = dilithium.verify(pk, msg, signature);


  print("Message: \n$msg\n");
  print("Signature: \n${signature.serialize()}\n");
  print("Is valid?: \n$isValid\n");
}
