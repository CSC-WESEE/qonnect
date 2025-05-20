import 'dart:math';
import 'dart:typed_data';

import 'package:custom_post_quantum/custom_post_quantum.dart';
import 'package:custom_post_quantum/src/algorithms/kyber/abstractions/kyberKeyPair.dart';
import 'package:custom_post_quantum/src/algorithms/dilithium/abstractions/dilithiumKeyPair.dart';
import 'package:x25519/x25519.dart' as x25519;

import '../invalid_key_exception.dart';
import '../util/key_helper.dart';
import 'djb_ec_private_key.dart';
import 'djb_ec_public_key.dart';
import 'ec_key_pair.dart';
import 'ec_private_key.dart';
import 'ec_public_key.dart';
import 'ed25519.dart';

typedef KeyPairGenerator = GeneratedKeyPair Function();
typedef AgreementCalculator = Uint8List Function(Uint8List, Uint8List);

class GeneratedKeyPair {
  GeneratedKeyPair(this.private, this.public);

  final Uint8List private;
  final Uint8List public;
}

class Curve {
  static const int djbType = 0x05;

  static KeyPairGenerator? keyPairGenerator;
  static AgreementCalculator? agreementCalculator;

  static ECKeyPair generateKeyPair() {
    final x25519.KeyPair keyPair;
    final generator = keyPairGenerator;
    if (generator != null) {
      final kp = generator();
      keyPair = x25519.KeyPair(privateKey: kp.private, publicKey: kp.public);
    } else {
      keyPair = x25519.generateKeyPair();
    }

    return ECKeyPair(DjbECPublicKey(Uint8List.fromList(keyPair.publicKey)),
        DjbECPrivateKey(Uint8List.fromList(keyPair.privateKey)));
  }

  static ECKeyPair generateKeyPairFromPrivate(List<int> private) {
    if (private.length != 32) {
      throw InvalidKeyException(
          'Invalid private key length: ${private.length}');
    }
    final public = List<int>.filled(32, 0);

    private[0] &= 248;
    private[31] &= 127;
    private[31] |= 64;

    x25519.ScalarBaseMult(public, private);

    return ECKeyPair(DjbECPublicKey(Uint8List.fromList(public)),
        DjbECPrivateKey(Uint8List.fromList(private)));
  }

  static ECPublicKey decodePointList(List<int> bytes, int offset) =>
      decodePoint(Uint8List.fromList(bytes), offset);

  static ECPublicKey decodePoint(Uint8List bytes, int offset) {
    if (bytes.length - offset < 1) {
      throw InvalidKeyException('No key type identifier');
    }

    final type = bytes[offset] & 0xFF;

    switch (type) {
      case Curve.djbType:
        if (bytes.length - offset < 33) {
          throw InvalidKeyException('Bad key length: ${bytes.length}');
        }

        final keyBytes = Uint8List(32);
        arraycopy(bytes, offset + 1, keyBytes, 0, keyBytes.length);
        return DjbECPublicKey(keyBytes);
      default:
        throw InvalidKeyException('Bad key type: $type');
    }
  }

  static void arraycopy(
      List<int> src, int srcPos, List<int> dest, int destPos, int length) {
    dest.setRange(destPos, length + destPos, src, srcPos);
  }

  static ECPrivateKey decodePrivatePoint(Uint8List bytes) =>
      DjbECPrivateKey(bytes);

  static Uint8List calculateAgreement(
      ECPublicKey? publicKey, ECPrivateKey? privateKey) {
    if (publicKey == null) {
      throw Exception('publicKey value is null');
    }

    if (privateKey == null) {
      throw Exception('privateKey value is null');
    }
    if (publicKey.getType() != privateKey.getType()) {
      throw Exception('Public and private keys must be of the same type!');
    }

    if (publicKey.getType() == djbType) {
      final calculator = agreementCalculator;
      if (calculator != null) {
        return calculator(
          (privateKey as DjbECPrivateKey).privateKey,
          (publicKey as DjbECPublicKey).publicKey,
        );
      }

      final secretKey = x25519.X25519(
        List<int>.from((privateKey as DjbECPrivateKey).privateKey),
        List<int>.from((publicKey as DjbECPublicKey).publicKey),
      );
      return secretKey;
    } else {
      throw Exception('Unknown type: ${publicKey.getType()}');
    }
  }

  static bool verifySignature(
      ECPublicKey? signingKey, Uint8List? message, Uint8List? signature) {
    if (signingKey == null || message == null || signature == null) {
      throw InvalidKeyException('Values must not be null');
    }

    if (signingKey.getType() == djbType) {
      if (signature.length != 64) {
        return false;
      }

      final publicKey = (signingKey as DjbECPublicKey).publicKey;
      return verifySig(publicKey, message, signature);
    } else {
      throw InvalidKeyException(
          'Unknown Signing Key type${signingKey.getType()}');
    }
  }

  static Uint8List calculateSignature(
      ECPrivateKey? signingKey, Uint8List? message) {
    if (signingKey == null || message == null) {
      throw Exception('Values must not be null');
    }

    if (signingKey.getType() == djbType) {
      final privateKey = signingKey.serialize();
      final random = generateRandomBytes();

      return sign(privateKey, message, random);
    } else {
      throw Exception('Unknown Signing Key type${signingKey.getType()}');
    }
  }

  static Uint8List calculateVrfSignature(
      ECPrivateKey? signingKey, Uint8List? message) {
    if (signingKey == null || message == null) {
      throw Exception('Values must not be null');
    }

    if (signingKey.getType() == djbType) {
      // TODO
    } else {
      throw Exception('Unknown Signing Key type${signingKey.getType()}');
    }
    return Uint8List(0);
  }

