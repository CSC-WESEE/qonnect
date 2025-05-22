import 'package:qonnect/models/address_book/users.dart';

abstract class AddressBookState {}

class AddressBookInitialState extends AddressBookState {}

class AddressBookLoadingState extends AddressBookState {}


class AddressBookLoadedState extends AddressBookState {
  final Users users;

  AddressBookLoadedState(this.users);
}

class AddressBookErrorState extends AddressBookState {
  final String error;

  AddressBookErrorState(this.error);
}