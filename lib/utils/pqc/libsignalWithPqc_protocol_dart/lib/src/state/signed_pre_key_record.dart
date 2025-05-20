import 'dart:typed_data';

import 'package:custom_post_quantum/custom_post_quantum.dart';
import 'package:fixnum/fixnum.dart';
import '../ecc/curve.dart';
import '../ecc/ec_key_pair.dart';
import '../invalid_key_exception.dart';
import 'local_storage_protocol.pb.dart';
import 'package:custom_post_quantum/src/algorithms/kyber/abstractions/kyberKeyPair.dart';

class SignedPreKeyRecord {
  SignedPreKeyRecord(
      int id, Int64 timestamp, ECKeyPair keyPair, Uint8List signature) {
    _structure = SignedPreKeyRecordStructure.create()
      ..id = id
      ..timestamp = timestamp
      ..publicKey = keyPair.publicKey.serialize()
      ..privateKey = keyPair.privateKey.serialize()
      ..signature = signature;
  }

  SignedPreKeyRecord.fromSerialized(Uint8List serialized) {
    _structure = SignedPreKeyRecordStructure.fromBuffer(serialized);
  }

  late SignedPreKeyRecordStructure _structure;

  int get id => _structure.id;

  Int64 get timestamp => _structure.timestamp;

  ECKeyPair getKeyPair() {
    try {
      final publicKey = Curve.decodePointList(_structure.publicKey, 0);
      final privateKey =
          Curve.decodePrivatePoint(Uint8List.fromList(_structure.privateKey));

      return ECKeyPair(publicKey, privateKey);
    } on InvalidKeyException catch (e) {
      throw AssertionError(e);
    }
  }

  Uint8List get signature => Uint8List.fromList(_structure.signature);

  Uint8List serialize() => _structure.writeToBuffer();
}


class SignedPqkemPreKeyRecord {
  SignedPqkemPreKeyRecord(
      int id, Int64 timestamp, KEMKeyPair keyPair, Uint8List signature) {
    _structure = SignedPreKeyRecordStructure.create()
      ..id = id
      ..timestamp = timestamp
      ..publicKey = keyPair.publicKey.serialize()
      ..privateKey = keyPair.privateKey.serialize()
      ..signature = signature;
  }

  SignedPqkemPreKeyRecord.fromSerialized(Uint8List serialized) {
    _structure = SignedPreKeyRecordStructure.fromBuffer(serialized);
  }

  late SignedPreKeyRecordStructure _structure;

  int get id => _structure.id;

  Int64 get timestamp => _structure.timestamp;

  KEMKeyPair getKeyPair() {
    try {
      final publicKey = KemPublicKey.deserialize(Uint8List.fromList(_structure.publicKey), 2);
      final privateKey =
          KemPrivateKey.deserialize(Uint8List.fromList(_structure.privateKey), 2);

      return KEMKeyPair(publicKey, privateKey);
    } on InvalidKeyException catch (e) {
      throw AssertionError(e);
    }
  }

  Uint8List get signature => Uint8List.fromList(_structure.signature);

  Uint8List serialize() => _structure.writeToBuffer();
}