  static Uint8List verifyVrfSignature(
      ECPublicKey? signingKey, Uint8List? message, Uint8List? signature) {
    if (signingKey == null || message == null || signature == null) {
      throw Exception('Values must not be null');
    }

    if (signingKey.getType() == djbType) {
      // TODO
    } else {
      throw Exception('Unknown Signing Key type${signingKey.getType()}');
    }
    return Uint8List(0);
  }
}

// ******************************************************* KYBER FUNCTIONS *******************************************************

// These are defined for Kyber
typedef KyberKeyPairGeneration = KEMKeyPair Function();
typedef KyberAgreementCalculator = Uint8List Function(Uint8List);

class KyberKEM {
  // For Kuber
  static KyberKeyPairGeneration? kyberKeyPairGenerator;
  static KyberAgreementCalculator? kyberAgreementCalculator;

  // Kyber Key Generation
  static KEMKeyPair generateKyberKeyPair() {
    final generator = kyberKeyPairGenerator;
    if (generator != null) {
      final kp = generator();
      return KEMKeyPair(kp.publicKey, kp.privateKey);
    } else {
      final rnd = Random.secure();
      final seed =
          Uint8List.fromList(List<int>.generate(64, (_) => rnd.nextInt(256)));
      final (pk, sk) = Kyber.kem512().generateKeys(seed);
      return KEMKeyPair(pk, sk);
    }
  }

  // This function generates Kyber public key from Kyber private key
  static KEMKeyPair generateKyberKeyPairFromPrivate(List<int> private) {
    if (private.length != 1632) {
      throw InvalidKeyException(
          'Invalid private key length: ${private.length}');
    }

    final public = private.sublist(768, 1568);
    final private1 = private.sublist(0, 768);
    final pkHash = private.sublist(1568, 1600);
    final z = private.sublist(1600, 1632);

    final sk = KemPrivateKey(
      sk: PKEPrivateKey.deserialize(Uint8List.fromList(private1), 2),
      pk: PKEPublicKey.deserialize(Uint8List.fromList(public), 2),
      pkHash: Uint8List.fromList(pkHash),
      z: Uint8List.fromList(z),
    );

    return KEMKeyPair(
        KemPublicKey(
            publicKey: PKEPublicKey.deserialize(Uint8List.fromList(public), 2)),
        sk);
  }

  static void arraycopy(
      List<int> src, int srcPos, List<int> dest, int destPos, int length) {
    dest.setRange(destPos, length + destPos, src, srcPos);
  }

  static Uint8List calculateKyberAgreement(Uint8List? publicKey) {
    if (publicKey == null) {
      throw Exception('publicKey value is null');
    }

    final calculator = kyberAgreementCalculator;
    if (calculator != null) {
      return calculator(publicKey);
    }

    final rnd = Random.secure();
    final nonce =
        Uint8List.fromList(List<int>.generate(32, (_) => rnd.nextInt(256)));
    final (ciphertext, sharedKey) = Kyber.kem512().encapsulate(
        KemPublicKey(publicKey: PKEPublicKey.deserialize(publicKey, 2)), nonce);

    return sharedKey;
  }
}

// ******************************************************* DILITHIUM FUNCTIONS *******************************************************

typedef DilithiumKeyPairGeneration = DilithiumKeyPair Function();

class DilithiumSignatureGenAndVerify {
  static DilithiumKeyPairGeneration? dilithiumKeyPairGenerator;

  // Dilithium Key Generation
  static DilithiumKeyPair generateDilithiumKeyPair() {
    final generator = dilithiumKeyPairGenerator;
    if (generator != null) {
      final kp = generator();
      return DilithiumKeyPair(kp.publicKey, kp.privateKey);
    } else {
      final rnd = Random.secure();
      final seed =
          Uint8List.fromList(List<int>.generate(32, (_) => rnd.nextInt(256)));
      final (pk, sk) = Dilithium.level2().generateKeys(seed);
      return DilithiumKeyPair(pk, sk);
    }
  }

  // Dilithium Signature Verification
  static bool verifyDilithiumSignature(DilithiumPublicKey? signingKey,
      Uint8List? message, Uint8List? signature) {
    if (signingKey == null || message == null || signature == null) {
      throw InvalidKeyException('Values must not be null');
    }

    if (signature.length != 2420) {
      return false;
    }

    final sign = DilithiumSignature.deserialize(signature, 2);
    final isValid = Dilithium.level2().verify(signingKey, message, sign);
    return isValid;
  }

  // Dilithium Signature Generation
  static Uint8List calculateDilithiumSignature(DilithiumPrivateKey? signingKey, Uint8List? message) {
    if (signingKey == null || message == null) {
      throw Exception('Values must not be null');
    }

    final signature = Dilithium.level2().sign(signingKey, message);
    return signature.serialize();
  }

  // Dilithium Vrf Signature Generation
  static Uint8List calculateDilithiumVrfSignature(DilithiumPrivateKey? signingKey, Uint8List? message) {
    if (signingKey == null || message == null) {
      throw Exception('Values must not be null');
    }

    // TODO
    return Uint8List(0);
  }

  // Dilithium Vrf Signature Verification
  static Uint8List verifyDilithiumVrfSignature(DilithiumPublicKey? signingKey, Uint8List? message, Uint8List? signature) {
    if (signingKey == null || message == null || signature == null) {
      throw Exception('Values must not be null');
    }

    // TODO
    return Uint8List(0);
  }
}
