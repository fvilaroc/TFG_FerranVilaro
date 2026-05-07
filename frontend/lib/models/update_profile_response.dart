import 'user_profile.dart';

class UpdateProfileResponse {
  final UserProfile user;
  final String token;

  UpdateProfileResponse({
    required this.user,
    required this.token,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    return UpdateProfileResponse(
      user: UserProfile.fromJson(json['user']),
      token: json['newToken'] ?? json['token'] ?? json['access_token'] ?? '',
    );
  }
}