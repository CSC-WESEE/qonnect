import 'dart:core';

import '../../identity_key.dart';
import '../../identity_key_pair.dart';
import '../../signal_protocol_address.dart';
import '../identity_key_store.dart';
import '../pre_key_record.dart';
import '../session_record.dart';
import '../signal_protocol_store.dart';
import '../signed_pre_key_record.dart';
import 'in_memory_identity_key_store.dart';
import 'in_memory_pre_key_store.dart';
import 'in_memory_session_store.dart';
import 'in_memory_signed_pre_key_store.dart';

class InMemorySignalProtocolStore implements SignalProtocolStore {
  InMemorySignalProtocolStore(
      IdentityKeyPair identityKeyPair, int registrationId) {
    _identityKeyStore =
        InMemoryIdentityKeyStore(identityKeyPair, registrationId);
  }

  final preKeyStore = InMemoryPreKeyStore();
  final sessionStore = InMemorySessionStore();
  final signedPreKeyStore = InMemorySignedPreKeyStore();

  late IdentityKeyStore _identityKeyStore;

  @override
  Future<IdentityKeyPair> getIdentityKeyPair() async =>
      _identityKeyStore.getIdentityKeyPair();

  @override
  Future<int> getLocalRegistrationId() async =>
      _identityKeyStore.getLocalRegistrationId();

  @override
  Future<bool> saveIdentity(
          SignalProtocolAddress address, IdentityKey? identityKey) async =>
      _identityKeyStore.saveIdentity(address, identityKey);

  @override
  Future<bool> isTrustedIdentity(SignalProtocolAddress address,
          IdentityKey? identityKey, Direction direction) async =>
      _identityKeyStore.isTrustedIdentity(address, identityKey, direction);

  @override
  Future<IdentityKey?> getIdentity(SignalProtocolAddress address) async =>
      _identityKeyStore.getIdentity(address);

  @override
  Future<PreKeyRecord> loadPreKey(int preKeyId) async =>
      preKeyStore.loadPreKey(preKeyId);

  @override
  Future<void> storePreKey(int preKeyId, PreKeyRecord record) async {
    await preKeyStore.storePreKey(preKeyId, record);
  }

  @override
  Future<bool> containsPreKey(int preKeyId) async =>
      preKeyStore.containsPreKey(preKeyId);

  @override
  Future<void> removePreKey(int preKeyId) async {
    await preKeyStore.removePreKey(preKeyId);
  }

  @override
  Future<SessionRecord> loadSession(SignalProtocolAddress address) async =>
      sessionStore.loadSession(address);

  @override
  Future<List<int>> getSubDeviceSessions(String name) async =>
      sessionStore.getSubDeviceSessions(name);

  @override
  Future<void> storeSession(
      SignalProtocolAddress address, SessionRecord record) async {
    await sessionStore.storeSession(address, record);
  }

  @override
  Future<bool> containsSession(SignalProtocolAddress address) async =>
      sessionStore.containsSession(address);

  @override
  Future<void> deleteSession(SignalProtocolAddress address) async {
    await sessionStore.deleteSession(address);
  }

  @override
  Future<void> deleteAllSessions(String name) async {
    await sessionStore.deleteAllSessions(name);
  }

  @override
  Future<SignedPreKeyRecord> loadSignedPreKey(int signedPreKeyId) async =>
      signedPreKeyStore.loadSignedPreKey(signedPreKeyId);

  @override
  Future<List<SignedPreKeyRecord>> loadSignedPreKeys() async =>
      signedPreKeyStore.loadSignedPreKeys();

  @override
  Future<void> storeSignedPreKey(
      int signedPreKeyId, SignedPreKeyRecord record) async {
    await signedPreKeyStore.storeSignedPreKey(signedPreKeyId, record);
  }

  @override
  Future<bool> containsSignedPreKey(int signedPreKeyId) async =>
      signedPreKeyStore.containsSignedPreKey(signedPreKeyId);

  @override
  Future<void> removeSignedPreKey(int signedPreKeyId) async {
    await signedPreKeyStore.removeSignedPreKey(signedPreKeyId);
  }
}


class InMemoryPqkemSignalProtocolStore implements PqSignalProtocolStore {
  InMemoryPqkemSignalProtocolStore(
      IdentityKeyPair identityKeyPair, int registrationId) {
    _identityKeyStore =
        InMemoryIdentityKeyStore(identityKeyPair, registrationId);
  }

  final preKeyStore = InMemoryPreKeyStore();
  final sessionStore = InMemorySessionStore();
  final signedPreKeyStore = InMemorySignedPreKeyStore();

  final pqkemPreKeyStore = InMemoryPqkemPreKeyStore();
  final pqkemSignedPreKeyStore = InMemoryPqkemSignedPreKeyStore();

  late IdentityKeyStore _identityKeyStore;

  @override
  Future<IdentityKeyPair> getIdentityKeyPair() async =>
      _identityKeyStore.getIdentityKeyPair();

