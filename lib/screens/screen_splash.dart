import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hey_voltz/api/api_service.dart';
import 'package:hey_voltz/api/dto/models.dart';
import 'package:hey_voltz/helpers/prefs.dart';
import 'package:hey_voltz/screens/auth/screen_login.dart';
import 'package:hey_voltz/screens/home/screen_home.dart';
import 'package:hey_voltz/values/colors.dart';
import 'package:hey_voltz/values/drawables.dart';
import 'package:hey_voltz/widgets/toasty.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkPrefs();
  }

  checkPrefs() async {
    //Request user permission for location
    await Geolocator.requestPermission().catchError((e) {
      SystemNavigator.pop();
    });
    var pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    print(pos);
    await persistLatLng(pos.latitude, pos.longitude);

    var res = await fetchLoginCreds();
    if (res['email'] == null || res['email']!.isEmpty) {
      Future.delayed(const Duration(seconds: 3)).then((value) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
      });
    } else {
      doLogin(res['email']!, res['password']!);
    }
  }

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: colorPrimaryDark,
      body: SafeArea(
          child: Stack(
        children: [
          Center(
            child: SvgPicture.asset(
              svglogoName,
              height: 100,
            ),
          ),
        ],
      )),
    );
  }

  doLogin(String email, String password) async {
    var request = {
      'email': email,
      'password': password,
    };

    await Provider.of<ApiService>(context, listen: false)
        .login(request)
        .then((response) async {
      //ignore: avoid_print
      print(response.statusCode);
      if (!response.isSuccessful) {
        //Error
        if (response.statusCode == 404) {
          Toasty(context).showToastErrorMessage(message: 'Server is down!');
          return;
        }
        print('Splash error --> ${response.statusCode}');

        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
        return;
      } else {
        //Code reaches here means success
        User user = User.fromJson(response.body['user']);
        await persistToken(response.body['token']);
        await persistUserData(user);
        var pos = await fetchPersistedLatLng();

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (_) => HomeScreen(
                      latitude: pos['latitude']!,
                      longitude: pos['longitude']!,
                    )),
            (route) => false);
      }
    }).catchError((err) {
      // ignore: avoid_print
      print('Splash error --> ' + err.runtimeType.toString());
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
    });
  }
}
