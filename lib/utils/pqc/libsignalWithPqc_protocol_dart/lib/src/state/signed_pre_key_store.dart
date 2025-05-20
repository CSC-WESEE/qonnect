import 'signed_pre_key_record.dart';

abstract mixin class SignedPreKeyStore {
  Future<SignedPreKeyRecord> loadSignedPreKey(
    int signedPreKeyId,
  ); //throws InvalidKeyIdException;

  Future<List<SignedPreKeyRecord>> loadSignedPreKeys();

  Future<void> storeSignedPreKey(int signedPreKeyId, SignedPreKeyRecord record);

  Future<bool> containsSignedPreKey(int signedPreKeyId);

  Future<void> removeSignedPreKey(int signedPreKeyId);
}

abstract mixin class PqkemSignedPreKeyStore {
  Future<SignedPqkemPreKeyRecord> loadPqkemSignedPreKey(
    int signedPqkemPreKeyId,
  ); //throws InvalidKeyIdException;

  Future<List<SignedPqkemPreKeyRecord>> loadPqkemSignedPreKeys();

  Future<void> storePqkemSignedPreKey(int signedPqkemPreKeyId, SignedPqkemPreKeyRecord record);

  Future<bool> containsPqkemSignedPreKey(int signedPqkemPreKeyId);

  Future<void> removePqkemSignedPreKey(int signedPqkemPreKeyId);
}
