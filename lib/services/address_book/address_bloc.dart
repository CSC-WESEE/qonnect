import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qonnect/apis/address_book/address_book.dart';
import 'package:qonnect/models/address_book/users.dart';
import 'package:qonnect/services/address_book/address_book_events.dart';
import 'package:qonnect/services/address_book/address_book_state.dart';

class AddressBloc extends Bloc<AddressBookEvents, AddressBookState> {
  AddressBloc() : super(AddressBookInitialState()) {
    on<AddressBookFetchEvent>((event, emit) async {
      emit(AddressBookLoadingState());
      try {
        var response = await AddressBookApi().getAddressBookUsers();

        Users users = Users.fromJson(response.data);
        emit(AddressBookLoadedState(users));
      } catch (e) {
        emit(AddressBookErrorState(e.toString()));
      }
    });
  }
}
