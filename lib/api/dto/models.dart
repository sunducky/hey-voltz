import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
class User {
  @JsonKey()
  String? firstname;
  @JsonKey()
  String? lastname;
  @JsonKey()
  String? email;
  @JsonKey()
  String? phone;
  @JsonKey(name: 'referral_code')
  String? referralCode;
  @JsonKey(name: 'wallet_balance')
  double? walletBalance;

  User(
      {this.firstname,
      this.lastname,
      this.email,
      this.phone,
      this.referralCode,
      this.walletBalance});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Station {
  String address;
  String name;
  Coordinates coordinates;

  Station(this.address, this.name, this.coordinates);

  factory Station.fromJson(Map<String, dynamic> json) =>
      _$StationFromJson(json);
  Map<String, dynamic> toJson() => _$StationToJson(this);
}

@JsonSerializable()
class Favorite {
  int id;
  Station station;

  Favorite(this.id, this.station);

  factory Favorite.fromJson(Map<String, dynamic> json) =>
      _$FavoriteFromJson(json);
  Map<String, dynamic> toJson() => _$FavoriteToJson(this);
}

@JsonSerializable()
class Coordinates {
  @JsonKey()
  double lat;
  @JsonKey()
  double lon;

  Coordinates(
    this.lat,
    this.lon,
  );

  factory Coordinates.fromJson(Map<String, dynamic> json) =>
      _$CoordinatesFromJson(json);
  Map<String, dynamic> toJson() => _$CoordinatesToJson(this);
}
