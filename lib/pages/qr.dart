import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:digital_ktp/screens/home_screen.dart';
import 'package:digital_ktp/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class NikQr extends StatefulWidget {
  const NikQr({super.key});

  @override
  State<NikQr> createState() => _NikQrState();
}

class _NikQrState extends State<NikQr> {
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
    return Scaffold(
      body: FutureBuilder(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              UserModel userData = snapshot.data as UserModel;
              return Container(
                decoration: const BoxDecoration(
                  color: Color(0xff1C2E31),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(
                      image: AssetImage('images/logo.png'),
                      height: 150,
                    ),
                    AnimatedTextKit(
                      repeatForever: true,
                      animatedTexts: [
                        ColorizeAnimatedText(
                            colors: colorizeColors,
                            'REPUBLIC OF \nINDONESIA',
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 35,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center),
                      ],
                    ),
                    const SizedBox(height: 30,),
                    Center(
                      child: QrImageView(
                        data: userData.nik,
                        version: QrVersions.auto,
                        size: 300.0,
                        dataModuleStyle:
                        const QrDataModuleStyle(color: Colors.white,dataModuleShape: QrDataModuleShape.square),
                        eyeStyle: const QrEyeStyle(
                            color: Colors.white,
                            eyeShape: QrEyeShape.square),
                      ),
                    ),
                  ],
                ),
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
      ),
    );
  }
}
