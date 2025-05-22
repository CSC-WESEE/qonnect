abstract class AuthState {}

class LoginInitialState extends AuthState {}

class LoginLoadingState extends AuthState {}

class LoginSuccessState extends AuthState {
  final String message;
  final String token;
  LoginSuccessState(this.message, this.token);
}

class LoginErrorState extends AuthState {
  final String error;
  LoginErrorState(this.error);
}

class RegistrationInitialState extends AuthState {}

class RegistrationLoadingState extends AuthState {}

class RegistrationSuccessState extends AuthState {
  final String message;
  RegistrationSuccessState(this.message);
}

class RegistrationErrorState extends AuthState {
  final String error;
  RegistrationErrorState(this.error);
}
