import 'package:hey_voltz/api/dto/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> persistToken(String token) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('token', 'Bearer $token');
}

Future<String> fetchPersistedToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token')!;
}

Future<void> persistUserData(User user) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('firstname', user.firstname!);
  prefs.setString('lastname', user.lastname!);
  prefs.setString('email', user.email!);
  prefs.setString('phone', user.phone!);
}

Future<User> fetchUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return User(
    firstname: prefs.getString('firstname'),
    lastname: prefs.getString('lastname'),
    email: prefs.getString('email'),
    phone: prefs.getString('phone'),
  );
}

Future<void> persistLoginCreds(
    {required String email, required String password}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('email', email);
  prefs.setString('password', password);
}

Future<Map<String, String?>> fetchLoginCreds() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return {
    'email': prefs.getString('email'),
    'password': prefs.getString('password'),
  };
}

Future<void> persistLatLng(double latitude, double longitude) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setDouble('latitude', latitude);
  prefs.setDouble('longtitude', longitude);
}

Future<Map<String, double>> fetchPersistedLatLng() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return {
    'latitude': prefs.getDouble('latitude') ?? 0,
    'longitude': prefs.getDouble('longtitude') ?? 0
  };
}

Future<void> clearUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.clear();
}
