import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hey_voltz/api/api_service.dart';
import 'package:hey_voltz/helpers/prefs.dart';
import 'package:hey_voltz/screens/home/fragments/map/model/direction_model.dart';
import 'package:hey_voltz/screens/home/fragments/map/repository/direction_repository.dart';
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
  Directions? _info;

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
    _info = null;
    Future.delayed(const Duration(seconds: 3)).then((value) {
      if (widget.station != null) {
        fetchStationLocation();
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
        alignment: Alignment.topCenter,
        children: [
          GoogleMap(
            initialCameraPosition: _initialCameraPosition,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            compassEnabled: true,
            myLocationEnabled: true,
            polylines: {
              if (_info != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: colorAccent,
                  width: 5,
                  points: _info!.polylinePoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                )
            },
            onMapCreated: (controller) => _googleMapController = controller,
            markers: _markers,
          ),
          buildDistanceBar(),
          buildTopBar(deviceWidth),
          // buildRescanButton(),
          buildFloatingButton(context, deviceWidth, deviceHeight)
        ],
      );
    }
  }

  buildDistanceBar() {
    if (_info != null) {
      return Positioned(
        top: 20.0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12.0),
          decoration: BoxDecoration(
              color: colorPrimary,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26,
                    offset: Offset(6, 0),
                    blurRadius: 6.0)
              ]),
          child: Text('${_info!.totalDistance}, ${_info!.totalDuration}',
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              )),
        ),
      );
    } else {
      return const SizedBox();
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
            _googleMapController.animateCamera(_info != null
                ? CameraUpdate.newLatLngBounds(_info!.bounds, 100.0)
                : CameraUpdate.newCameraPosition(_initialCameraPosition));
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

  Future<void> fetchStationLocation() async {
    var stationPos = CameraPosition(
        target: LatLng(widget.latitude, widget.longitude), zoom: 17.5);
    _googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(stationPos));
    setState(() {
      flag = true;
    });
  }

  fetchStations() async {
    // make sure to initialize before map loading
    await BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(60, 60)), imgMarker)
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

  showStationInfo(station) async {
    // showBottomSheet(
    //     context: context,

    //     builder: (context) {
    // return buildBottomSheet(deviceWidth,
    //     station: station,
    //     onAddToFavorite: () => addToFavorites(station['id']));
    //     });
    var pos = await fetchPersistedLatLng();
    station['distance'] = (Geolocator.distanceBetween(pos['latitude']!,
                pos['longitude']!, station['lat'], station['lng']) /
            1000)
        .toStringAsFixed(2);
    print('DUCKY -- ' + station['distance']);
    print('DUCKY -- ' + pos.toString());
    print('DUCKY -- pos ' +
        station['lat'].toString() +
        ' ' +
        station['lng'].toString());
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return buildBottomSheet(deviceWidth,
              station: station,
              onDirectionsTap: () => getDirections(station),
              onAddToFavorite: () => addToFavorites(station['id']));
        });
  }

  showSelectedStationInfo(station) async {
    var pos = await fetchPersistedLatLng();
    station['distance'] = (Geolocator.distanceBetween(pos['latitude']!,
                pos['longitude']!, station['lat'], station['lng']) /
            1000)
        .toStringAsFixed(2);
    print('DUCKY -- ' + station['distance']);
    showBottomSheet(
        context: context,
        builder: (context) {
          return buildBottomSheetForDirection(
            deviceWidth,
            station: station,
          );
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

  getDirections(var station) async {
    var pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    //Get Directions
    var origin = LatLng(pos.latitude, pos.longitude);
    var destination = LatLng(station['lat'], station['lng']);

    await DirectionsRepository()
        .getDirections(origin: origin, destination: destination)
        .then((value) {
      setState(() {
        _info = value;
      });
      Navigator.pop(context);
      //TODO animaate camera
      _googleMapController
          .animateCamera(CameraUpdate.newLatLngBounds(_info!.bounds, 100.0));
    }).catchError((err) {
      print('Err -- ' + err.runtimeType.toString());
    });
  }
}
