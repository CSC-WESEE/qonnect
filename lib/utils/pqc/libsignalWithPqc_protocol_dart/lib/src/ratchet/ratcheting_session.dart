import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:custom_post_quantum/custom_post_quantum.dart';
import 'package:optional/optional.dart';

import '../ecc/curve.dart';
import '../ecc/ec_key_pair.dart';
import '../ecc/ec_public_key.dart';
import '../kdf/hkdf.dart';
import '../kdf/hkdfv3.dart';
import '../protocol/ciphertext_message.dart';
import '../ratchet/alice_signal_protocol_parameters.dart';
import '../ratchet/bob_signal_protocol_parameters.dart';
import '../ratchet/chain_key.dart';
import '../ratchet/root_key.dart';
import '../ratchet/symmetric_signal_protocol_parameters.dart';
import '../state/session_state.dart';
import '../util/byte_util.dart';

class RatchetingSession {
  static void initializeSession(
      SessionState sessionState, SymmetricSignalProtocolParameters parameters) {
    if (isAlice(parameters.ourBaseKey.publicKey, parameters.theirBaseKey)) {
      final aliceParameters = AliceSignalProtocolParameters(
        ourBaseKey: parameters.ourBaseKey,
        ourIdentityKey: parameters.ourIdentityKey,
        theirRatchetKey: parameters.theirRatchetKey,
        theirIdentityKey: parameters.theirIdentityKey,
        theirSignedPreKey: parameters.theirBaseKey,
        theirOneTimePreKey: const Optional<ECPublicKey>.empty(),
      );
      RatchetingSession.initializeSessionAlice(sessionState, aliceParameters);
    } else {
      final bobParameters = BobSignalProtocolParameters(
        ourIdentityKey: parameters.ourIdentityKey,
        ourRatchetKey: parameters.ourRatchetKey,
        ourSignedPreKey: parameters.ourBaseKey,
        ourOneTimePreKey: const Optional<ECKeyPair>.empty(),
        theirBaseKey: parameters.theirBaseKey,
        theirIdentityKey: parameters.theirIdentityKey,
      );

      RatchetingSession.initializeSessionBob(sessionState, bobParameters);
    }
  }

  static void initializeSessionAlice(
      SessionState sessionState, AliceSignalProtocolParameters parameters) {
    try {
      sessionState
        ..sessionVersion = CiphertextMessage.currentVersion
        ..remoteIdentityKey = parameters.theirIdentityKey
        ..localIdentityKey = parameters.ourIdentityKey.getPublicKey();

      final sendingRatchetKey = Curve.generateKeyPair();
      
      final secrets = <int>[
        ...getDiscontinuityBytes(),
        ...Curve.calculateAgreement(parameters.theirSignedPreKey,
            parameters.ourIdentityKey.getPrivateKey()),
        ...Curve.calculateAgreement(parameters.theirIdentityKey.publicKey,
            parameters.ourBaseKey.privateKey),
        ...Curve.calculateAgreement(
            parameters.theirSignedPreKey, parameters.ourBaseKey.privateKey)
      ];

      print("From Alice side without Kyber: $secrets");

      if (parameters.theirOneTimePreKey.isPresent) {
        secrets.addAll(Curve.calculateAgreement(
            parameters.theirOneTimePreKey.value,
            parameters.ourBaseKey.privateKey));
      }

      final derivedKeys = calculateDerivedKeys(Uint8List.fromList(secrets));
      final sendingChain = derivedKeys
          .getRootKey()
          .createChain(parameters.theirRatchetKey, sendingRatchetKey);

      sessionState
        ..addReceiverChain(
            parameters.theirRatchetKey, derivedKeys.getChainKey())
        ..setSenderChain(sendingRatchetKey, sendingChain.$2)
        ..rootKey = sendingChain.$1;
    } on Exception catch (e) {
      throw AssertionError(e);
    }
  }

  static void initializeSessionBob(
      SessionState sessionState, BobSignalProtocolParameters parameters) {
    try {
      sessionState
        ..sessionVersion = CiphertextMessage.currentVersion
        ..remoteIdentityKey = parameters.theirIdentityKey
        ..localIdentityKey = parameters.ourIdentityKey.getPublicKey();

      final secrets = <int>[
        ...getDiscontinuityBytes(),
        ...Curve.calculateAgreement(parameters.theirIdentityKey.publicKey,
            parameters.ourSignedPreKey.privateKey),
        ...Curve.calculateAgreement(
            parameters.theirBaseKey, parameters.ourIdentityKey.getPrivateKey()),
        ...Curve.calculateAgreement(
            parameters.theirBaseKey, parameters.ourSignedPreKey.privateKey)
      ];
      if (parameters.ourOneTimePreKey.isPresent) {
        secrets.addAll(Curve.calculateAgreement(parameters.theirBaseKey,
            parameters.ourOneTimePreKey.value.privateKey));
      }

      final derivedKeys = calculateDerivedKeys(Uint8List.fromList(secrets));

      sessionState
        ..setSenderChain(parameters.ourRatchetKey, derivedKeys.getChainKey())
        ..rootKey = derivedKeys.getRootKey();
    } on Exception catch (e) {
      throw AssertionError(e);
    }
  }

