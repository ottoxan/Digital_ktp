import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:digital_ktp/pages/qr.dart';
import 'package:digital_ktp/screens/home_screen.dart';
import 'package:digital_ktp/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return Column(
      children: [
        SafeArea(
          child: Column(
            children: [
              Container(
                color: const Color(0xff1C2E31),
                padding: const EdgeInsets.all(20),
                alignment: Alignment.topCenter,
                child: Text(
                  "Digital KTP",
                  style:
                      TextStyle(color: Colors.white),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                alignment: Alignment.bottomLeft,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: Color(0xff1C2E31),
                ),
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Image(
                        image: AssetImage('images/user.png'),
                        height: 130,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: buildFutureBuilder(),
                    ),
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Hero(
                            tag: 'logo',
                            child: Image(
                              image: AssetImage('images/logo.png'),
                              height: 70,
                            ),
                          ),
                        ),
                        AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: [
                            ColorizeAnimatedText(
                                colors: colorizeColors,
                                'REPUBLIC OF \nINDONESIA',
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        FutureBuilder(
          future: getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                UserModel userData = snapshot.data as UserModel;
                return Column(
                  children: [
                    dataDetails(
                      dataName: 'Tempat/tgl Lahir',
                      dataCloud: userData.tglLahir,
                    ),
                    dataDetails(
                      dataName: 'jenis kelamin',
                      dataCloud: userData.jenisKelamin,
                    ),
                    dataDetails(
                      dataName: 'Alamat',
                      dataCloud: userData.alamat,
                    ),
                    dataDetails(
                      dataName: 'Agama',
                      dataCloud: userData.agama,
                    ),
                    dataDetails(
                      dataName: 'Status Perkawinan',
                      dataCloud: userData.status,
                    ),
                    dataDetails(
                      dataName: 'Pekerjaan',
                      dataCloud: userData.pekerjaan,
                    ),
                    dataDetails(
                      dataName: 'Kewarganegaraan',
                      dataCloud: userData.kewarganegara,
                    ),
                    dataDetails(
                      dataName: 'Berlaku Hingga',
                      dataCloud: userData.berlakuHingga,
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const NikQr()));
                      },
                      child: Container(
                        width: 230,
                        height: 80,
                        decoration: BoxDecoration(
                            color: const Color(0xff1C2E31),
                            borderRadius: BorderRadius.circular(40)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'N I K',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            QrImageView(
                              data: userData.nik,
                              version: QrVersions.auto,
                              size: 80.0,
                              dataModuleStyle:
                                  const QrDataModuleStyle(color: Colors.white),
                              eyeStyle: const QrEyeStyle(
                                  color: Colors.white,
                                  eyeShape: QrEyeShape.square),
                            ),
                          ],
                        ),
                      ),
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
        )
      ],
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Nama : ${userData.name}'.toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'NIK : ${userData.nik}',
                    style: TextStyle(color: Colors.white),
                  ),
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
