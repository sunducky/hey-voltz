import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hey_voltz/api/dto/models.dart';
import 'package:hey_voltz/helpers/prefs.dart';
import 'package:hey_voltz/screens/screen_splash.dart';
import 'package:hey_voltz/screens/settings/screen_cards.dart';
import 'package:hey_voltz/screens/settings/screen_settings.dart';
import 'package:hey_voltz/screens/stations/screen_stations.dart';
import 'package:hey_voltz/values/colors.dart';
import 'package:hey_voltz/widgets/button.dart';
import 'package:material_dialogs/material_dialogs.dart';

class ProfileFragment extends StatefulWidget {
  ProfileFragment({Key? key}) : super(key: key);

  @override
  _ProfileFragmentState createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  User? user;
  bool flag = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserProfile();
  }

  fetchUserProfile() async {
    user = await fetchUserData();
    setState(() {
      flag = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    if (user == null) {
      return const SafeArea(
          child: Center(
        child: CircularProgressIndicator(),
      ));
    }

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //ProfileSection
              buildProfileSection(),
              const SizedBox(height: 50),
              //WalletSection
              buildWalletSection(deviceWidth),
              const SizedBox(height: 20),
              //OptionsSection
              buildOptionsSection(),
              const SizedBox(height: 10),
              const Divider(
                height: 2,
                color: Color(0xFFBCBFC2),
              ),
              const SizedBox(height: 10),
              //LogOutButton
              ListTile(
                leading: const Icon(
                  Icons.logout_rounded,
                  color: Colors.red,
                ),
                title: const Text(
                  'Log out',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => showLogoutDialog(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column buildOptionsSection() {
    return Column(
      children: [
        buildListTile(
          title: 'Your Favorites',
          icon: Icons.favorite_rounded,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => StationsScreen(
                      screenType: StationsScreenType.favorites))),
        ),
        // buildListTile(
        //   title: 'History',
        //   icon: Icons.history_rounded,
        //   onTap: () {},
        // ),
        // buildListTile(
        //   title: 'Payment',
        //   icon: Icons.payment_rounded,
        //   onTap: () {},
        // ),
        buildListTile(
          title: 'Referral code',
          icon: Icons.all_inclusive_rounded,
          onTap: () => showReferralCode(),
        ),
        buildListTile(
          title: 'Settings',
          icon: Icons.settings_rounded,
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (_) => SettingsScreen())),
        )
      ],
    );
  }

  ListTile buildListTile(
      {required String title,
      required IconData icon,
      required Function() onTap}) {
    return ListTile(
      leading: Icon(
        icon,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
    );
  }

  Container buildWalletSection(double deviceWidth) {
    return Container(
      width: deviceWidth,
      height: 100,
      decoration: const BoxDecoration(
          border: Border(
        top: BorderSide(width: 2, color: Color(0xFFBCBFC2)),
        bottom: BorderSide(width: 2, color: Color(0xFFBCBFC2)),
      )),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(
                right: BorderSide(width: 1, color: Color(0xFFBCBFC2)),
              )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '???${user!.walletBalance}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'wallet balance',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(
                left: BorderSide(width: 1, color: Color(0xFFBCBFC2)),
              )),
              child: Center(
                  child: SizedBox(
                width: 115,
                child: ButtonPrimary(
                  label: 'fund wallet',
                  onTap: () {
                    //I feel like take user to PayStack screen
                    //Take user to screen to enter amount to fund
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => FundAmountScreen()));
                  },
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            height: 100,
            width: 120,
            color: colorPrimary,
          ),
          const SizedBox(width: 20),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${user!.firstname} ${user!.lastname}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(
                    Icons.phone_rounded,
                    size: 12,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${user!.phone}',
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.mail_outline_rounded,
                    size: 12,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${user!.email}',
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          )),
        ],
      ),
    );
  }

  showLogoutDialog() {
    Dialogs.bottomMaterialDialog(
        context: context,
        title: 'Log out?',
        msg:
            'Logging out will make you lose your data. Do you still want to continue?',
        actions: [
          TextButton(
              onPressed: () {
                clearUserData();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => SplashScreen()),
                    (route) => false);
              },
              child: const Text(
                'Yes',
                style: TextStyle(
                  fontSize: 17,
                ),
              )),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                //ignore:avoid_print
                print('Cancelled');
              },
              child: const Text(
                'No',
                style: TextStyle(
                  fontSize: 17,
                ),
              )),
        ]);
  }

  showReferralCode() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Material(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            elevation: 10,
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Referral Code',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      '${user!.referralCode}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
