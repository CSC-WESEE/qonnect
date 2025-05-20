// import 'dart:convert';
// import 'dart:typed_data';

// import 'package:custom_post_quantum/custom_post_quantum.dart';
// import 'package:libsignal_protocol_dart/libsignal_protocol_dart.dart';

// Future<void> main() async {
//   await install();
//   // await groupTest();
// }

// Future<void> install() async {
//   final identityKeyPair = generateIdentityKeyPair();
//   final dilithiumKeyPair = DilithiumSignatureGenAndVerify.generateDilithiumKeyPair();
//   final registrationId = generateRegistrationId(false);

//   final preKeys = generatePreKeys(0, 5);
//   final pqkemSignedOneTimePreKeys = generatePqkemPreKeys(0, 5, identityKeyPair, dilithiumKeyPair);

//   final signedPreKey = generateSignedPreKey(identityKeyPair, 0, dilithiumKeyPair);
//   final pqkemSignedPreKey = generatePqkemSignedPreKey(identityKeyPair, 0, dilithiumKeyPair);

//   final sessionStore = InMemorySessionStore();
//   final preKeyStore = InMemoryPreKeyStore();
//   final signedPreKeyStore = InMemorySignedPreKeyStore();
//   final identityStore =
//       InMemoryIdentityKeyStore(identityKeyPair, registrationId);

//   final pqkemPreKeyStore = InMemoryPqkemPreKeyStore();
//   final pqkemSignedPreKeyStore = InMemoryPqkemSignedPreKeyStore();
//   for (final p in preKeys) {
//     await preKeyStore.storePreKey(p.id, p);
//   }

//   await signedPreKeyStore.storeSignedPreKey(signedPreKey.id, signedPreKey);

//   for (final p in pqkemSignedOneTimePreKeys) {
//     await pqkemPreKeyStore.storePqkemPreKey(p.id, p);
//   }

//   await pqkemSignedPreKeyStore.storePqkemSignedPreKey(
//       pqkemSignedPreKey.id, pqkemSignedPreKey);
  
//   const bobAddress = SignalProtocolAddress('bob', 1);

//   final sessionBuilder = SessionBuilder(
//       sessionStore, preKeyStore, signedPreKeyStore, identityStore, bobAddress);


//   final pqSessionBuilder = PqSessionBuilder(
//       sessionStore,
//       preKeyStore,
//       signedPreKeyStore,
//       identityStore,
//       pqkemPreKeyStore,
//       pqkemSignedPreKeyStore,
//       bobAddress);
//   // Should get remote from the server
//   final remoteRegId = generateRegistrationId(false);
//   final remoteIdentityKeyPair = generateIdentityKeyPair();
//   final remotePreKeys = generatePreKeys(0, 5);
//   final remoteSignedPreKey = generateSignedPreKey(remoteIdentityKeyPair, 0);

//   final remotePqkemSignedOneTimePreKeys =
//       generatePqkemPreKeys(0, 5, remoteIdentityKeyPair);
//   final remotePqkemSignedPreKey =
//       generatePqkemSignedPreKey(remoteIdentityKeyPair, 0);

//   final retrievedPreKey = PreKeyBundle(
//       remoteRegId,
//       1,
//       remotePreKeys[0].id,
//       remotePreKeys[0].getKeyPair().publicKey,
//       remoteSignedPreKey.id,
//       remoteSignedPreKey.getKeyPair().publicKey,
//       remoteSignedPreKey.signature,
//       remoteIdentityKeyPair.getPublicKey());

//   final retrievedPqkemPreKey = pqkemPreKeyBundle(
//       remoteRegId,
//       1,
//       remotePreKeys[0].id,
//       remotePreKeys[0].getKeyPair().publicKey,
//       remotePqkemSignedOneTimePreKeys[0].id,
//       remotePqkemSignedOneTimePreKeys[0].getKeyPair().publicKey,
//       remoteSignedPreKey.id,
//       remoteSignedPreKey.getKeyPair().publicKey,
//       remotePqkemSignedPreKey.id,
//       remotePqkemSignedPreKey.getKeyPair().publicKey,
//       remotePqkemSignedPreKey.signature,
//       remotePqkemSignedOneTimePreKeys[0].signature,
//       remoteSignedPreKey.signature,
//       remoteIdentityKeyPair.getPublicKey());


//   await sessionBuilder.processPreKeyBundle(retrievedPreKey);

//   await pqSessionBuilder.processPqkemPreKeyBundle(retrievedPqkemPreKey);

