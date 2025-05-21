import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qonnect/apis/auth/auth.dart';
import 'package:qonnect/services/auth/registration/auth_events.dart';
import 'package:qonnect/services/auth/registration/auth_state.dart';

class AuthBloc extends Bloc<AuthEvents, AuthState> {
  AuthBloc() : super(LoginInitialState()) {
    on<LoginInitiatedEvent>((event, emit) async {
      emit(LoginLoadingState());
      try {
        await AuthApi()
            .login(event.email, event.password)
            .then((value) {
              log("Login successful from API: ");
              emit(LoginSuccessState('Registration successful!'));
            })
            .onError((error, stackTrace) {
              log("Login failed from API: $error");
              emit(LoginErrorState(error.toString()));
            });
      } catch (e) {
        log("cought in login bloc");
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
