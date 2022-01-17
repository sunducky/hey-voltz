import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hey_voltz/api/api_service.dart';
import 'package:hey_voltz/api/dto/models.dart';
import 'package:hey_voltz/api/dto/response.dart';
import 'package:hey_voltz/helpers/prefs.dart';
import 'package:hey_voltz/screens/home/fragments/map/components/list_item_station.dart';
import 'package:hey_voltz/screens/home/screen_home.dart';
import 'package:hey_voltz/values/colors.dart';
import 'package:hey_voltz/values/drawables.dart';
import 'package:hey_voltz/widgets/toasty.dart';
import 'package:provider/provider.dart';

///Screen to display stations(search for stations or favorites)
class StationsScreen extends StatefulWidget {
  StationsScreen({Key? key, required this.screenType}) : super(key: key);

  StationsScreenType screenType;

  @override
  _StationsScreenState createState() => _StationsScreenState();
}

class _StationsScreenState extends State<StationsScreen> {
  String searchQuery = '';

  TextEditingController searchController = TextEditingController();

  var favorites = [];
  var stations = [];

  bool isApiLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.screenType == StationsScreenType.favorites) {
      fetchFavorites();
    } else {
      //do nothing...
    }
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    if (widget.screenType == StationsScreenType.searchByName) {
      return buildSearchByNameBody(deviceWidth);
    } else {
      return buildFavoritesBody(deviceWidth);
    }
  }

  Scaffold buildSearchByNameBody(double deviceWidth) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                color: colorPrimary,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        splashRadius: 25,
                        icon: const Icon(
                          Icons.chevron_left_rounded,
                          color: Colors.white,
                        )),
                    const SizedBox(height: 10),
                    Container(
                      width: deviceWidth,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.streetAddress,
                              maxLines: 1,
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    stations = [];
                                    searchQuery = '';
                                    return;
                                  });
                                } else {
                                  searchQuery = value;
                                  fetchStations();
                                }
                              },
                              onSubmitted: (value) {
                                searchQuery = value;
                                fetchStations();
                              },
                              controller: searchController,
                              decoration: const InputDecoration(
                                hintText: 'Search for station',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            onPressed: () => fetchStations(),
                            icon: const Icon(
                              Icons.search_rounded,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Searching for :',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  searchQuery,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: stations.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HomeScreen(
                              latitude: stations[index]['lat'],
                              longitude: stations[index]['lng'],
                              screenIndex: 0, //This opens up the map fragment
                              station: stations[index],
                            ),
                          )),
                      child: StationListItem(
                          name: stations[index]['name'],
                          address: stations[index]['address'],
                          imageUrl: stations[index]['image'],
                          state: 'Kaduna',
                          country: 'Nigeria',
                          distance: stations[index]['distance']),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }

  Scaffold buildFavoritesBody(double deviceWidth) {
    return Scaffold(
      body: SafeArea(
        child: (isApiLoading)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : (!isApiLoading && favorites.isEmpty)
                ? const Center(
                    child: Text(
                      'There is nothing in your favorites list. Add some.',
                      textAlign: TextAlign.center,
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 15),
                          color: colorPrimary,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  splashRadius: 25,
                                  icon: const Icon(
                                    Icons.chevron_left_rounded,
                                    color: Colors.white,
                                  )),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.only(left: 20),
                                child: const Text(
                                  'Saved Charging\nStations',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: favorites.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                key: Key(favorites[index].toString()),
                                onDismissed: (direction) {
                                  deleteFromFavorites(favorites[index]['id']);
                                },
                                direction: DismissDirection.horizontal,
                                background: deleteBgItem(),
                                child: GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => HomeScreen(
                                          latitude: favorites[index]['station']
                                              ['lat'],
                                          longitude: favorites[index]['station']
                                              ['lng'],
                                          screenIndex:
                                              0, //This opens up the map fragment
                                          station: favorites[index]['station'],
                                        ),
                                      )),
                                  child: StationListItem(
                                      name: favorites[index]['station']['name'],
                                      address: favorites[index]['station']
                                          ['address'],
                                      state: 'Kaduna',
                                      imageUrl:
                                          '${favorites[index]['station']['image']}',
                                      country: 'Nigeria',
                                      distance: favorites[index]['station']
                                          ['distance']),
                                ),
                              );
                            })
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget deleteBgItem() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      color: Colors.red,
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  fetchFavorites() async {
    var token = await fetchPersistedToken();
    var pos = await fetchPersistedLatLng();
    await Provider.of<ApiService>(context, listen: false)
        .getFavoriteStations(token)
        .then((response) {
      print(response.statusCode);
      // print(response.body);
      if (!response.isSuccessful) {
        Toasty(context).showToastErrorMessage(
            message: 'Error fetching stations. Try again.');
        Navigator.pop(context);
      } else {
        //SetState
        for (var item in response.body) {
          print(item.toString());
          item['station']['distance'] = (Geolocator.distanceBetween(
                      pos['latitude']!,
                      pos['longitude']!,
                      item['station']['lat'],
                      item['station']['lng']) /
                  1000)
              .toStringAsFixed(2);
          print('DUCKY -- ' + item['station']['distance']);
          print('DUCKY -- pos ' + pos.toString());
          print('DUCKY -- pos ' +
              item['station']['lat'].toString() +
              ' ' +
              item['station']['lng'].toString());
          favorites.add(item);
        }
        setState(() {
          isApiLoading = false;
        });
      }
    }).catchError((err) {
      print('Fav Error --> ' + err.runtimeType.toString());
      Navigator.pop(context);
    });
  }

  fetchStations() async {
    var token = await fetchPersistedToken();
    var pos = await fetchPersistedLatLng();
    searchQuery = searchController.text.toString();
    var latlng = await fetchPersistedLatLng();
    stations = [];

    await Provider.of<ApiService>(context, listen: false)
        .getStationsByNaame(token,
            lat: latlng['lat'].toString(),
            lng: latlng['lng'].toString(),
            query: searchQuery)
        .then((response) {
      print(response.statusCode);
      if (!response.isSuccessful) {
        Toasty(context).showToastErrorMessage(
            message: 'Error fetching stations. Try again.');
      } else {
        for (var item in response.body) {
          item['distance'] = (Geolocator.distanceBetween(pos['latitude']!,
                      pos['longitude']!, item['lat'], item['lng']) /
                  1000)
              .toStringAsFixed(2);
          stations.add(item);
        }
        setState(() {
          isApiLoading = false;
        });
      }
    }).catchError((err) {
      print('Fav Error --> ' + err.runtimeType.toString());
      Navigator.pop(context);
    });
  }

  deleteFromFavorites(int id) async {
    String token = await fetchPersistedToken();
    var body = {'favoriteId': id};
    await Provider.of<ApiService>(context, listen: false)
        .deleteFromFavorites(token, body)
        .then((response) {
      print(response.statusCode);
      if (response.isSuccessful) {
        //
        print('Deleted succesfully');
      } else {
        if (response.statusCode == 401) {
          deleteFromFavorites(id);
          return;
        } else {
          Toasty(context)
              .showToastErrorMessage(message: 'Could not perfom action!');
        }
      }
    }).catchError((err) {
      print('Error deleting -> ' + err.runtimeType.toString());
      Toasty(context).showToastErrorMessage(message: 'Unexpected error');
    });
  }
}

enum StationsScreenType {
  favorites,
  searchByName,
}
