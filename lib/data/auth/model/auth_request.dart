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

  // factory RegistrationRequest.fromJson(Map<String, dynamic> json) {
  //   return RegistrationRequest(
  //     email: json['email'],
  //     password: json['password'],
  //     firstName: json['firstName'],
  //     lastName: json['lastName'],
  //     phoneNumber: json['phoneNumber'],
  //   );
  // }

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

  // factory LoginRequest.fromJson(Map<String, dynamic> json) {
  //   return LoginRequest(
  //     email: json['email'],
  //     password: json['password'],
  //     rememberMe: json['rememberMe'],
  //   );
  // }

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

  // factory RefreshRequest.fromJson(Map<String, dynamic> json) {
  //   return RefreshRequest(
  //     refresh: json['email'],
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      'refresh': refresh,
    };
  }
}
