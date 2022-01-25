// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseLogin _$ResponseLoginFromJson(Map<String, dynamic> json) =>
    ResponseLogin(
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String?,
    );

Map<String, dynamic> _$ResponseLoginToJson(ResponseLogin instance) =>
    <String, dynamic>{
      'user': instance.user,
      'token': instance.token,
    };

ResponseSignup _$ResponseSignupFromJson(Map<String, dynamic> json) =>
    ResponseSignup(
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String?,
    );

Map<String, dynamic> _$ResponseSignupToJson(ResponseSignup instance) =>
    <String, dynamic>{
      'user': instance.user,
      'token': instance.token,
    };

ResponseFetchStations _$ResponseFetchStationsFromJson(
        Map<String, dynamic> json) =>
    ResponseFetchStations(
      (json['stations'] as List<dynamic>)
          .map((e) => Station.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ResponseFetchStationsToJson(
        ResponseFetchStations instance) =>
    <String, dynamic>{
      'stations': instance.stations,
    };

ResponseFetchFavoriteStations _$ResponseFetchFavoriteStationsFromJson(
        Map<String, dynamic> json) =>
    ResponseFetchFavoriteStations(
      (json['stations'] as List<dynamic>)
          .map((e) => Favorite.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ResponseFetchFavoriteStationsToJson(
        ResponseFetchFavoriteStations instance) =>
    <String, dynamic>{
      'stations': instance.stations,
    };

ResponseFetchProducts _$ResponseFetchProductsFromJson(
        Map<String, dynamic> json) =>
    ResponseFetchProducts(
      (json['products'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ResponseFetchProductsToJson(
        ResponseFetchProducts instance) =>
    <String, dynamic>{
      'products': instance.products,
    };
