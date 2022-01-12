import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hey_voltz/api/api_service.dart';
import 'package:hey_voltz/helpers/prefs.dart';
import 'package:hey_voltz/screens/stations/screen_stations.dart';
import 'package:hey_voltz/values/colors.dart';
import 'package:hey_voltz/values/drawables.dart';
import 'package:hey_voltz/widgets/toasty.dart';
import 'package:provider/provider.dart';

import 'components/bottom_sheet.dart';

class MapFragment extends StatefulWidget {
  MapFragment(
      {Key? key,
      required this.context,
      required this.latitude,
      required this.longitude,
      this.station})
      : super(key: key);

  BuildContext context;
  double latitude;
  double longitude;
  Map<String, dynamic>? station;

  @override
  _MapFragmentState createState() => _MapFragmentState();
}

class _MapFragmentState extends State<MapFragment> {
  //MAPS
  Set<Marker> _markers = HashSet<Marker>();
  //STTIONS
  var stations = [];

  var _initialCameraPosition;

  late GoogleMapController _googleMapController;

  int markerID = 1;

  late BitmapDescriptor customIcon;

  bool flag = false;

  double deviceWidth = 0.0;

  @override
  void dispose() {
    // TODO: implement dispose
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchStations();
    fetchCurrentLocation();
    //TODO JUST RUN APP
    //to test the show station dialog info after a delat
    //Hope fully it should be done loading everything on the map and display this
    Future.delayed(const Duration(seconds: 3)).then((value) {
      if (widget.station != null) {
        showStationInfo(widget.station);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    var deviceHeight = MediaQuery.of(context).size.height;
    if (!flag) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            compassEnabled: true,
            myLocationEnabled: true,
            onMapCreated: (controller) => _googleMapController = controller,
            markers: _markers,
          ),
          buildTopBar(deviceWidth),
          // buildRescanButton(),
          buildFloatingButton(context, deviceWidth, deviceHeight)
        ],
      );
    }
  }

  GestureDetector buildRescanButton() {
    return GestureDetector(
      onTap: () => fetchStations(),
      child: Container(
        width: 200,
        height: 50,
        alignment: Alignment.topCenter,
        margin: const EdgeInsets.only(top: 120),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Rescan',
              style: TextStyle(
                color: colorPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 5),
            Icon(
              Icons.refresh_rounded,
              size: 25,
              color: colorPrimary,
            ),
          ],
        ),
      ),
    );
  }

  Align buildFloatingButton(
      BuildContext context, double deviceWidth, double deviceHeight) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: const EdgeInsets.only(right: 20, bottom: 20),
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(2, 2),
                color: Colors.black26,
              ),
            ]),
        child: GestureDetector(
          onTap: () async {
            await fetchCurrentLocation();
            _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(_initialCameraPosition));
          },
          child: const Center(
            child: Icon(
              Icons.my_location_rounded,
              color: Colors.black,
              size: 25,
            ),
          ),
        ),
      ),
    );
  }

  buildTopBar(double width) {
    return Container(
      height: 100,
      width: width,
      color: colorPrimary,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(
              Icons.search_rounded,
              color: Colors.white,
              size: 30,
            ),
            splashRadius: 25,
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => StationsScreen(
                        screenType: StationsScreenType.searchByName))),
          ),
          SvgPicture.asset(
            svgLogo,
            height: 30,
          ),
          IconButton(
            icon: const Icon(
              Icons.star_rounded,
              color: Colors.white,
              size: 30,
            ),
            splashRadius: 25,
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => StationsScreen(
                        screenType: StationsScreenType.favorites))),
          )
        ],
      ),
    );
  }

  Future<void> fetchCurrentLocation() async {
    var pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    _initialCameraPosition =
        CameraPosition(target: LatLng(pos.latitude, pos.longitude), zoom: 17.5);
    await persistLatLng(pos.latitude, pos.longitude);
    setState(() {
      flag = true;
    });
  }

  fetchStations() async {
    // make sure to initialize before map loading
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(100, 100)), imgMarker)
        .then((d) {
      customIcon = d;
    });
    String token = await fetchPersistedToken();
    //ignore: avoid_print
    print('error $token');

    var latlng = await fetchPersistedLatLng();

    await Provider.of<ApiService>(context, listen: false)
        .getStations(
      token,
      lat: latlng['lat'].toString(),
      lng: latlng['lng'].toString(),
    )
        .then((response) {
      print('wee - ${response.bodyString}');
      print('wee - ${response.statusCode}');
      if (!response.isSuccessful) {
        //ignore: avoid_print
        print('Error Code ${response.statusCode}');
        fetchStations();
        return;
        //
        // Toasty(context)
        //     .showToastErrorMessage(message: 'Something happened. restart app');
      } else {
        print('wee - success');
        stations = response.body;
        for (var item in response.body) {
          print(item.toString());
          setState(() {
            _markers.add(Marker(
                markerId: MarkerId('marker_id_$markerID'),
                position: LatLng(item['lat'], item['lng']),
                icon: customIcon,
                infoWindow: InfoWindow(
                  title: item['name'],
                  // snippet: 'Click for more info',
                  onTap: () => showStationInfo(item),
                )));
            markerID++;
          });
        }
      }
    }).catchError((err) {
      print('wee - ${err.runtimeType.toString()}');
      // Navigator.pop(context);
    });
  }

  showStationInfo(station) {
    // showBottomSheet(
    //     context: context,

    //     builder: (context) {
    // return buildBottomSheet(deviceWidth,
    //     station: station,
    //     onAddToFavorite: () => addToFavorites(station['id']));
    //     });
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return buildBottomSheet(deviceWidth,
              station: station,
              onAddToFavorite: () => addToFavorites(station['id']));
        });
  }

  addToFavorites(int id) async {
    String token = await fetchPersistedToken();
    //
    var body = {
      'stationId': id,
    };
    print(body);
    await Provider.of<ApiService>(context, listen: false)
        .addToFavorites(token, body)
        .then((response) {
      if (response.isSuccessful) {
        //ignore:avoid_print
        print('address added successfully');
        Toasty(context).showToastSuccessMessage(message: 'Station saved');
      } else {
        //ignore:avoid_print
        print(response.statusCode);
        Toasty(context)
            .showToastErrorMessage(message: 'Could not save station');
      }
    }).catchError((err) {
      //ignore:avoid_print
      print('Err while addFav -> ' + err.runtimeType.toString());
      Toasty(context).showToastErrorMessage(message: 'Unexpected error');
    });
  }
}