  static Uint8List getDiscontinuityBytes() {
    final discontinuity = Uint8List(32);
    final len = discontinuity.length;
    for (var i = 0; i < len; i++) {
      discontinuity[i] = 0xFF;
    }
    return discontinuity;
  }

  static DerivedKeys calculateDerivedKeys(Uint8List masterSecret) {
    final HKDF kdf = HKDFv3();
    final bytes = Uint8List.fromList(utf8.encode('WhisperText'));
    final derivedSecretBytes = kdf.deriveSecrets(masterSecret, bytes, 64);
    final derivedSecrets = ByteUtil.splitTwo(derivedSecretBytes, 32, 32);

    return DerivedKeys(
        RootKey(kdf, derivedSecrets[0]), ChainKey(kdf, derivedSecrets[1], 0));
  }

  static bool isAlice(ECPublicKey ourKey, ECPublicKey theirKey) =>
      ourKey.compareTo(theirKey) < 0;
}

class DerivedKeys {
  DerivedKeys(this._rootKey, this._chainKey);

  final RootKey _rootKey;
  final ChainKey _chainKey;

  RootKey getRootKey() => _rootKey;

  ChainKey getChainKey() => _chainKey;
}


class PqkemRatchetingSession {
  static void initializeSession(
      SessionState sessionState, SymmetricPqkemSignalProtocolParameters parameters) {
    if (isAlice(parameters.ourBaseKey.publicKey, parameters.theirBaseKey)) {
      final aliceParameters = AlicePqkemSignalProtocolParameters(
        ourBaseKey: parameters.ourBaseKey,
        ourIdentityKey: parameters.ourIdentityKey,
        theirRatchetKey: parameters.theirRatchetKey,
        theirIdentityKey: parameters.theirIdentityKey,
        theirSignedPreKey: parameters.theirBaseKey,
        theirOneTimePreKey: const Optional<ECPublicKey>.empty(),
        theirPqkemSignedPreKey: parameters.theirPqkemSignedPreKey,
        theirPqkemOneTimeSignedPreKey: parameters.theirPqkemOneTimeSignedPreKey,
      );
      PqkemRatchetingSession.initializePqkemSessionAlice(sessionState, aliceParameters);
    } else {
      final bobParameters = BobPqkemSignalProtocolParameters(
        ourIdentityKey: parameters.ourIdentityKey,
        ourRatchetKey: parameters.ourRatchetKey,
        ourSignedPreKey: parameters.ourBaseKey,
        ourOneTimePreKey: const Optional<ECKeyPair>.empty(),
        theirBaseKey: parameters.theirBaseKey,
        theirIdentityKey: parameters.theirIdentityKey,
        secretCipher: parameters.secretCipher,
        ourPqkemOneTimeSignedPreKey: parameters.ourPqkemOneTimeSignedPreKey,
        ourPqkemSignedPreKey: parameters.ourPqkemSignedPreKey
      );

      PqkemRatchetingSession.initializePqkemSessionBob(sessionState, bobParameters);
    }
  }

