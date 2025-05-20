import 'dart:typed_data';

import 'package:custom_post_quantum/custom_post_quantum.dart';

import '../ecc/ec_public_key.dart';
import '../identity_key.dart';

class PreKeyBundle {
  PreKeyBundle(
      this._registrationId,
      this._deviceId,
      this._preKeyId,
      this._preKeyPublic,
      this._signedPreKeyId,
      this._signedPreKeyPublic,
      this._signedPreKeySignature,
      this._identityKey);

  final int _registrationId;

  final int _deviceId;

  final int? _preKeyId;
  final ECPublicKey? _preKeyPublic;

  final int _signedPreKeyId;
  final ECPublicKey? _signedPreKeyPublic;
  final Uint8List? _signedPreKeySignature;

  final IdentityKey _identityKey;

  int getDeviceId() => _deviceId;

  int? getPreKeyId() => _preKeyId;

  ECPublicKey? getPreKey() => _preKeyPublic;

  int getSignedPreKeyId() => _signedPreKeyId;

  ECPublicKey? getSignedPreKey() => _signedPreKeyPublic;

  Uint8List? getSignedPreKeySignature() => _signedPreKeySignature;

  IdentityKey getIdentityKey() => _identityKey;

  int getRegistrationId() => _registrationId;
}

class PqkemPreKeyBundle {
  PqkemPreKeyBundle(
      this._registrationId,
      this._deviceId,
      this._preKeyId,
      this._preKeyPublic,
      this._pqkemSignedOneTimePreKeyId,
      this._pqkemSignedOneTimePreKeyPublic,
      this._signedPreKeyId,
      this._signedPreKeyPublic,
      this._pqkemSignedPreKeyId,
      this._pqkemSignedPreKeyPublic,
      this._pqkemSignedPreKeySignature,
      this._pqkemSignedOneTimePreKeySignature,
      this._signedPreKeySignature,
      this._identityKey,
      this._dilithiumPublicKey);

  final int _registrationId;

  final int _deviceId;

  final int? _preKeyId;
  final ECPublicKey? _preKeyPublic;

  final int? _pqkemSignedOneTimePreKeyId;
  final KemPublicKey _pqkemSignedOneTimePreKeyPublic;
  final Uint8List? _pqkemSignedOneTimePreKeySignature;

  final int _signedPreKeyId;
  final ECPublicKey? _signedPreKeyPublic;
  final Uint8List? _signedPreKeySignature;

  final int _pqkemSignedPreKeyId;
  final KemPublicKey _pqkemSignedPreKeyPublic;
  final Uint8List? _pqkemSignedPreKeySignature;

  final IdentityKey _identityKey;

  final DilithiumPublicKey _dilithiumPublicKey;

  int getDeviceId() => _deviceId;

  int? getPreKeyId() => _preKeyId;

  ECPublicKey? getPreKey() => _preKeyPublic;

  int? getPqkemSignedOneTimePreKeyId() => _pqkemSignedOneTimePreKeyId;

  KemPublicKey? getPqkemSignedOneTimePreKey() => _pqkemSignedOneTimePreKeyPublic;

  Uint8List? getPqkemSignedOneTimePreKeySignature() => _pqkemSignedOneTimePreKeySignature;

  int getSignedPreKeyId() => _signedPreKeyId;

  ECPublicKey? getSignedPreKey() => _signedPreKeyPublic;

  Uint8List? getSignedPreKeySignature() => _signedPreKeySignature;

  int getPqkemSignedPreKeyId() => _pqkemSignedPreKeyId;

  KemPublicKey? getPqkemSignedPreKey() => _pqkemSignedPreKeyPublic;

  Uint8List? getPqkemSignedPreKeySignature() => _pqkemSignedPreKeySignature;

  IdentityKey getIdentityKey() => _identityKey;

  DilithiumPublicKey getDilithiumPublicKey() => _dilithiumPublicKey;

  int getRegistrationId() => _registrationId;
}

