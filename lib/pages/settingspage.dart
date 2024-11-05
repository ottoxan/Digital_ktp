import 'package:digital_ktp/screens/home_screen.dart';
import 'package:digital_ktp/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import '../theme_data_style.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    final email = _auth.currentUser?.email;
    if (email != null) {
      return getUserDetails(email);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              themeProvider.themeDataStyle == ThemeDataStyle.dark
                  ? 'Dark Theme'
                  : 'Light Theme',
              style: const TextStyle(fontSize: 25.0),
            ),
            const SizedBox(height: 10.0),
            Transform.scale(
              scale: 1.4,
              child: Switch(
                value: themeProvider.themeDataStyle == ThemeDataStyle.dark
                    ? true
                    : false,
                onChanged: (isOn) {
                  themeProvider.changeTheme();
                },
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Image.asset(
                    "images/user.png",
                    width: 70,
                    height: 70,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  buildFutureBuilder()
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              'Settings',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Text(
                    'Logout',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.popAndPushNamed(context, WelcomeScreen.id);
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.output,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  FutureBuilder<dynamic> buildFutureBuilder() {
    return FutureBuilder(
      future: getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            UserModel userData = snapshot.data as UserModel;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userData.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  userData.email,
                  style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.secondary),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
