import 'package:custom_post_quantum/custom_post_quantum.dart';

class KEMKeyPair {
  final KemPublicKey publicKey;
  final KemPrivateKey privateKey;

  KEMKeyPair(this.publicKey, this.privateKey);
}
