import 'pre_key_record.dart';

abstract mixin class PreKeyStore {
  Future<PreKeyRecord> loadPreKey(
      int preKeyId); //  throws InvalidKeyIdException;

  Future<void> storePreKey(int preKeyId, PreKeyRecord record);

  Future<bool> containsPreKey(int preKeyId);

  Future<void> removePreKey(int preKeyId);
}

abstract mixin class PqkemPreKeyStore {
  Future<PqkemPreKeyRecord> loadPqkemPreKey(
      int pqkemPreKeyId); //  throws InvalidKeyIdException;

  Future<void> storePqkemPreKey(int pqkemPreKeyId, PqkemPreKeyRecord record);

  Future<bool> containsPqkemPreKey(int pqkemPreKeyId);

  Future<void> removePqkemPreKey(int pqkemPreKeyId);
}
