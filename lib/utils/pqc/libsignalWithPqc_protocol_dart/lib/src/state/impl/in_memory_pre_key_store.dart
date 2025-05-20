import 'dart:collection';
import 'dart:typed_data';

import '../../invalid_key_id_exception.dart';
import '../pre_key_record.dart';
import '../pre_key_store.dart';

class InMemoryPreKeyStore extends PreKeyStore {
  final store = HashMap<int, Uint8List>();

  @override
  Future<bool> containsPreKey(int preKeyId) async =>
      store.containsKey(preKeyId);

  @override
  Future<PreKeyRecord> loadPreKey(int preKeyId) async {
    if (!store.containsKey(preKeyId)) {
      throw InvalidKeyIdException('No such prekeyrecord! - $preKeyId');
    }
    return PreKeyRecord.fromBuffer(store[preKeyId]!);
  }

  @override
  Future<void> removePreKey(int preKeyId) async {
    store.remove(preKeyId);
  }

  @override
  Future<void> storePreKey(int preKeyId, PreKeyRecord record) async {
    store[preKeyId] = record.serialize();
  }

  // @override
  // Future<void> storePreKey(int preKeyId, Uint8List record) async {
  //   store[preKeyId] = record;
  // }
}

class InMemoryPqkemPreKeyStore extends PqkemPreKeyStore {
  final store = HashMap<int, Uint8List>();

  @override
  Future<bool> containsPqkemPreKey(int pqkemPreKeyId) async =>
      store.containsKey(pqkemPreKeyId);

  @override
  Future<PqkemPreKeyRecord> loadPqkemPreKey(int pqkemPreKeyId) async {
    if (!store.containsKey(pqkemPreKeyId)) {
      throw InvalidKeyIdException('No such prekeyrecord! - $pqkemPreKeyId');
    }
    return PqkemPreKeyRecord.fromBuffer(store[pqkemPreKeyId]!);
  }

  @override
  Future<void> removePqkemPreKey(int pqkemPreKeyId) async {
    store.remove(pqkemPreKeyId);
  }

  @override
  Future<void> storePqkemPreKey(int pqkemPreKeyId, PqkemPreKeyRecord record) async {
    store[pqkemPreKeyId] = record.serialize();
  }
}