//   final sessionCipher = SessionCipher(
//       sessionStore, preKeyStore, signedPreKeyStore, identityStore, bobAddress);
//   final ciphertext = await sessionCipher
//       .encrypt(Uint8List.fromList(utf8.encode('Hello Mixin🤣')));
//   // ignore: avoid_print
//   print("Ciphertext without Kyber: ${ciphertext.serialize()}");

//   final pqkemSessionCipher = PqkemSessionCipher(
//     sessionStore,
//     preKeyStore,
//     pqkemPreKeyStore,
//     signedPreKeyStore,
//     pqkemSignedPreKeyStore,
//     identityStore,
//     bobAddress,
//   );

//   final ciphertextWithKyber = await pqkemSessionCipher.encrypt(Uint8List.fromList(utf8.encode('Hello Mixin🤣')));
//   print("Ciphertext with Kyber: ${ciphertextWithKyber.serialize()}");

//   final signalProtocolStore =
//       InMemorySignalProtocolStore(remoteIdentityKeyPair, 1);

//   final pqkemSignalProtocolStore = InMemoryPqkemSignalProtocolStore(remoteIdentityKeyPair, 1);
//   const aliceAddress = SignalProtocolAddress('alice', 1);
//   final remoteSessionCipher =https://hyperledger-fabric.readthedocs.io/en/release-2.5/capabilities_concept.html
//       SessionCipher.fromStore(signalProtocolStore, aliceAddress);

//   final pqkemRemoteSessionCipher = PqkemSessionCipher.fromStore(pqkemSignalProtocolStore, aliceAddress);

//   for (final p in remotePreKeys) {
//     await signalProtocolStore.storePreKey(p.id, p);
//   }

//   for (final p in remotePqkemSignedOneTimePreKeys) {
//     await pqkemSignalProtocolStore.storePqkemPreKey(p.id, p);
//   }


//   await signalProtocolStore.storeSignedPreKey(
//       remoteSignedPreKey.id, remoteSignedPreKey);

//   await pqkemSignalProtocolStore.storePqkemSignedPreKey(remotePqkemSignedPreKey.id, remotePqkemSignedPreKey);

//   if (ciphertextWithKyber.getType() == CiphertextMessage.prekeyType) {
//     await pqkemRemoteSessionCipher
//         .decryptWithCallback(ciphertextWithKyber as PqkemPreKeySignalMessage, (plaintext) {
//       // ignore: avoid_print
//       print(utf8.decode(plaintext));
//     });
//   }

//   if (ciphertext.getType() == CiphertextMessage.prekeyType) {
//     await remoteSessionCipher
//         .decryptWithCallback(ciphertext as PreKeySignalMessage, (plaintext) {
//       // ignore: avoid_print
//       print(utf8.decode(plaintext));
//     });
//   }
// }

// // Future<void> groupTest() async {
// //   const alice = SignalProtocolAddress('+00000000001', 1);
// //   const groupSender = SenderKeyName('Private group', alice);
// //   final aliceStore = InMemorySenderKeyStore();
// //   final bobStore = InMemorySenderKeyStore();

// //   final aliceSessionBuilder = GroupSessionBuilder(aliceStore);
// //   final bobSessionBuilder = GroupSessionBuilder(bobStore);

// //   final aliceGroupCipher = GroupCipher(aliceStore, groupSender);
// //   final bobGroupCipher = GroupCipher(bobStore, groupSender);

// //   final sentAliceDistributionMessage =
// //       await aliceSessionBuilder.create(groupSender);
// //   final receivedAliceDistributionMessage =
// //       SenderKeyDistributionMessageWrapper.fromSerialized(
// //           sentAliceDistributionMessage.serialize());
// //   await bobSessionBuilder.process(
// //       groupSender, receivedAliceDistributionMessage);

// //   final ciphertextFromAlice = await aliceGroupCipher
// //       .encrypt(Uint8List.fromList(utf8.encode('Hello Mixin')));
// //   final plaintextFromAlice = await bobGroupCipher.decrypt(ciphertextFromAlice);
// //   // ignore: avoid_print
// //   print(utf8.decode(plaintextFromAlice));
// // }

// // Future<void> groupSession() async {
// //   const senderKeyName = SenderKeyName('', SignalProtocolAddress('sender', 1));
// //   final senderKeyStore = InMemorySenderKeyStore();
// //   final groupSession = GroupCipher(senderKeyStore, senderKeyName);
// //   await groupSession.encrypt(Uint8List.fromList(utf8.encode('Hello Mixin')));
// // }
