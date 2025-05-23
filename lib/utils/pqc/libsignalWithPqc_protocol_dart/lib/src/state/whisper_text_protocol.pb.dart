import 'dart:core' as $core;
import 'dart:core';

import 'package:protobuf/protobuf.dart' as $pb;

class SignalMessage extends $pb.GeneratedMessage {
  factory SignalMessage({
    $core.List<$core.int>? ratchetKey,
    $core.int? counter,
    $core.int? previousCounter,
    $core.List<$core.int>? ciphertext,
  }) {
    final _result = create();
    if (ratchetKey != null) {
      _result.ratchetKey = ratchetKey;
    }
    if (counter != null) {
      _result.counter = counter;
    }
    if (previousCounter != null) {
      _result.previousCounter = previousCounter;
    }
    if (ciphertext != null) {
      _result.ciphertext = ciphertext;
    }
    return _result;
  }

  SignalMessage._() : super();

  factory SignalMessage.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory SignalMessage.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'SignalMessage',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'textsecure'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'ratchetKey',
        $pb.PbFieldType.OY,
        protoName: 'ratchetKey')
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'counter',
        $pb.PbFieldType.OU3)
    ..a<$core.int>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'previousCounter',
        $pb.PbFieldType.OU3,
        protoName: 'previousCounter')
    ..a<$core.List<$core.int>>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'ciphertext',
        $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  @override
  SignalMessage clone() => SignalMessage()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  @override
  SignalMessage copyWith(void Function(SignalMessage) updates) =>
      super.copyWith((message) => updates(message as SignalMessage))
          as SignalMessage; // ignore: deprecated_member_use
  @override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SignalMessage create() => SignalMessage._();

  @override
  SignalMessage createEmptyInstance() => create();

  static $pb.PbList<SignalMessage> createRepeated() =>
      $pb.PbList<SignalMessage>();

  @$core.pragma('dart2js:noInline')
  static SignalMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SignalMessage>(create);
  static SignalMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get ratchetKey => $_getN(0);

  @$pb.TagNumber(1)
  set ratchetKey($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasRatchetKey() => $_has(0);

  @$pb.TagNumber(1)
  void clearRatchetKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get counter => $_getIZ(1);

  @$pb.TagNumber(2)
  set counter($core.int v) {
    $_setUnsignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasCounter() => $_has(1);

  @$pb.TagNumber(2)
  void clearCounter() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get previousCounter => $_getIZ(2);

  @$pb.TagNumber(3)
  set previousCounter($core.int v) {
    $_setUnsignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPreviousCounter() => $_has(2);

  @$pb.TagNumber(3)
  void clearPreviousCounter() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get ciphertext => $_getN(3);

  @$pb.TagNumber(4)
  set ciphertext($core.List<$core.int> v) {
    $_setBytes(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasCiphertext() => $_has(3);

  @$pb.TagNumber(4)
  void clearCiphertext() => clearField(4);
}

class PreKeySignalMessage extends $pb.GeneratedMessage {
  factory PreKeySignalMessage({
    $core.int? preKeyId,
    $core.List<$core.int>? baseKey,
    $core.List<$core.int>? identityKey,
    $core.List<$core.int>? message,
    $core.int? registrationId,
    $core.int? signedPreKeyId,
  }) {
    final _result = create();
    if (preKeyId != null) {
      _result.preKeyId = preKeyId;
    }
    if (baseKey != null) {
      _result.baseKey = baseKey;
    }
    if (identityKey != null) {
      _result.identityKey = identityKey;
    }
    if (message != null) {
      _result.message = message;
    }
    if (registrationId != null) {
      _result.registrationId = registrationId;
    }
    if (signedPreKeyId != null) {
      _result.signedPreKeyId = signedPreKeyId;
    }
    return _result;
  }

  PreKeySignalMessage._() : super();

  factory PreKeySignalMessage.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory PreKeySignalMessage.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PreKeySignalMessage',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'textsecure'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'preKeyId',
        $pb.PbFieldType.OU3,
        protoName: 'preKeyId')
    ..a<$core.List<$core.int>>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'baseKey',
        $pb.PbFieldType.OY,
        protoName: 'baseKey')
    ..a<$core.List<$core.int>>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'identityKey',
        $pb.PbFieldType.OY,
        protoName: 'identityKey')
    ..a<$core.List<$core.int>>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'message',
        $pb.PbFieldType.OY)
    ..a<$core.int>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'registrationId',
        $pb.PbFieldType.OU3,
        protoName: 'registrationId')
    ..a<$core.int>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'signedPreKeyId',
        $pb.PbFieldType.OU3,
        protoName: 'signedPreKeyId')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  @override
  PreKeySignalMessage clone() => PreKeySignalMessage()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  @override
  PreKeySignalMessage copyWith(void Function(PreKeySignalMessage) updates) =>
      super.copyWith((message) => updates(message as PreKeySignalMessage))
          as PreKeySignalMessage; // ignore: deprecated_member_use
  @override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PreKeySignalMessage create() => PreKeySignalMessage._();

  @override
  PreKeySignalMessage createEmptyInstance() => create();

  static $pb.PbList<PreKeySignalMessage> createRepeated() =>
      $pb.PbList<PreKeySignalMessage>();

  @$core.pragma('dart2js:noInline')
  static PreKeySignalMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PreKeySignalMessage>(create);
  static PreKeySignalMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get preKeyId => $_getIZ(0);

  @$pb.TagNumber(1)
  set preKeyId($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPreKeyId() => $_has(0);

  @$pb.TagNumber(1)
  void clearPreKeyId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get baseKey => $_getN(1);

  @$pb.TagNumber(2)
  set baseKey($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasBaseKey() => $_has(1);

  @$pb.TagNumber(2)
  void clearBaseKey() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get identityKey => $_getN(2);

  @$pb.TagNumber(3)
  set identityKey($core.List<$core.int> v) {
    $_setBytes(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasIdentityKey() => $_has(2);

  @$pb.TagNumber(3)
  void clearIdentityKey() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get message => $_getN(3);

  @$pb.TagNumber(4)
  set message($core.List<$core.int> v) {
    $_setBytes(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasMessage() => $_has(3);

  @$pb.TagNumber(4)
  void clearMessage() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get registrationId => $_getIZ(4);

  @$pb.TagNumber(5)
  set registrationId($core.int v) {
    $_setUnsignedInt32(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasRegistrationId() => $_has(4);

  @$pb.TagNumber(5)
  void clearRegistrationId() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get signedPreKeyId => $_getIZ(5);

  @$pb.TagNumber(6)
  set signedPreKeyId($core.int v) {
    $_setUnsignedInt32(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasSignedPreKeyId() => $_has(5);

  @$pb.TagNumber(6)
  void clearSignedPreKeyId() => clearField(6);
}

class KeyExchangeMessage extends $pb.GeneratedMessage {
  factory KeyExchangeMessage({
    $core.int? id,
    $core.List<$core.int>? baseKey,
    $core.List<$core.int>? ratchetKey,
    $core.List<$core.int>? identityKey,
    $core.List<$core.int>? baseKeySignature,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (baseKey != null) {
      _result.baseKey = baseKey;
    }
    if (ratchetKey != null) {
      _result.ratchetKey = ratchetKey;
    }
    if (identityKey != null) {
      _result.identityKey = identityKey;
    }
    if (baseKeySignature != null) {
      _result.baseKeySignature = baseKeySignature;
    }
    return _result;
  }

  KeyExchangeMessage._() : super();

  factory KeyExchangeMessage.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory KeyExchangeMessage.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'KeyExchangeMessage',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'textsecure'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'id',
        $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'baseKey',
        $pb.PbFieldType.OY,
        protoName: 'baseKey')
    ..a<$core.List<$core.int>>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'ratchetKey',
        $pb.PbFieldType.OY,
        protoName: 'ratchetKey')
    ..a<$core.List<$core.int>>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'identityKey',
        $pb.PbFieldType.OY,
        protoName: 'identityKey')
    ..a<$core.List<$core.int>>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'baseKeySignature',
        $pb.PbFieldType.OY,
        protoName: 'baseKeySignature')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  @override
  KeyExchangeMessage clone() => KeyExchangeMessage()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  @override
  KeyExchangeMessage copyWith(void Function(KeyExchangeMessage) updates) =>
      super.copyWith((message) => updates(message as KeyExchangeMessage))
          as KeyExchangeMessage; // ignore: deprecated_member_use

  @override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static KeyExchangeMessage create() => KeyExchangeMessage._();

  @override
  KeyExchangeMessage createEmptyInstance() => create();

  static $pb.PbList<KeyExchangeMessage> createRepeated() =>
      $pb.PbList<KeyExchangeMessage>();

  @$core.pragma('dart2js:noInline')
  static KeyExchangeMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<KeyExchangeMessage>(create);
  static KeyExchangeMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);

  @$pb.TagNumber(1)
  set id($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);

  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get baseKey => $_getN(1);

  @$pb.TagNumber(2)
  set baseKey($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasBaseKey() => $_has(1);

  @$pb.TagNumber(2)
  void clearBaseKey() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get ratchetKey => $_getN(2);

  @$pb.TagNumber(3)
  set ratchetKey($core.List<$core.int> v) {
    $_setBytes(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasRatchetKey() => $_has(2);

  @$pb.TagNumber(3)
  void clearRatchetKey() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get identityKey => $_getN(3);

  @$pb.TagNumber(4)
  set identityKey($core.List<$core.int> v) {
    $_setBytes(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasIdentityKey() => $_has(3);

  @$pb.TagNumber(4)
  void clearIdentityKey() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get baseKeySignature => $_getN(4);

  @$pb.TagNumber(5)
  set baseKeySignature($core.List<$core.int> v) {
    $_setBytes(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasBaseKeySignature() => $_has(4);

  @$pb.TagNumber(5)
  void clearBaseKeySignature() => clearField(5);
}

class SenderKeyMessage extends $pb.GeneratedMessage {
  factory SenderKeyMessage({
    $core.int? id,
    $core.int? iteration,
    $core.List<$core.int>? ciphertext,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (iteration != null) {
      _result.iteration = iteration;
    }
    if (ciphertext != null) {
      _result.ciphertext = ciphertext;
    }
    return _result;
  }

  SenderKeyMessage._() : super();

  factory SenderKeyMessage.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory SenderKeyMessage.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'SenderKeyMessage',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'textsecure'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'id',
        $pb.PbFieldType.OU3)
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'iteration',
        $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'ciphertext',
        $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  @override
  SenderKeyMessage clone() => SenderKeyMessage()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  @override
  SenderKeyMessage copyWith(void Function(SenderKeyMessage) updates) =>
      super.copyWith((message) => updates(message as SenderKeyMessage))
          as SenderKeyMessage; // ignore: deprecated_member_use
  @override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SenderKeyMessage create() => SenderKeyMessage._();

  @override
  SenderKeyMessage createEmptyInstance() => create();

  static $pb.PbList<SenderKeyMessage> createRepeated() =>
      $pb.PbList<SenderKeyMessage>();

  @$core.pragma('dart2js:noInline')
  static SenderKeyMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SenderKeyMessage>(create);
  static SenderKeyMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);

  @$pb.TagNumber(1)
  set id($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);

  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get iteration => $_getIZ(1);

  @$pb.TagNumber(2)
  set iteration($core.int v) {
    $_setUnsignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasIteration() => $_has(1);

  @$pb.TagNumber(2)
  void clearIteration() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get ciphertext => $_getN(2);

  @$pb.TagNumber(3)
  set ciphertext($core.List<$core.int> v) {
    $_setBytes(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasCiphertext() => $_has(2);

  @$pb.TagNumber(3)
  void clearCiphertext() => clearField(3);
}

class SenderKeyDistributionMessage extends $pb.GeneratedMessage {
  factory SenderKeyDistributionMessage({
    $core.int? id,
    $core.int? iteration,
    $core.List<$core.int>? chainKey,
    $core.List<$core.int>? signingKey,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    if (iteration != null) {
      _result.iteration = iteration;
    }
    if (chainKey != null) {
      _result.chainKey = chainKey;
    }
    if (signingKey != null) {
      _result.signingKey = signingKey;
    }
    return _result;
  }

  SenderKeyDistributionMessage._() : super();

  factory SenderKeyDistributionMessage.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory SenderKeyDistributionMessage.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'SenderKeyDistributionMessage',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'textsecure'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'id',
        $pb.PbFieldType.OU3)
    ..a<$core.int>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'iteration',
        $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'chainKey',
        $pb.PbFieldType.OY,
        protoName: 'chainKey')
    ..a<$core.List<$core.int>>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'signingKey',
        $pb.PbFieldType.OY,
        protoName: 'signingKey')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  @override
  SenderKeyDistributionMessage clone() =>
      SenderKeyDistributionMessage()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  @override
  SenderKeyDistributionMessage copyWith(
          void Function(SenderKeyDistributionMessage) updates) =>
      super.copyWith(
              (message) => updates(message as SenderKeyDistributionMessage))
          as SenderKeyDistributionMessage; // ignore: deprecated_member_use
  @override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SenderKeyDistributionMessage create() =>
      SenderKeyDistributionMessage._();

  @override
  SenderKeyDistributionMessage createEmptyInstance() => create();

  static $pb.PbList<SenderKeyDistributionMessage> createRepeated() =>
      $pb.PbList<SenderKeyDistributionMessage>();

  @$core.pragma('dart2js:noInline')
  static SenderKeyDistributionMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SenderKeyDistributionMessage>(create);
  static SenderKeyDistributionMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);

  @$pb.TagNumber(1)
  set id($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);

  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get iteration => $_getIZ(1);

  @$pb.TagNumber(2)
  set iteration($core.int v) {
    $_setUnsignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasIteration() => $_has(1);

  @$pb.TagNumber(2)
  void clearIteration() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get chainKey => $_getN(2);

  @$pb.TagNumber(3)
  set chainKey($core.List<$core.int> v) {
    $_setBytes(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasChainKey() => $_has(2);

  @$pb.TagNumber(3)
  void clearChainKey() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get signingKey => $_getN(3);

  @$pb.TagNumber(4)
  set signingKey($core.List<$core.int> v) {
    $_setBytes(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasSigningKey() => $_has(3);

  @$pb.TagNumber(4)
  void clearSigningKey() => clearField(4);
}

class DeviceConsistencyCodeMessage extends $pb.GeneratedMessage {
  factory DeviceConsistencyCodeMessage({
    $core.int? generation,
    $core.List<$core.int>? signature,
  }) {
    final _result = create();
    if (generation != null) {
      _result.generation = generation;
    }
    if (signature != null) {
      _result.signature = signature;
    }
    return _result;
  }

  DeviceConsistencyCodeMessage._() : super();

  factory DeviceConsistencyCodeMessage.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory DeviceConsistencyCodeMessage.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'DeviceConsistencyCodeMessage',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'textsecure'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'generation',
        $pb.PbFieldType.OU3)
    ..a<$core.List<$core.int>>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'signature',
        $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  @override
  DeviceConsistencyCodeMessage clone() =>
      DeviceConsistencyCodeMessage()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  @override
  DeviceConsistencyCodeMessage copyWith(
          void Function(DeviceConsistencyCodeMessage) updates) =>
      super.copyWith(
              (message) => updates(message as DeviceConsistencyCodeMessage))
          as DeviceConsistencyCodeMessage; // ignore: deprecated_member_use
  @override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeviceConsistencyCodeMessage create() =>
      DeviceConsistencyCodeMessage._();

  @override
  DeviceConsistencyCodeMessage createEmptyInstance() => create();

  static $pb.PbList<DeviceConsistencyCodeMessage> createRepeated() =>
      $pb.PbList<DeviceConsistencyCodeMessage>();

  @$core.pragma('dart2js:noInline')
  static DeviceConsistencyCodeMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeviceConsistencyCodeMessage>(create);
  static DeviceConsistencyCodeMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get generation => $_getIZ(0);

  @$pb.TagNumber(1)
  set generation($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasGeneration() => $_has(0);

  @$pb.TagNumber(1)
  void clearGeneration() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get signature => $_getN(1);

  @$pb.TagNumber(2)
  set signature($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasSignature() => $_has(1);

  @$pb.TagNumber(2)
  void clearSignature() => clearField(2);
}

class PqkemPreKeySignalMessage extends $pb.GeneratedMessage {
  factory PqkemPreKeySignalMessage({
    $core.int? preKeyId,
    $core.List<$core.int>? baseKey,
    $core.List<$core.int>? identityKey,
    $core.List<$core.int>? message,
    $core.int? registrationId,
    $core.int? signedPreKeyId,
    $core.List<$core.int>? secretCipher,
    $core.int? pqkemSignedPreKeyId,
    $core.int? pqkemSignedOneTimePreKeyId,
  }) {
    final _result = create();
    if (preKeyId != null) {
      _result.preKeyId = preKeyId;
    }
    if (baseKey != null) {
      _result.baseKey = baseKey;
    }
    if (identityKey != null) {
      _result.identityKey = identityKey;
    }
    if (message != null) {
      _result.message = message;
    }
    if (registrationId != null) {
      _result.registrationId = registrationId;
    }
    if (signedPreKeyId != null) {
      _result.signedPreKeyId = signedPreKeyId;
    }
    if (secretCipher != null) {
      _result.secretCipher = secretCipher;
    }
    if (pqkemSignedPreKeyId != null) {
      _result.pqkemSignedPreKeyId = pqkemSignedPreKeyId;
    }
    if (pqkemSignedOneTimePreKeyId != null) {
      _result.pqkemSignedOneTimePreKeyId = pqkemSignedOneTimePreKeyId;
    }
    return _result;
  }

  PqkemPreKeySignalMessage._() : super();

  factory PqkemPreKeySignalMessage.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory PqkemPreKeySignalMessage.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'PqkemPreKeySignalMessage',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'textsecure'),
      createEmptyInstance: create)
    ..a<$core.int>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'preKeyId',
        $pb.PbFieldType.OU3,
        protoName: 'preKeyId')
    ..a<$core.List<$core.int>>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'baseKey',
        $pb.PbFieldType.OY,
        protoName: 'baseKey')
    ..a<$core.List<$core.int>>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'identityKey',
        $pb.PbFieldType.OY,
        protoName: 'identityKey')
    ..a<$core.List<$core.int>>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'message',
        $pb.PbFieldType.OY)
    ..a<$core.int>(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'registrationId',
        $pb.PbFieldType.OU3,
        protoName: 'registrationId')
    ..a<$core.int>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'signedPreKeyId',
        $pb.PbFieldType.OU3,
        protoName: 'signedPreKeyId')
    ..a<$core.List<$core.int>>(
        7,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'secretCipher',
        $pb.PbFieldType.OY,
        protoName: 'secretCipher')
    ..a<$core.int>(
        8,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'pqkemSignedPreKeyId',
        $pb.PbFieldType.OU3,
        protoName: 'pqkemSignedPreKeyId')
    ..a<$core.int>(
        9,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'pqkemSignedOneTimePreKeyId',
        $pb.PbFieldType.OU3,
        protoName: 'pqkemSignedOneTimePreKeyId')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  @override
  PqkemPreKeySignalMessage clone() =>
      PqkemPreKeySignalMessage()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  @override
  PqkemPreKeySignalMessage copyWith(
          void Function(PqkemPreKeySignalMessage) updates) =>
      super.copyWith((message) => updates(message as PqkemPreKeySignalMessage))
          as PqkemPreKeySignalMessage; // ignore: deprecated_member_use
  @override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PqkemPreKeySignalMessage create() => PqkemPreKeySignalMessage._();

   @override
  PqkemPreKeySignalMessage createEmptyInstance() => create();

  static $pb.PbList<PqkemPreKeySignalMessage> createRepeated() =>
      $pb.PbList<PqkemPreKeySignalMessage>();

  @$core.pragma('dart2js:noInline')
  static PqkemPreKeySignalMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PqkemPreKeySignalMessage>(create);
  static PqkemPreKeySignalMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get preKeyId => $_getIZ(0);

  @$pb.TagNumber(1)
  set preKeyId($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPreKeyId() => $_has(0);

  @$pb.TagNumber(1)
  void clearPreKeyId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get baseKey => $_getN(1);

  @$pb.TagNumber(2)
  set baseKey($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasBaseKey() => $_has(1);

  @$pb.TagNumber(2)
  void clearBaseKey() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$core.int> get identityKey => $_getN(2);

  @$pb.TagNumber(3)
  set identityKey($core.List<$core.int> v) {
    $_setBytes(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasIdentityKey() => $_has(2);

  @$pb.TagNumber(3)
  void clearIdentityKey() => clearField(3);

  @$pb.TagNumber(4)
  $core.List<$core.int> get message => $_getN(3);

  @$pb.TagNumber(4)
  set message($core.List<$core.int> v) {
    $_setBytes(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasMessage() => $_has(3);

  @$pb.TagNumber(4)
  void clearMessage() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get registrationId => $_getIZ(4);

  @$pb.TagNumber(5)
  set registrationId($core.int v) {
    $_setUnsignedInt32(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasRegistrationId() => $_has(4);

  @$pb.TagNumber(5)
  void clearRegistrationId() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get signedPreKeyId => $_getIZ(5);

  @$pb.TagNumber(6)
  set signedPreKeyId($core.int v) {
    $_setUnsignedInt32(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasSignedPreKeyId() => $_has(5);

  @$pb.TagNumber(6)
  void clearSignedPreKeyId() => clearField(6);

  @$pb.TagNumber(7)
  $core.List<$core.int> get secretCipher => $_getN(6);

  @$pb.TagNumber(7)
  set secretCipher($core.List<$core.int> v) {
    $_setBytes(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasSecretCipher() => $_has(6);

  @$pb.TagNumber(7)
  void clearSecretCipher() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get pqkemSignedPreKeyId => $_getIZ(7);

  @$pb.TagNumber(8)
  set pqkemSignedPreKeyId($core.int v) {
    $_setUnsignedInt32(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasPqkemSignedPreKeyId() => $_has(7);

  @$pb.TagNumber(8)
  void clearPqkemSignedPreKeyId() => clearField(8);

  @$pb.TagNumber(9)
  $core.int get pqkemSignedOneTimePreKeyId => $_getIZ(8);

  @$pb.TagNumber(9)
  set pqkemSignedOneTimePreKeyId($core.int v) {
    $_setUnsignedInt32(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasPqkemSignedOneTimePreKeyId() => $_has(8);

  @$pb.TagNumber(9)
  void clearPqkemSignedOneTimePreKeyId() => clearField(9);
}
