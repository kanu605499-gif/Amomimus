import 'dart:convert';

class UserCredentialsModel {
  final int? id;
  final String? fullName;
  final String? email;
  final String? favoriteCharacter;
  final String? password;
  final String? lastFavCharEditDate;

  UserCredentialsModel({
    this.id,
    this.fullName,
    this.email,
    this.favoriteCharacter,
    this.password,
    this.lastFavCharEditDate,
  });

  factory UserCredentialsModel.fromMap(Map<String, dynamic> map) => UserCredentialsModel(
    id: map['id'] as int?,
    fullName: map['full_name'] as String?,
    email: map['email'] as String?,
    favoriteCharacter: map['favorite_character'] as String?,
    password: map['password'] as String?,
    lastFavCharEditDate: map['last_fav_char_edit_date'] as String?,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      'full_name': fullName,
      'email': email,
      'favorite_character': favoriteCharacter,
      'password': password,
      'last_fav_char_edit_date': lastFavCharEditDate,
    };
  }

  String toJson() => json.encode(toMap());

  factory UserCredentialsModel.fromJson(String source) =>
      UserCredentialsModel.fromMap(json.decode(source) as Map<String, dynamic>);

  UserCredentialsModel copyWith({
    int? id,
    String? fullName,
    String? email,
    String? phoneNumber,
    String? favoriteCharacter,
    String? password,
    String? lastFavCharEditDate,
  }) {
    return UserCredentialsModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      favoriteCharacter: favoriteCharacter ?? this.favoriteCharacter,
      password: password ?? this.password,
      lastFavCharEditDate: lastFavCharEditDate ?? this.lastFavCharEditDate,
    );
  }
}
