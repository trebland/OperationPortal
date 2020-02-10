import 'package:basic_front/Structs/Profile.dart';

class RetrieveUser_Success {
  Profile profile;

  RetrieveUser_Success({this.profile});

  factory RetrieveUser_Success.fromJson(Map<String, dynamic> json) {
    return RetrieveUser_Success(
      profile: json['profile'] != null ? Profile.fromJson(json['profile']) : null,
    );
  }
}

class RetrieveUser_Failure {
  String error;

  RetrieveUser_Failure({this.error});

  factory RetrieveUser_Failure.fromJson(Map<String, dynamic> json) {
    return RetrieveUser_Failure(
      error: json['error'],
    );
  }
}

class InitialLogin_Success {
  final String accessToken;
  final String errorDescription;

  InitialLogin_Success({this.accessToken, this.errorDescription});

  factory InitialLogin_Success.fromJson(Map<String, dynamic> json) {
    return InitialLogin_Success(
      accessToken: json['access_token'],
      errorDescription: json['error_description'],
    );
  }
}

class InitialLogin_Failure {
  final String errorDescription;

  InitialLogin_Failure({this.errorDescription});

  factory InitialLogin_Failure.fromJson(Map<String, dynamic> json) {
    return InitialLogin_Failure(
      errorDescription: json['error_description'],
    );
  }
}