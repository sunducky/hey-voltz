// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      firstname: json['firstname'] as String?,
      lastname: json['lastname'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'firstname': instance.firstname,
      'lastname': instance.lastname,
      'email': instance.email,
      'phone': instance.phone,
    };

Station _$StationFromJson(Map<String, dynamic> json) => Station(
      json['address'] as String,
      json['name'] as String,
      Coordinates.fromJson(json['coordinates'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StationToJson(Station instance) => <String, dynamic>{
      'address': instance.address,
      'name': instance.name,
      'coordinates': instance.coordinates,
    };

Favorite _$FavoriteFromJson(Map<String, dynamic> json) => Favorite(
      json['id'] as int,
      Station.fromJson(json['station'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FavoriteToJson(Favorite instance) => <String, dynamic>{
      'id': instance.id,
      'station': instance.station,
    };

Coordinates _$CoordinatesFromJson(Map<String, dynamic> json) => Coordinates(
      (json['lat'] as num).toDouble(),
      (json['lon'] as num).toDouble(),
    );

Map<String, dynamic> _$CoordinatesToJson(Coordinates instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lon': instance.lon,
    };
