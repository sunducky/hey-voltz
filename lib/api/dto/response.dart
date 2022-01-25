import 'package:hey_voltz/api/dto/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable()
class ResponseLogin {
  // @JsonKey()
  User? user;

  @JsonKey()
  String? token;

  ResponseLogin({
    this.user,
    this.token,
  });

  factory ResponseLogin.fromJson(Map<String, dynamic> json) =>
      _$ResponseLoginFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseLoginToJson(this);
}

@JsonSerializable()
class ResponseSignup {
  @JsonKey()
  User? user;

  @JsonKey()
  String? token;

  ResponseSignup({
    this.user,
    this.token,
  });

  factory ResponseSignup.fromJson(Map<String, dynamic> json) =>
      _$ResponseSignupFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseSignupToJson(this);
}

@JsonSerializable()
class ResponseFetchStations {
  @JsonKey()
  List<Station> stations;

  ResponseFetchStations(this.stations);

  factory ResponseFetchStations.fromJson(Map<String, dynamic> json) =>
      _$ResponseFetchStationsFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseFetchStationsToJson(this);
}

@JsonSerializable()
class ResponseFetchFavoriteStations {
  @JsonKey()
  List<Favorite> stations;

  ResponseFetchFavoriteStations(this.stations);

  factory ResponseFetchFavoriteStations.fromJson(Map<String, dynamic> json) =>
      _$ResponseFetchFavoriteStationsFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseFetchFavoriteStationsToJson(this);
}

@JsonSerializable()
class ResponseFetchProducts {
  @JsonKey()
  List<Product> products;

  ResponseFetchProducts(this.products);

  factory ResponseFetchProducts.fromJson(Map<String, dynamic> json) =>
      _$ResponseFetchProductsFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseFetchProductsToJson(this);
}
