import 'dart:math';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';

import '../ecc/curve.dart';
import '../ecc/ec_key_pair.dart';
import '../identity_key.dart';
import '../identity_key_pair.dart';
import '../state/pre_key_record.dart';
import '../state/signed_pre_key_record.dart';
import 'medium.dart';
import 'package:custom_post_quantum/src/algorithms/dilithium/abstractions/dilithiumKeyPair.dart';

IdentityKeyPair generateIdentityKeyPair() {
  final keyPair = Curve.generateKeyPair();
  final publicKey = IdentityKey(keyPair.publicKey);
  return IdentityKeyPair(publicKey, keyPair.privateKey);
}

IdentityKeyPair generateIdentityKeyPairFromPrivate(List<int> private) {
  final keyPair = Curve.generateKeyPairFromPrivate(private);
  final publicKey = IdentityKey(keyPair.publicKey);
  return IdentityKeyPair(publicKey, keyPair.privateKey);
}

int integerMax = 0x7fffffff;

// ignore: avoid_positional_boolean_parameters
int generateRegistrationId(bool extendedRange) {
  if (extendedRange) {
    return _random.nextInt(integerMax - 1) + 1;
  } else {
    return _random.nextInt(16380) + 1;
  }
}

List<PreKeyRecord> generatePreKeys(int start, int count) {
  final results = <PreKeyRecord>[];
  // ignore: parameter_assignments
  start--;
  for (var i = 0; i < count; i++) {
    results.add(PreKeyRecord(
        ((start + i).remainder(maxValue - 1)) + 1, Curve.generateKeyPair()));
  }
  return results;
}

SignedPreKeyRecord generateSignedPreKey(
    IdentityKeyPair identityKeyPair, int signedPreKeyId, DilithiumKeyPair dilithiumKeyPair) {
  final keyPair = Curve.generateKeyPair();
  final signature = DilithiumSignatureGenAndVerify.calculateDilithiumSignature(
      dilithiumKeyPair.privateKey, keyPair.publicKey.serialize());

  return SignedPreKeyRecord(signedPreKeyId,
      Int64(DateTime.now().millisecondsSinceEpoch), keyPair, signature);
}

ECKeyPair generateSenderSigningKey() => Curve.generateKeyPair();

Uint8List generateSenderKey() => generateRandomBytes();

int generateSenderKeyId() => _random.nextInt(integerMax);

final Random _random = Random.secure();

Uint8List generateRandomBytes([int length = 32]) {
  final values = List<int>.generate(length, (i) => _random.nextInt(256));
  return Uint8List.fromList(values);
}

// ********************************************************************* Kyber Functions *********************************************************************

// This function generates signed last-resort pqkem prekey.
SignedPqkemPreKeyRecord generatePqkemSignedPreKey(
    IdentityKeyPair identityKeyPair, int signedPreKeyId, DilithiumKeyPair dilithiumKeyPair) {
  final keyPair = KyberKEM.generateKyberKeyPair();
  final signature = DilithiumSignatureGenAndVerify.calculateDilithiumSignature(
      dilithiumKeyPair.privateKey, keyPair.publicKey.serialize());

  return SignedPqkemPreKeyRecord(signedPreKeyId,
      Int64(DateTime.now().millisecondsSinceEpoch), keyPair, signature);
}


// This function generates set of signed one time pqkem prekeys.
List<PqkemPreKeyRecord> generatePqkemPreKeys(int start, int count, IdentityKeyPair identityKeyPair, DilithiumKeyPair dilithiumKeyPair) {
  final results = <PqkemPreKeyRecord>[];
  // ignore: parameter_assignments
  start--;
  for (var i = 0; i < count; i++) {
    final keypair = KyberKEM.generateKyberKeyPair();
    final signature = DilithiumSignatureGenAndVerify.calculateDilithiumSignature(dilithiumKeyPair.privateKey, keypair.publicKey.serialize());
    results.add(PqkemPreKeyRecord(
        ((start + i).remainder(maxValue - 1)) + 1, Int64(DateTime.now().millisecondsSinceEpoch), keypair, signature));
  }
  return results;
}

// This function generates a signature key which will replace identity key.
DilithiumKeyPair generateDilithiumSigningKey() {
  final keypair = DilithiumSignatureGenAndVerify.generateDilithiumKeyPair();
  return keypair;
}