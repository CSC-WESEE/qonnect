import 'dart:typed_data';

import 'package:custom_post_quantum/custom_post_quantum.dart';
import 'package:optional/optional.dart';

import '../ecc/ec_key_pair.dart';
import '../ecc/ec_public_key.dart';
import '../identity_key.dart';
import '../identity_key_pair.dart';
import 'package:custom_post_quantum/src/algorithms/kyber/abstractions/kyberKeyPair.dart';

class SymmetricSignalProtocolParameters {
  SymmetricSignalProtocolParameters({
    required this.ourBaseKey,
    required this.ourRatchetKey,
    required this.ourIdentityKey,
    required this.theirBaseKey,
    required this.theirRatchetKey,
    required this.theirIdentityKey,
  });

  final ECKeyPair ourBaseKey;
  final ECKeyPair ourRatchetKey;
  final IdentityKeyPair ourIdentityKey;

  final ECPublicKey theirBaseKey;
  final ECPublicKey theirRatchetKey;
  final IdentityKey theirIdentityKey;
}

class SymmetricPqkemSignalProtocolParameters {
  SymmetricPqkemSignalProtocolParameters({
    required this.ourBaseKey,
    required this.ourRatchetKey,
    required this.ourIdentityKey,
    required this.ourPqkemSignedPreKey,
    required this.ourPqkemOneTimeSignedPreKey,
    required this.theirBaseKey,
    required this.theirRatchetKey,
    required this.theirIdentityKey,
    required this.theirPqkemSignedPreKey,
    required this.theirPqkemOneTimeSignedPreKey,
    required this.secretCipher,
  });

  final ECKeyPair ourBaseKey;
  final ECKeyPair ourRatchetKey;
  final IdentityKeyPair ourIdentityKey;
  final KEMKeyPair ourPqkemSignedPreKey;
  final Optional<KEMKeyPair> ourPqkemOneTimeSignedPreKey;

  final ECPublicKey theirBaseKey;
  final ECPublicKey theirRatchetKey;
  final IdentityKey theirIdentityKey;
  final KemPublicKey theirPqkemSignedPreKey;
  final Optional<KemPublicKey> theirPqkemOneTimeSignedPreKey;
  final Uint8List secretCipher;
}
