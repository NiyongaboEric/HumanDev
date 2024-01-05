import 'package:seymo_pay_mobile_application/data/space/model/space_model.dart';

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

// class CompleteRegistrationRequest {
//   final String firstName;
//   final String? middleName;
//   final String lastName1;

//   final String phoneNumber1;
//   final String phoneNumber2;
//   final String phoneNumber3;

//   final String email1;
//   final String email2;
//   final String email3;

//   final String dateOfBirth;

//   final PersonAddress address;

//   CompleteRegistrationRequest({
//     required this.firstName,
//     required this.lastName1,
//     this.middleName,
//     required this.phoneNumber1,
//     required this.phoneNumber2,
//     required this.phoneNumber3,
//     required this.email1,
//     required this.email2,
//     required this.email3,
//     required this.dateOfBirth,
//     required this.address,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'firstName': firstName,
//       'middleName': middleName,
//       'lastName1': lastName1,
//       'phoneNumber1': phoneNumber1,
//       'phoneNumber2': phoneNumber2,
//       'phoneNumber3': phoneNumber3,
//       'email1': email1,
//       'email2': email2,
//       'email3': email3,
//       'dateOfBirth': dateOfBirth,
//       'address': address,
//     };
//   }
// }

class PersonCompleteRegistrationRequest {
  final String? middleName;
  final String? lastName2;
  final String? phoneNumber2;
  final String? phoneNumber3;
  final String? email2;
  final String? email3;

  final String gender;
  final String dateOfBirth;
  final PersonAddress? address;

  PersonCompleteRegistrationRequest({
    this.lastName2,
    this.middleName,
    this.phoneNumber2,
    this.phoneNumber3,
    this.email2,
    this.email3,
    required this.gender,
    required this.dateOfBirth,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'lastName2': lastName2,
      'middleName': middleName,
      'phoneNumber2': phoneNumber2,
      'phoneNumber3': phoneNumber3,
      'email2': email2,
      'email3': email3,
      'dateOfBirth': dateOfBirth,
      'address': address,
    };
  }
}

class SpaceCompleteRegistrationRequest {
  final String country;
  final String currency;
  final String language;
  final String name;
  final String timezone;

  SpaceCompleteRegistrationRequest({
    required this.country,
    required this.currency,
    required this.language,
    required this.name,
    required this.timezone,
  });

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'currency': currency,
      'language': language,
      'name': name,
      'timezone': timezone,
    };
  }
}

class PersonSpaceRegistrationRequest {
  final PersonCompleteRegistrationRequest person;
  final SpaceCompleteRegistrationRequest space;

  PersonSpaceRegistrationRequest({
    required this.person,
    required this.space,
  });

  Map<String, dynamic> toJson() {
    return {
      'person': person,
      'space': space,
    };
  }
}

class PersonAddress {
  final String? street;
  final String? zip;
  final String? city;
  final String? state;
  final String? country;

  PersonAddress(
    this.street,
    this.zip,
    this.city,
    this.state,
    this.country,
  );

  Map<String, dynamic> toJson() {
    return {
      'street': street,
      'zip': zip,
      'city': city,
      'state': state,
      'country': country,
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
