import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qonnect/apis/auth/auth.dart';
import 'package:qonnect/services/auth/registration/auth_events.dart';
import 'package:qonnect/services/auth/registration/auth_state.dart';

class AuthBloc extends Bloc<AuthEvents, AuthState> {
  AuthBloc() : super(LoginInitialState()) {
    on<LoginInitiatedEvent>((event, emit) async {
      emit(LoginLoadingState());
      try {
        AuthApi().login(event.email, event.password);
        emit(LoginSuccessState('Registration successful!'));
      } catch (e) {
        emit(LoginErrorState(e.toString()));
      }
    });

    on<RegistrationInitiatedEvent>((event, emit) async {
      emit(RegistrationLoadingState());
      try {
        AuthApi().register(event.email, event.password, event.name);
        emit(RegistrationSuccessState('Registration successful!'));
      } catch (e) {
        emit(RegistrationErrorState(e.toString()));
      }
    });
  }
}
