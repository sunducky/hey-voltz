import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hey_voltz/api/api_service.dart';
import 'package:hey_voltz/api/dto/models.dart';
import 'package:hey_voltz/helpers/prefs.dart';
import 'package:hey_voltz/screens/auth/components/textfield.dart';
import 'package:hey_voltz/screens/auth/screen_signup.dart';
import 'package:hey_voltz/screens/home/screen_home.dart';
import 'package:hey_voltz/values/colors.dart';
import 'package:hey_voltz/values/drawables.dart';
import 'package:hey_voltz/values/strings.dart';
import 'package:hey_voltz/widgets/button.dart';
import 'package:hey_voltz/widgets/toasty.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //States
  bool isApiLoading = false;

  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: deviceWidth,
              height: 200,
              decoration: const BoxDecoration(
                color: colorPrimary,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25)),
              ),
              child: Center(
                child: SvgPicture.asset(
                  svglogoName,
                  height: 100,
                ),
              ),
            ),
            const SizedBox(height: 45),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Login',
                style: TextStyle(
                  color: colorPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: InputField(
                    label: 'Email address',
                    textInputType: TextInputType.emailAddress,
                    controller: emailController,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: InputField(
                    label: 'Password',
                    controller: passwordController,
                    textInputType: TextInputType.visiblePassword,
                    isPassword: true,
                  ),
                ),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: colorPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ButtonPrimary(
                label: 'Login',
                isLoading: isApiLoading,
                onTap: () => doLogin(),
              ),
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => SignupScreen())),
                child: const Text(
                  'Create an account',
                  style: TextStyle(
                    fontSize: 15,
                    color: colorPrimaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  doLogin() async {
    //Validate Fields
    String email = emailController.text.trim();
    String password = passwordController.text;

    if (!validateFields(email: email, password: password)) return;

    var request = {
      'email': email,
      'password': password,
    };

    setState(() {
      isApiLoading = true;
    });

    await Provider.of<ApiService>(context, listen: false)
        .login(request)
        .then((response) async {
      setState(() {
        isApiLoading = false;
      });
      //ignore: avoid_print
      print(response.statusCode);
      if (!response.isSuccessful) {
        //Error
        if (response.statusCode == 404) {
          Toasty(context).showToastErrorMessage(message: 'Server is down!');
          return;
        }
        Toasty(context)
            .showToastErrorMessage(message: 'Incorrect login credentials!');
        return;
      } else {
        //Code reaches here means success
        User user = User.fromJson(response.body['user']);
        Toasty(context).showToastSuccessMessage(message: 'Login Successful');
        await persistToken(response.body['token']);
        await persistUserData(user);
        await persistLoginCreds(email: email, password: password);
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
      setState(() {
        isApiLoading = false;
      });
    });
  }

  bool validateFields({required String email, required String password}) {
    if (email.isEmpty || !email.contains(emailRegex)) {
      //Error
      Toasty(context).showToastErrorMessage(message: 'Email is invalid');
      return false;
    }
    if (password.isEmpty) {
      //Error
      Toasty(context).showToastErrorMessage(message: 'Password is invalid');
      return false;
    }
    return true;
  }
}
