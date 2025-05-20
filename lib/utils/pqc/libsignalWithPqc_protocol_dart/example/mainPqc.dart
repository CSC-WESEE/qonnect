import 'dart:convert';
import 'dart:typed_data';

import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

Future<void> main() async {
  await test();
}

Future<void> test() async {
  final identityKeyPair = generateIdentityKeyPair();
  final dilithiumKeyPair = generateDilithiumSigningKey();
  final registrationId = generateRegistrationId(false);

  final preKeys = generatePreKeys(0, 5);
  final pqkemSignedOneTimePreKeys = generatePqkemPreKeys(0, 5, identityKeyPair, dilithiumKeyPair);

  final signedPreKey = generateSignedPreKey(identityKeyPair, 0, dilithiumKeyPair);
  final pqkemSignedPreKey = generatePqkemSignedPreKey(identityKeyPair, 0, dilithiumKeyPair);

  // Done till here
  
  final sessionStore = InMemorySessionStore();
  final preKeyStore = InMemoryPreKeyStore();
  final signedPreKeyStore = InMemorySignedPreKeyStore();
  final identityStore =
      InMemoryIdentityKeyStore(identityKeyPair, registrationId);

  final pqkemPreKeyStore = InMemoryPqkemPreKeyStore();
  final pqkemSignedPreKeyStore = InMemoryPqkemSignedPreKeyStore();

  for (final p in preKeys) {
    await preKeyStore.storePreKey(p.id, p);
  }

  await signedPreKeyStore.storeSignedPreKey(signedPreKey.id, signedPreKey);

  for (final p in pqkemSignedOneTimePreKeys) {
    print("Pqkem Signed One Time PreKey Signatures: ${p.signature}");
    print("Pqkem Signed One Time PreKey Id: ${p.id}");
    await pqkemPreKeyStore.storePqkemPreKey(p.id, p);
  }

  await pqkemSignedPreKeyStore.storePqkemSignedPreKey(
      pqkemSignedPreKey.id, pqkemSignedPreKey);

  const bobAddress = SignalProtocolAddress('bob', 1);

  final pqSessionBuilder = PqSessionBuilder(
    sessionStore,
    preKeyStore,
    signedPreKeyStore,
    identityStore,
    pqkemPreKeyStore,
    pqkemSignedPreKeyStore,
    bobAddress,
  );

  // Should get remote from the server
  final remoteRegId = generateRegistrationId(false);
  final remoteIdentityKeyPair = generateIdentityKeyPair();
  final remoteDilithiumKeyPair = generateDilithiumSigningKey();
  final remotePreKeys = generatePreKeys(0, 5);
  final remoteSignedPreKey = generateSignedPreKey(remoteIdentityKeyPair, 0, remoteDilithiumKeyPair);

  final remotePqkemSignedOneTimePreKeys =
      generatePqkemPreKeys(0, 5, remoteIdentityKeyPair, remoteDilithiumKeyPair);
  final remotePqkemSignedPreKey =
      generatePqkemSignedPreKey(remoteIdentityKeyPair, 0, remoteDilithiumKeyPair);
  print("CHECKKKKKKKKKKKKKKKKKKKKKKKKK: ${remotePqkemSignedOneTimePreKeys[0].signature}");

  final retrievedPqkemPreKey = PqkemPreKeyBundle(
    remoteRegId,
    1,
    remotePreKeys[0].id,
    remotePreKeys[0].getKeyPair().publicKey,
    remotePqkemSignedOneTimePreKeys[0].id,
    remotePqkemSignedOneTimePreKeys[0].getKeyPair().publicKey,
    remoteSignedPreKey.id,
    remoteSignedPreKey.getKeyPair().publicKey,
    remotePqkemSignedPreKey.id,
    remotePqkemSignedPreKey.getKeyPair().publicKey,
    remotePqkemSignedPreKey.signature,
    remotePqkemSignedOneTimePreKeys[0].signature,
    remoteSignedPreKey.signature,
    remoteIdentityKeyPair.getPublicKey(),
    remoteDilithiumKeyPair.publicKey,
  );

  await pqSessionBuilder.processPqkemPreKeyBundle(retrievedPqkemPreKey);
  // Done till here

  final pqkemSessionCipher = PqkemSessionCipher(
    sessionStore,
    preKeyStore,
    pqkemPreKeyStore,
    signedPreKeyStore,
    pqkemSignedPreKeyStore,
    identityStore,
    bobAddress,
  );

  final ciphertextWithKyber = await pqkemSessionCipher.encrypt(Uint8List.fromList(utf8.encode('Hello Mixin🤣')));
  print("Ciphertext with Kyber: ${ciphertextWithKyber.serialize()}");


  // Decryption part
  final pqkemSignalProtocolStore = InMemoryPqkemSignalProtocolStore(remoteIdentityKeyPair, 1);
  const aliceAddress = SignalProtocolAddress('alice', 1);
  // Done till here
  
  final pqkemRemoteSessionCipher = PqkemSessionCipher.fromStore(pqkemSignalProtocolStore, aliceAddress);

  for (final p in remotePreKeys) {
    await pqkemSignalProtocolStore.storePreKey(p.id, p);
  }

  for (final p in remotePqkemSignedOneTimePreKeys) {
    await pqkemSignalProtocolStore.storePqkemPreKey(p.id, p);
  }

  await pqkemSignalProtocolStore.storeSignedPreKey(
      remoteSignedPreKey.id, remoteSignedPreKey);

  await pqkemSignalProtocolStore.storePqkemSignedPreKey(remotePqkemSignedPreKey.id, remotePqkemSignedPreKey);

  if (ciphertextWithKyber.getType() == CiphertextMessage.prekeyType) {
    await pqkemRemoteSessionCipher
        .decryptWithCallback(ciphertextWithKyber as PqkemPreKeySignalMessage, (plaintext) {
      // ignore: avoid_print
      print(utf8.decode(plaintext));
    });
  }
}
