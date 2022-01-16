import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hey_voltz/helpers/prefs.dart';
// import 'package:hey_voltz/screens/home/fragments/charge/fragment_charge.dart';
// import 'package:hey_voltz/screens/home/fragments/home/fragment_home.dart';
import 'package:hey_voltz/screens/home/fragments/map/fragment_map.dart';
import 'package:hey_voltz/screens/home/fragments/profile/fragment_profile.dart';
import 'package:hey_voltz/values/colors.dart';
import 'package:hey_voltz/values/drawables.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen(
      {Key? key,
      required this.latitude,
      required this.longitude,
      this.screenIndex = 1,
      this.station})
      : super(key: key);

  double latitude;
  double longitude;
  int screenIndex;
  Map<String, dynamic>? station;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int activeIndex = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    activeIndex = widget.screenIndex;
  }

  @override
  Widget build(BuildContext context) {
    var fragments = [
      // HomeFragment(),
      MapFragment(
        context: context,
        latitude: widget.latitude,
        longitude: widget.longitude,
        station: widget.station,
      ),
      // ChargeFragment(),
      ProfileFragment(),
    ];

    return Scaffold(
      bottomNavigationBar: buildBottomNav(),
      body: fragments[activeIndex],
    );
  }

  BottomNavigationBar buildBottomNav() {
    return BottomNavigationBar(
      unselectedItemColor: colorPrimary.withOpacity(.5),
      selectedItemColor: colorPrimary,
      elevation: 2,
      currentIndex: activeIndex,
      onTap: (index) async {
        var pos = await fetchPersistedLatLng();
        setState(() {
          widget.station = null;
          widget.latitude = pos['latitude']!;
          widget.longitude = pos['longitude']!;
          activeIndex = index;
        });
      },
      items: [
        // BottomNavigationBarItem(
        //   label: 'Home',
        //   icon: SvgPicture.asset(svgBottomNavHome,
        //       height: 20, color: colorPrimary.withOpacity(0.5)),
        //   activeIcon: SvgPicture.asset(svgBottomNavHome,
        //       height: 20, color: colorPrimary),
        // ),
        BottomNavigationBarItem(
          label: 'Map',
          icon: SvgPicture.asset(
            svgBottomNavMap,
            height: 20,
            color: colorPrimary.withOpacity(0.5),
          ),
          activeIcon: SvgPicture.asset(svgBottomNavMap,
              height: 20, color: colorPrimary),
        ),
        // BottomNavigationBarItem(
        //   label: 'Charge',
        //   icon: SvgPicture.asset(
        //     svgBottomNavCharge,
        //     height: 20,
        //     color: colorPrimary.withOpacity(0.5),
        //   ),
        //   activeIcon: SvgPicture.asset(svgBottomNavCharge,
        //       height: 20, color: colorPrimary),
        // ),
        BottomNavigationBarItem(
          label: 'Profile',
          icon: SvgPicture.asset(
            svgBottomNavProfile,
            height: 20,
            color: colorPrimary.withOpacity(0.5),
          ),
          activeIcon: SvgPicture.asset(svgBottomNavProfile,
              height: 20, color: colorPrimary),
        )
      ],
    );
  }
}
