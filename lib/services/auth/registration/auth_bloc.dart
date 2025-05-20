import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qonnect/services/auth/registration/auth_events.dart';
import 'package:qonnect/services/auth/registration/auth_state.dart';

class AuthBloc extends Bloc<AuthEvents, AuthState> {
  AuthBloc() : super(LoginInitialState()) {
    on<LoginInitiatedEvent>((event, emit) async {
      emit(LoginLoadingState());
      try {
        // Simulate a network call
        // calling the api call here, then giving the response to these below classes.
        await Future.delayed(const Duration(seconds: 1), () {
          log("Login initiated for ${event.email}");
        });
        emit(LoginSuccessState('Registration successful!'));
      } catch (e) {
        emit(LoginErrorState(e.toString()));
      }
    });

    on<RegistrationInitiatedEvent>((event, emit) async {
      emit(RegistrationLoadingState());
      try {
        // Simulate a network call
        // calling the api call here, then giving the response to these below classes.
        await Future.delayed(const Duration(seconds: 2));
        emit(RegistrationSuccessState('Registration successful!'));
      } catch (e) {
        emit(RegistrationErrorState(e.toString()));
      }
    });
  }
}
