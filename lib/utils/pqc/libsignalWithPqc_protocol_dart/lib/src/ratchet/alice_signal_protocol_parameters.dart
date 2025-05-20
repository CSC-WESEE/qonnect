import 'package:custom_post_quantum/custom_post_quantum.dart';
import 'package:optional/optional.dart';

import '../ecc/ec_key_pair.dart';
import '../ecc/ec_public_key.dart';
import '../identity_key.dart';
import '../identity_key_pair.dart';

class AliceSignalProtocolParameters {
  AliceSignalProtocolParameters({
    required this.ourIdentityKey,
    required this.ourBaseKey,
    required this.theirIdentityKey,
    required this.theirSignedPreKey,
    required this.theirRatchetKey,
    required this.theirOneTimePreKey,
  });

  final IdentityKeyPair ourIdentityKey;
  final ECKeyPair ourBaseKey;

  final IdentityKey theirIdentityKey;
  final ECPublicKey theirSignedPreKey;
  final Optional<ECPublicKey> theirOneTimePreKey;
  final ECPublicKey theirRatchetKey;
}

class AlicePqkemSignalProtocolParameters {
  AlicePqkemSignalProtocolParameters({
    required this.ourIdentityKey,
    required this.ourBaseKey,
    required this.theirIdentityKey,
    required this.theirSignedPreKey,
    required this.theirOneTimePreKey,
    required this.theirRatchetKey,
    required this.theirPqkemSignedPreKey,
    required this.theirPqkemOneTimeSignedPreKey,
  });

  final IdentityKeyPair ourIdentityKey;
  final ECKeyPair ourBaseKey;
  final IdentityKey theirIdentityKey;
  final ECPublicKey theirSignedPreKey;
  final Optional<ECPublicKey> theirOneTimePreKey;
  final ECPublicKey theirRatchetKey;
  final KemPublicKey theirPqkemSignedPreKey;
  final Optional<KemPublicKey> theirPqkemOneTimeSignedPreKey;
}