  @override
  Future<int> getLocalRegistrationId() async =>
      _identityKeyStore.getLocalRegistrationId();

  @override
  Future<bool> saveIdentity(
          SignalProtocolAddress address, IdentityKey? identityKey) async =>
      _identityKeyStore.saveIdentity(address, identityKey);

  @override
  Future<bool> isTrustedIdentity(SignalProtocolAddress address,
          IdentityKey? identityKey, Direction direction) async =>
      _identityKeyStore.isTrustedIdentity(address, identityKey, direction);

  @override
  Future<IdentityKey?> getIdentity(SignalProtocolAddress address) async =>
      _identityKeyStore.getIdentity(address);

  @override
  Future<PreKeyRecord> loadPreKey(int preKeyId) async =>
      preKeyStore.loadPreKey(preKeyId);

  @override
  Future<void> storePreKey(int preKeyId, PreKeyRecord record) async {
    await preKeyStore.storePreKey(preKeyId, record);
  }

  @override
  Future<bool> containsPreKey(int preKeyId) async =>
      preKeyStore.containsPreKey(preKeyId);

  @override
  Future<void> removePreKey(int preKeyId) async {
    await preKeyStore.removePreKey(preKeyId);
  }

  @override
  Future<SessionRecord> loadSession(SignalProtocolAddress address) async =>
      sessionStore.loadSession(address);

  @override
  Future<List<int>> getSubDeviceSessions(String name) async =>
      sessionStore.getSubDeviceSessions(name);

  @override
  Future<void> storeSession(
      SignalProtocolAddress address, SessionRecord record) async {
    await sessionStore.storeSession(address, record);
  }

  @override
  Future<bool> containsSession(SignalProtocolAddress address) async =>
      sessionStore.containsSession(address);

  @override
  Future<void> deleteSession(SignalProtocolAddress address) async {
    await sessionStore.deleteSession(address);
  }

  @override
  Future<void> deleteAllSessions(String name) async {
    await sessionStore.deleteAllSessions(name);
  }

  @override
  Future<SignedPreKeyRecord> loadSignedPreKey(int signedPreKeyId) async =>
      signedPreKeyStore.loadSignedPreKey(signedPreKeyId);

  @override
  Future<List<SignedPreKeyRecord>> loadSignedPreKeys() async =>
      signedPreKeyStore.loadSignedPreKeys();

  @override
  Future<void> storeSignedPreKey(
      int signedPreKeyId, SignedPreKeyRecord record) async {
    await signedPreKeyStore.storeSignedPreKey(signedPreKeyId, record);
  }

  @override
  Future<bool> containsSignedPreKey(int signedPreKeyId) async =>
      signedPreKeyStore.containsSignedPreKey(signedPreKeyId);

  @override
  Future<void> removeSignedPreKey(int signedPreKeyId) async {
    await signedPreKeyStore.removeSignedPreKey(signedPreKeyId);
  }

  @override
  Future<bool> containsPqkemPreKey(int pqkemPreKeyId) async =>
      pqkemPreKeyStore.containsPqkemPreKey(pqkemPreKeyId);

  @override
  Future<PqkemPreKeyRecord> loadPqkemPreKey(int pqkemPreKeyId) async =>
    pqkemPreKeyStore.loadPqkemPreKey(pqkemPreKeyId);

  @override
  Future<void> storePqkemPreKey(int pqkemPreKeyId, PqkemPreKeyRecord record) async => 
    pqkemPreKeyStore.storePqkemPreKey(pqkemPreKeyId, record);

  @override
  Future<void> removePqkemPreKey(int pqkemPreKeyId) async => 
    pqkemPreKeyStore.removePqkemPreKey(pqkemPreKeyId);

  @override
  Future<SignedPqkemPreKeyRecord> loadPqkemSignedPreKey(int signedPqkemPreKeyId) async =>
    pqkemSignedPreKeyStore.loadPqkemSignedPreKey(signedPqkemPreKeyId);

  @override
  Future<List<SignedPqkemPreKeyRecord>> loadPqkemSignedPreKeys() async =>
    pqkemSignedPreKeyStore.loadPqkemSignedPreKeys();

  @override
  Future<void> storePqkemSignedPreKey(int signedPqkemPreKeyId, SignedPqkemPreKeyRecord record) async =>
    pqkemSignedPreKeyStore.storePqkemSignedPreKey(signedPqkemPreKeyId, record);

  @override
  Future<bool> containsPqkemSignedPreKey(int signedPqkemPreKeyId) async =>
    pqkemSignedPreKeyStore.containsPqkemSignedPreKey(signedPqkemPreKeyId);

  @override
  Future<void> removePqkemSignedPreKey(int signedPqkemPreKeyId) async =>
    pqkemSignedPreKeyStore.removePqkemSignedPreKey(signedPqkemPreKeyId);
}
