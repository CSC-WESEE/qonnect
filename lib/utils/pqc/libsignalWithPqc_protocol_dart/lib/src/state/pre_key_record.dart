import 'dart:typed_data';
import 'package:custom_post_quantum/custom_post_quantum.dart';
import 'package:fixnum/fixnum.dart';

import '../ecc/curve.dart';
import '../ecc/ec_key_pair.dart';
import '../invalid_key_exception.dart';
import 'local_storage_protocol.pb.dart';
import 'package:custom_post_quantum/src/algorithms/kyber/abstractions/kyberKeyPair.dart';

class PreKeyRecord {
  PreKeyRecord(int id, ECKeyPair keyPair) {
    _structure = PreKeyRecordStructure.create()
      ..id = id
      ..publicKey = keyPair.publicKey.serialize()
      ..privateKey = keyPair.privateKey.serialize()
      ..toBuilder();
  }

  PreKeyRecord.fromBuffer(Uint8List serialized) {
    _structure = PreKeyRecordStructure.fromBuffer(serialized);
  }

  late PreKeyRecordStructure _structure;

  int get id => _structure.id;

  ECKeyPair getKeyPair() {
    try {
      final publicKey =
          Curve.decodePoint(Uint8List.fromList(_structure.publicKey), 0);
      final privateKey =
          Curve.decodePrivatePoint(Uint8List.fromList(_structure.privateKey));
      return ECKeyPair(publicKey, privateKey);
    } on InvalidKeyException catch (e) {
      throw AssertionError(e);
    }
  }

  Uint8List serialize() => _structure.writeToBuffer();
}

class PqkemPreKeyRecord {
  PqkemPreKeyRecord(int id, Int64 timestamp, KEMKeyPair keyPair, Uint8List signature) {
    _structure = PqkemPreKeyRecordStructure.create()
      ..id = id
      ..timestamp = timestamp
      ..publicKey = keyPair.publicKey.serialize()
      ..privateKey = keyPair.privateKey.serialize()
      ..toBuilder();
  }

  PqkemPreKeyRecord.fromBuffer(Uint8List serialized) {
    _structure = PqkemPreKeyRecordStructure.fromBuffer(serialized);
  }

  late PqkemPreKeyRecordStructure _structure;

  int get id => _structure.id;

  KEMKeyPair getKeyPair() {
    try {
      final publicKey =
          KemPublicKey.deserialize(Uint8List.fromList(_structure.publicKey), 2);
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
