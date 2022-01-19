import 'package:flutter/material.dart';
import 'package:hey_voltz/api/api_service.dart';
import 'package:hey_voltz/helpers/prefs.dart';
import 'package:hey_voltz/screens/auth/components/textfield.dart';
import 'package:hey_voltz/screens/auth/screen_login.dart';
import 'package:hey_voltz/values/colors.dart';
import 'package:hey_voltz/widgets/button.dart';
import 'package:hey_voltz/widgets/toasty.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  //states
  bool isApiLoading = false;

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: deviceWidth,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
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
                  'Change Password',
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
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: InputField(
            label: 'Old Password',
            controller: _passwordController,
            textInputType: TextInputType.visiblePassword,
            isPassword: true,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: InputField(
            label: 'New Password',
            controller: _newPasswordController,
            textInputType: TextInputType.visiblePassword,
            isPassword: true,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: InputField(
            label: 'Confirm Password',
            controller: _confirmNewPasswordController,
            textInputType: TextInputType.visiblePassword,
            isPassword: true,
          ),
        ),
        const SizedBox(height: 40),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ButtonPrimary(
            label: 'Change Password',
            isLoading: isApiLoading,
            onTap: () => changePassword(),
          ),
        ),
      ])),
    );
  }

  changePassword() async {
    String password = _passwordController.text;
    String newPassword = _newPasswordController.text;
    String confPassword = _confirmNewPasswordController.text;

    if (newPassword != confPassword) {
      Toasty(context).showToastErrorMessage(message: 'Passwords do not match');
      return;
    }

    setState(() {
      isApiLoading = true;
    });

    var token = await fetchPersistedToken();
    var body = {
      'old_password': password,
      'new_password': newPassword,
    };

    await Provider.of<ApiService>(context, listen: false)
        .changePassword(token, body)
        .then((response) {
      setState(() {
        isApiLoading = false;
      });
      if (response.isSuccessful) {
        Toasty(context)
            .showToastSuccessMessage(message: 'Message changed successfully');
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
      } else {
        //ignore:avoid_print
        print('err -> ' + response.statusCode.toString());
        Toasty(context)
            .showToastErrorMessage(message: 'Old password is incorrect');
      }
    }).catchError((err) {
      setState(() {
        isApiLoading = false;
      });
      print(err.toString());
      Toasty(context)
          .showToastErrorMessage(message: 'Error while updating password');
    });
  }
}
