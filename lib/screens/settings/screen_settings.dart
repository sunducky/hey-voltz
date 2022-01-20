import 'package:flutter/material.dart';
import 'package:hey_voltz/screens/settings/screen_cards.dart';
import 'package:hey_voltz/screens/settings/screen_change_password.dart';
import 'package:hey_voltz/values/colors.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
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
                  'Settings',
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
        ListTile(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => ChangePasswordScreen())),
          leading: const Icon(
            Icons.lock_rounded,
          ),
          title: const Text(
            'Change Password',
          ),
          trailing: const Icon(
            Icons.chevron_right_rounded,
          ),
        ),
        // ListTile(
        //   onTap: () => Navigator.push(context,
        //       MaterialPageRoute(builder: (_) => ChangePasswordScreen())),
        //   leading: const Icon(
        //     Icons.credit_card_rounded,
        //   ),
        //   title: const Text(
        //     'Manage saved cards',
        //   ),
        //   trailing: const Icon(
        //     Icons.chevron_right_rounded,
        //   ),
        // ),
        ListTile(
          onTap: () {},
          leading: const Icon(Icons.headphones_rounded),
          title: const Text(
            'Help and Support',
          ),
          trailing: const Icon(
            Icons.chevron_right_rounded,
          ),
        ),
        ListTile(
          onTap: () {},
          leading: const Icon(
            Icons.help_rounded,
          ),
          title: const Text('About'),
          trailing: const Icon(
            Icons.chevron_right_rounded,
          ),
        ),
      ],
    )));
  }
}
