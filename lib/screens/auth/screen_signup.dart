import 'package:flutter/material.dart';
import 'package:hey_voltz/api/api_service.dart';
import 'package:hey_voltz/helpers/prefs.dart';
import 'package:hey_voltz/screens/home/screen_home.dart';
import 'package:hey_voltz/values/colors.dart';
import 'package:hey_voltz/values/strings.dart';
import 'package:hey_voltz/widgets/button.dart';
import 'package:hey_voltz/widgets/toasty.dart';
import 'package:provider/provider.dart';

import 'components/textfield.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController fname = TextEditingController(), //Firstname
      lname = TextEditingController(), //Lastname
      email = TextEditingController(), //Email
      mobile = TextEditingController(), //Phone number
      pswd = TextEditingController(), //Password
      cpswd = TextEditingController(); //Confirm Password

  //States
  bool isApiLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.chevron_left,
                    ),
                    splashRadius: 20,
                  ),
                ),
                const SizedBox(height: 45),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Create an account',
                    style: TextStyle(
                      color: colorPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                InputField(
                  label: 'First Name',
                  textInputType: TextInputType.name,
                  controller: fname,
                ),
                const SizedBox(height: 25),
                InputField(
                  label: 'Last Name',
                  textInputType: TextInputType.name,
                  controller: lname,
                ),
                const SizedBox(height: 25),
                InputField(
                  label: 'Email Address',
                  textInputType: TextInputType.emailAddress,
                  controller: email,
                ),
                const SizedBox(height: 25),
                InputField(
                  label: 'Mobile Number',
                  textInputType: TextInputType.phone,
                  controller: mobile,
                ),
                const SizedBox(height: 25),
                InputField(
                  label: 'Password',
                  textInputType: TextInputType.visiblePassword,
                  controller: pswd,
                  isPassword: true,
                ),
                const SizedBox(height: 25),
                InputField(
                  label: 'Confirm Password',
                  textInputType: TextInputType.visiblePassword,
                  controller: cpswd,
                  isPassword: true,
                ),
                const SizedBox(height: 40),
                ButtonPrimary(
                  label: 'Signup',
                  isLoading: isApiLoading,
                  onTap: () => doSignup(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  doSignup() async {
    String firstname = fname.text.toString().trim();
    String lastname = lname.text.toString().trim();
    String email = this.email.text.toString().trim();
    String phone = mobile.text.toString().trim();
    String password = pswd.text.toString().trim();
    String cPassword = cpswd.text.toString().trim();
    //Validate fields
    if (!validateFields(
        firstname: firstname,
        lastname: lastname,
        email: email,
        phone: phone,
        password: password,
        cPassword: cPassword)) return;

    var request = {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'phone': phone,
      'password': password,
    };

    setState(() {
      isApiLoading = true;
    });

    await Provider.of<ApiService>(context, listen: false)
        .signup(request)
        .then((response) async {
      setState(() {
        isApiLoading = false;
      });
      if (!response.isSuccessful) {
        if (response.statusCode == 404) {
          Toasty(context).showToastErrorMessage(message: 'Server is down');
          return;
        } else {
          Toasty(context).showToastErrorMessage(
              message: 'This email address has been used to create an account');
          return;
        }
      } else {
        Toasty(context)
            .showToastSuccessMessage(message: 'Account Created Successfully');
        await persistToken(response.body['token']);
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

  bool validateFields(
      {required String firstname,
      required String lastname,
      required String email,
      required String phone,
      required String password,
      required String cPassword}) {
    if (firstname.length < 2) {
      //Error
      Toasty(context)
          .showToastErrorMessage(message: 'Firstname cannot be empty');
      return false;
    }
    if (lastname.length < 2) {
      //Error
      Toasty(context)
          .showToastErrorMessage(message: 'Lastname cannot be empty');
      return false;
    }
    if (email.isEmpty || !email.contains(emailRegex)) {
      Toasty(context).showToastErrorMessage(message: 'Email is invalid');
      return false;
    }
    if (phone.isEmpty || phone.length < 10) {
      Toasty(context).showToastErrorMessage(message: 'Phone number is invalid');
      return false;
    }
    if (password.isEmpty) {
      Toasty(context)
          .showToastErrorMessage(message: 'Password field cannot be empty');
      return false;
    }
    if (password.length < 5) {
      Toasty(context).showToastErrorMessage(
          message: 'Password must be more than 5 characters');
      return false;
    }
    if (cPassword != password) {
      Toasty(context)
          .showToastErrorMessage(message: 'Password fields must match!');
      return false;
    }

    return true;
  }
}
