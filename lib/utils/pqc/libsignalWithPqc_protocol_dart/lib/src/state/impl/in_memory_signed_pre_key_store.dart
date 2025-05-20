import 'dart:collection';
import 'dart:typed_data';

import '../../invalid_key_id_exception.dart';
import '../signed_pre_key_record.dart';
import '../signed_pre_key_store.dart';

class InMemorySignedPreKeyStore extends SignedPreKeyStore {
  final store = HashMap<int, Uint8List>();

  @override
  Future<SignedPreKeyRecord> loadSignedPreKey(int signedPreKeyId) async {
    if (!store.containsKey(signedPreKeyId)) {
      throw InvalidKeyIdException(
          'No such signedprekeyrecord! $signedPreKeyId');
    }
    return SignedPreKeyRecord.fromSerialized(store[signedPreKeyId]!);
  }

  @override
  Future<List<SignedPreKeyRecord>> loadSignedPreKeys() async {
    final results = <SignedPreKeyRecord>[];
    for (final serialized in store.values) {
      results.add(SignedPreKeyRecord.fromSerialized(serialized));
    }
    return results;
  }

  @override
  Future<void> storeSignedPreKey(
      int signedPreKeyId, SignedPreKeyRecord record) async {
    store[signedPreKeyId] = record.serialize();
  }

  @override
  Future<void> storeSignedPreKeyDirectly(
      int signedPreKeyId, Uint8List record) async {
    store[signedPreKeyId] = record;
  }

  @override
  Future<bool> containsSignedPreKey(int signedPreKeyId) async =>
      store.containsKey(signedPreKeyId);

  @override
  Future<void> removeSignedPreKey(int signedPreKeyId) async {
    store.remove(signedPreKeyId);
  }
}


class InMemoryPqkemSignedPreKeyStore extends PqkemSignedPreKeyStore {
  final store = HashMap<int, Uint8List>();

  @override
  Future<SignedPqkemPreKeyRecord> loadPqkemSignedPreKey(int signedPqkemPreKeyId) async {
    if (!store.containsKey(signedPqkemPreKeyId)) {
      throw InvalidKeyIdException(
          'No such signedprekeyrecord! $signedPqkemPreKeyId');
    }
    return SignedPqkemPreKeyRecord.fromSerialized(store[signedPqkemPreKeyId]!);
  }

  @override
  Future<List<SignedPqkemPreKeyRecord>> loadPqkemSignedPreKeys() async {
    final results = <SignedPqkemPreKeyRecord>[];
    for (final serialized in store.values) {
      results.add(SignedPqkemPreKeyRecord.fromSerialized(serialized));
    }
    return results;
  }

  @override
  Future<void> storePqkemSignedPreKey(
      int signedPqkemPreKeyId, SignedPqkemPreKeyRecord record) async {
    store[signedPqkemPreKeyId] = record.serialize();
  }

  @override
  Future<bool> containsPqkemSignedPreKey(int signedPqkemPreKeyId) async =>
      store.containsKey(signedPqkemPreKeyId);

  @override
  Future<void> removePqkemSignedPreKey(int signedPqkemPreKeyId) async {
    store.remove(signedPqkemPreKeyId);
  }
}
