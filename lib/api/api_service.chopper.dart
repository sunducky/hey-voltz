// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// ignore_for_file: always_put_control_body_on_new_line, always_specify_types, prefer_const_declarations
class _$ApiService extends ApiService {
  _$ApiService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = ApiService;

  @override
  Future<Response<dynamic>> login(dynamic body) {
    final $url = '/api/login';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> signup(dynamic body) {
    final $url = '/api/register';
    final $body = body;
    final $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getStations(String token,
      {required String lat, required String lng}) {
    final $url = '/api/stations';
    final $params = <String, dynamic>{'lat': lat, 'lng': lng};
    final $headers = {
      'authorization': token,
    };

    final $request = Request('GET', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getStationsForMap(String token) {
    final $url = '/api/stations';
    final $headers = {
      'authorization': token,
    };

    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getFavoriteStations(String token) {
    final $url = '/api/favorites';
    final $headers = {
      'authorization': token,
    };

    final $request = Request('GET', $url, client.baseUrl, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> addToFavorites(String token, dynamic body) {
    final $url = '/api/favorites';
    final $headers = {
      'authorization': token,
    };

    final $body = body;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> deleteFromFavorites(String token, dynamic body) {
    final $url = '/api/favorites';
    final $headers = {
      'authorization': token,
    };

    final $body = body;
    final $request =
        Request('DELETE', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> getStationsByNaame(String token,
      {String? query, required String lat, required String lng}) {
    final $url = '/api/search-stations';
    final $params = <String, dynamic>{'query': query, 'lat': lat, 'lng': lng};
    final $headers = {
      'authorization': token,
    };

    final $request = Request('GET', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> fundWallet(String token, dynamic body) {
    final $url = '/api/wallet';
    final $headers = {
      'authorization': token,
    };

    final $body = body;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> fetchWalletInfo(String token, dynamic body) {
    final $url = '/api/wallet';
    final $headers = {
      'authorization': token,
    };

    final $body = body;
    final $request =
        Request('GET', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> changePassword(String token, dynamic body) {
    final $url = '/api/change-password';
    final $headers = {
      'authorization': token,
    };

    final $body = body;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> fetchProducts(
      String token, dynamic name, dynamic category) {
    final $url = '/api/products';
    final $params = <String, dynamic>{'name': name, 'category': category};
    final $headers = {
      'authorization': token,
    };

    final $request = Request('GET', $url, client.baseUrl,
        parameters: $params, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> placeOrder(String token, dynamic body) {
    final $url = '/api/place-order';
    final $headers = {
      'authorization': token,
    };

    final $body = body;
    final $request =
        Request('POST', $url, client.baseUrl, body: $body, headers: $headers);
    return client.send<dynamic, dynamic>($request);
  }
}
