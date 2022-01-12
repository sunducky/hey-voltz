import 'package:chopper/chopper.dart';
part 'api_service.chopper.dart';

@ChopperApi(baseUrl: '/api')
abstract class ApiService extends ChopperService {
  //Endpoint for login
  @Post(path: '/login')
  Future<Response> login(
    @Body() body,
  );

  //Endpoint for signup
  @Post(path: '/register')
  Future<Response> signup(
    @Body() body,
  );

  //Endpoint for fetching stations
  @Get(path: '/stations')
  Future<Response> getStations(@Header('authorization') String token,
      {@Query('query') String? query,
      @Query('lat') required String lat,
      @Query('lng') required String lng});

  //Endpoint for fetching favorite stations
  @Get(path: '/favorites')
  Future<Response> getFavoriteStations(
    @Header('authorization') String token,
  );
  //Endpoint for adding a station to favorite
  @Post(path: '/favorites')
  Future<Response> addToFavorites(
    @Header('authorization') String token,
    @Body() body,
  );

  //Endpoint for deleting a station froom favorites
  @Delete(path: '/favorites')
  Future<Response> deleteFromFavorites(
    @Header('authorization') String token,
    @Body() body,
  );

  @Get(path: '/search-stations')
  Future<Response> getStationsByNaame(@Header('authorization') String token,
      {@Query('query') String? query,
      @Query('lat') required String lat,
      @Query('lng') required String lng});

  static ApiService create() {
    final client = ChopperClient(
      baseUrl: 'https://client.mrteey.com',
      services: [
        _$ApiService(),
      ],
      converter: const JsonConverter(),
    );

    return _$ApiService(client);
  }
}
