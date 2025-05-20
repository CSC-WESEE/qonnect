import 'package:custom_post_quantum/custom_post_quantum.dart';

class DilithiumKeyPair {
  final DilithiumPublicKey publicKey;
  final DilithiumPrivateKey privateKey;

  DilithiumKeyPair(this.publicKey, this.privateKey);
}