abstract class AuthEvents {}


class LoginInitiatedEvent extends AuthEvents {
  final String email;
  final String password;

  LoginInitiatedEvent({
    required this.email,
    required this.password,
  });
}

class RegistrationInitiatedEvent extends AuthEvents {
  final String email;
  final String password;
  final String name;
  final String phoneNumber;

  RegistrationInitiatedEvent({
    required this.email,
    required this.password,
    required this.name,
    required this.phoneNumber,
  });
}