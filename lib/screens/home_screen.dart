import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_ktp/pages/helppage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:digital_ktp/pages/homepage.dart';
import 'package:digital_ktp/pages/walletpage.dart';
import 'package:digital_ktp/pages/settingspage.dart';

final _fireStore = FirebaseFirestore.instance;
late User loggedInUser;

class HomeScreen extends StatefulWidget {
  static String id = 'chat_screen';

  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    log('${_auth.currentUser?.email}');
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void ProfileController() async {
    await for (var snapshot in _fireStore.collection('Users').snapshots()) {
      for (var Users in snapshot.docChanges) {
        print(Users.doc.data());
      }
    }
  }

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const HomePage(),
    const Wallet(),
    const SettingsPage(),
    const HelpPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        bottomNavigationBar: Container(
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
            child: BottomNavigationBar(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                fixedColor: Colors.white,
                type: BottomNavigationBarType.fixed,
                elevation: 0,
                currentIndex: _selectedIndex,
                onTap: _navigateBottomBar,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.credit_card_outlined),
                    label: "KTP",
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.wallet), label: "Wallet"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings), label: "Settings"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.help), label: "Help"),
                ]),
          ),
        ),
        body: _pages[_selectedIndex]);
  }
}

class dataDetails extends StatelessWidget {
  final String dataName;
  final String dataCloud;

  const dataDetails({
    super.key,
    required this.dataName,
    required this.dataCloud,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 30, top: 30, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            dataName.toUpperCase(),
            style: const TextStyle(
                color: Colors.black45,
                fontSize: 15,
                fontWeight: FontWeight.w700),
          ),
          Text(
            dataCloud.toUpperCase(),
            style: const TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

getUserDetails(String email) async {
  final snapshot = await _fireStore
      .collection("Users")
      .where("Email", isEqualTo: email)
      .get();
  final userData = snapshot.docs.map((e) => UserModel.fromSnaphot(e)).single;
  return userData;
}

class UserModel {
  final String? id;
  final String name;
  final String email;
  final String nik;
  final String tglLahir;
  final String jenisKelamin;
  final String alamat;
  final String agama;
  final String status;
  final String pekerjaan;
  final String kewarganegara;
  final String berlakuHingga;

  const UserModel({
    this.id,
    required this.name,
    required this.nik,
    required this.email,
    required this.tglLahir,
    required this.jenisKelamin,
    required this.alamat,
    required this.agama,
    required this.status,
    required this.pekerjaan,
    required this.kewarganegara,
    required this.berlakuHingga,
  });

  toJson() {
    return {
      "Name": name,
      "Email": email,
      "Nik": nik,
      "TglLahir": tglLahir,
      "JenisKelamin": jenisKelamin,
      "Alamat": alamat,
      "Agama": agama,
      "Status": status,
      "Pekerjaan": pekerjaan,
      "Kewaganegara": kewarganegara,
      "BerlakuHingga": berlakuHingga,
    };
  }

  factory UserModel.fromSnaphot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
      id: document.id,
      name: data["nama"],
      email: data["Email"],
      nik: data["nik"],
      tglLahir: data["tglLahir"],
      jenisKelamin: data["jenisKelamin"],
      alamat: data["alamat"],
      agama: data["agama"],
      status: data["status"],
      pekerjaan: data["pekerjaan"],
      kewarganegara: data["kewarganegara"],
      berlakuHingga: data["berlakuHingga"],
    );
  }
}
