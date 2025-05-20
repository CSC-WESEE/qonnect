import 'identity_key_store.dart';
import 'pre_key_store.dart';
import 'session_store.dart';
import 'signed_pre_key_store.dart';

abstract class SignalProtocolStore extends IdentityKeyStore
    with PreKeyStore, SessionStore, SignedPreKeyStore {}

abstract class PqSignalProtocolStore extends IdentityKeyStore
    with PreKeyStore, PqkemPreKeyStore, SessionStore, SignedPreKeyStore, PqkemSignedPreKeyStore {}
