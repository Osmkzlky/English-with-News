// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserData {
  final String id;
  final String name;
  final String surname;
  final String gender;
  final List favoriteNewsId;
  final String email;
  final String phone;
  final int profileImageIndex;
  final int profileColorIndex;
  UserData({
    required this.id,
    required this.name,
    required this.surname,
    required this.gender,
    required this.favoriteNewsId,
    required this.email,
    required this.phone,
    required this.profileImageIndex,
    required this.profileColorIndex,
  });
  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
        id: json["id"] ?? "",
        name: json["name"] ?? "",
        surname: json["surname"] ?? "",
        gender: json["gender"] ?? "",
        email: json["email"] ?? "",
        phone: json["phone"] ?? "",
        profileColorIndex: json["profileColorIndex"] ?? 0,
        profileImageIndex: json["profileImageIndex"] ?? 0,
        favoriteNewsId: json["favoriteNewsId"] ?? []);
  }
}