  static void initializePqkemSessionAlice(
      SessionState sessionState, AlicePqkemSignalProtocolParameters parameters) {
    try {
      sessionState
        ..sessionVersion = CiphertextMessage.currentVersion
        ..remoteIdentityKey = parameters.theirIdentityKey
        ..localIdentityKey = parameters.ourIdentityKey.getPublicKey();

      final sendingRatchetKey = Curve.generateKeyPair();
      final remotePqkemSignedPreKey = parameters.theirPqkemSignedPreKey;

      print('Check From Alice side(remotePqkemSignedPreKey): ${remotePqkemSignedPreKey.serialize()}');

      final Random rnd = Random.secure();
      final nonce =  Uint8List.fromList(
        List<int>.generate(32, (_) => rnd.nextInt(256)));

      final (cipher, sharedKey) = Kyber.kem512().encapsulate(remotePqkemSignedPreKey, nonce);

      print('Check From Alice side(cipher): ${cipher.serialize()}');
      print('Check From Alice side(sharedKey): ${sharedKey}');

      // final secretsWithoutKyber = <int>[
      //   ...getDiscontinuityBytes(),
      //   ...Curve.calculateAgreement(parameters.theirSignedPreKey,
      //       parameters.ourIdentityKey.getPrivateKey()),
      //   ...Curve.calculateAgreement(parameters.theirIdentityKey.publicKey,
      //       parameters.ourBaseKey.privateKey),
      //   ...Curve.calculateAgreement(
      //       parameters.theirSignedPreKey, parameters.ourBaseKey.privateKey),
      // ];

      final secrets = <int>[
        ...getDiscontinuityBytes(),
        ...Curve.calculateAgreement(parameters.theirSignedPreKey,
            parameters.ourIdentityKey.getPrivateKey()),
        ...Curve.calculateAgreement(parameters.theirIdentityKey.publicKey,
            parameters.ourBaseKey.privateKey),
        ...Curve.calculateAgreement(
            parameters.theirSignedPreKey, parameters.ourBaseKey.privateKey),
        ...sharedKey
      ];

      print('From Alice side with Kyber: ${secrets}');
      
      if (parameters.theirOneTimePreKey.isPresent) {
        secrets.addAll(Curve.calculateAgreement(
            parameters.theirOneTimePreKey.value,
            parameters.ourBaseKey.privateKey));
      }

      final derivedKeys = calculateDerivedKeys(Uint8List.fromList(secrets));
      final sendingChain = derivedKeys
          .getRootKey()
          .createChain(parameters.theirRatchetKey, sendingRatchetKey);

      sessionState
        ..addReceiverChain(
            parameters.theirRatchetKey, derivedKeys.getChainKey())
        ..setSenderChain(sendingRatchetKey, sendingChain.$2)
        ..rootKey = sendingChain.$1
        ..secretCipher = cipher.serialize();
        

      print("Secret cipher from ratcheting_session: ${sessionState.secretCipher}");
    } on Exception catch (e) {
      throw AssertionError(e);
    }
  }

  static void initializePqkemSessionBob(
      SessionState sessionState, BobPqkemSignalProtocolParameters parameters) {
    try {
      sessionState
        ..sessionVersion = CiphertextMessage.currentVersion
        ..remoteIdentityKey = parameters.theirIdentityKey
        ..localIdentityKey = parameters.ourIdentityKey.getPublicKey();

      final ourPqkemSignedPreKey = parameters.ourPqkemSignedPreKey;
      final ourPqkemSignedPreKeyPrivate = ourPqkemSignedPreKey.privateKey;
      // print("Check from Bob side(cipher): ${parameters.secretCipher}");

      final sharedSecret = Kyber.kem512().decapsulate(PKECypher.deserialize(parameters.secretCipher, 2), ourPqkemSignedPreKeyPrivate);

      print('Bob Signed Pre Key Private from ratcheting_session: ${ourPqkemSignedPreKeyPrivate.serialize()}');
      print('Check from Bob side secret: $sharedSecret');

      final secrets = <int>[
        ...getDiscontinuityBytes(),
        ...Curve.calculateAgreement(parameters.theirIdentityKey.publicKey,
            parameters.ourSignedPreKey.privateKey),
        ...Curve.calculateAgreement(
            parameters.theirBaseKey, parameters.ourIdentityKey.getPrivateKey()),
        ...Curve.calculateAgreement(
            parameters.theirBaseKey, parameters.ourSignedPreKey.privateKey),
        ...sharedSecret
      ];

      print("From Bob Side: ${secrets}");
      if (parameters.ourOneTimePreKey.isPresent) {
        secrets.addAll(Curve.calculateAgreement(parameters.theirBaseKey,
            parameters.ourOneTimePreKey.value.privateKey));
      }

      final derivedKeys = calculateDerivedKeys(Uint8List.fromList(secrets));

      sessionState
        ..setSenderChain(parameters.ourRatchetKey, derivedKeys.getChainKey())
        ..rootKey = derivedKeys.getRootKey();
    } on Exception catch (e) {
      throw AssertionError(e);
    }
  }

  static Uint8List getDiscontinuityBytes() {
    final discontinuity = Uint8List(32);
    final len = discontinuity.length;
    for (var i = 0; i < len; i++) {
      discontinuity[i] = 0xFF;
    }
    return discontinuity;
  }

  static DerivedKeys calculateDerivedKeys(Uint8List masterSecret) {
    final HKDF kdf = HKDFv3();
    final bytes = Uint8List.fromList(utf8.encode('WhisperText'));
    final derivedSecretBytes = kdf.deriveSecrets(masterSecret, bytes, 64);
    final derivedSecrets = ByteUtil.splitTwo(derivedSecretBytes, 32, 32);

    return DerivedKeys(
        RootKey(kdf, derivedSecrets[0]), ChainKey(kdf, derivedSecrets[1], 0));
  }

  static bool isAlice(ECPublicKey ourKey, ECPublicKey theirKey) =>
      ourKey.compareTo(theirKey) < 0;
}
