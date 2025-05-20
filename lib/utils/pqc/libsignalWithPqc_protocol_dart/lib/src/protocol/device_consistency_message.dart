import 'dart:typed_data';

import 'package:custom_post_quantum/custom_post_quantum.dart';
import 'package:protobuf/protobuf.dart';

import '../devices/device_consistency_commitment.dart';
import '../devices/device_consistency_signature.dart';
import '../ecc/curve.dart';
import '../identity_key.dart';
import '../identity_key_pair.dart';
import '../invalid_key_exception.dart';
import '../invalid_message_exception.dart';
import '../state/whisper_text_protocol.pb.dart';
import 'package:custom_post_quantum/src/algorithms/dilithium/abstractions/dilithiumKeyPair.dart';

class DeviceConsistencyMessage {
  DeviceConsistencyMessage(
      DeviceConsistencyCommitment commitment, IdentityKeyPair identityKeyPair, DilithiumKeyPair dilithiumKeyPair) {
    try {
      final signatureBytes = DilithiumSignatureGenAndVerify.calculateDilithiumVrfSignature(
          dilithiumKeyPair.privateKey, commitment.serialized);
      final vrfOutputBytes = DilithiumSignatureGenAndVerify.verifyDilithiumVrfSignature(
          dilithiumKeyPair.publicKey,
          commitment.serialized,
          signatureBytes);

      _generation = commitment.generation;
      _signature = DeviceConsistencySignature(signatureBytes, vrfOutputBytes);
      final d = DeviceConsistencyCodeMessage.create()
        ..generation = commitment.generation
        ..signature = _signature.signature.toList();
      _serialized = d.writeToBuffer();
    } on InvalidKeyException catch (e) {
      throw AssertionError(e);
    }
//    } on VrfSignatureVerificationFailedException catch (e) {
//    throw AssertionError(e);
//    }
  }

  DeviceConsistencyMessage.fromSerialized(
      DeviceConsistencyCommitment commitment,
      Uint8List serialized,
      IdentityKey identityKey, DilithiumPublicKey dilithiumPublicKey) {
    try {
      final message = DeviceConsistencyCodeMessage.fromBuffer(serialized);
      final vrfOutputBytes = DilithiumSignatureGenAndVerify.verifyDilithiumVrfSignature(dilithiumPublicKey,
          commitment.serialized, Uint8List.fromList(message.signature));

      _generation = message.generation;
      _signature = DeviceConsistencySignature(
          Uint8List.fromList(message.signature), vrfOutputBytes);
      _serialized = serialized;
    } on InvalidProtocolBufferException catch (e) {
      throw InvalidMessageException(e.message);
    } on InvalidKeyException catch (e) {
      throw InvalidMessageException(e.detailMessage);
    }
//    } on VrfSignatureVerificationFailedException catch (e) {
//    throw AssertionError(e);
//    }
  }

  late DeviceConsistencySignature _signature;
  late int _generation;
  late Uint8List _serialized;

  Uint8List get serialized => _serialized;

  DeviceConsistencySignature get signature => _signature;

  int get generation => _generation;
}
