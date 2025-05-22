import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qonnect/apis/auth/auth.dart';
import 'package:qonnect/services/auth/auth/auth_events.dart';
import 'package:qonnect/services/auth/auth/auth_state.dart';
import 'package:qonnect/utils/handlers/flutter_secure_storage_handler.dart';

class AuthBloc extends Bloc<AuthEvents, AuthState> {
  AuthBloc() : super(LoginInitialState()) {
    on<LoginInitiatedEvent>((event, emit) async {
      emit(LoginLoadingState());
      try {
        var response = await AuthApi().login(event.email, event.password);
        FlutterSecureStorageHandler flutterSecureStorageHandler =
            FlutterSecureStorageHandler();

        await flutterSecureStorageHandler.secureStorage.write(
          key: 'token',
          value: response.data['token'],
        );

        var token = await flutterSecureStorageHandler.secureStorage.read(
          key: 'token',
        );

        log(token.toString(), name: "Token from AuthBloc");
        log("Login successful from API");

        emit(LoginSuccessState('Login successful!', token.toString()));
      } catch (e) {
        emit(LoginErrorState(e.toString()));
      }
    });

    on<RegistrationInitiatedEvent>((event, emit) async {
      emit(RegistrationLoadingState());
      try {
        await AuthApi().register(event.email, event.password, event.name);
        log("Registration successful from API");
        emit(RegistrationSuccessState('Registration successful!'));
      } catch (e) {
        emit(RegistrationErrorState(e.toString()));
      }
    });
  }
}
