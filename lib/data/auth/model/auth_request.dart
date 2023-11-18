class RegistrationRequest {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phoneNumber;

  RegistrationRequest({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
    };
  }
}

class LoginRequest {
  final String emailOrPhoneNumber;
  final String password;
  final bool rememberMe;

  LoginRequest({
    required this.emailOrPhoneNumber,
    required this.password,
    required this.rememberMe,
  });

  Map<String, dynamic> toJson() {
    return {
      'emailOrPhoneNumber': emailOrPhoneNumber,
      'password': password,
      'rememberMe': rememberMe,
    };
  }
}

class RefreshRequest {
  final String refresh;

  RefreshRequest({
    required this.refresh,
  });

  Map<String, dynamic> toJson() {
    return {
      'refresh': refresh,
    };
  }
}
