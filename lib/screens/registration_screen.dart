import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_ktp/drop_down_form.dart';
import 'package:digital_ktp/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:digital_ktp/constants.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mnc_identifier_ocr/mnc_identifier_ocr.dart';
import 'package:mnc_identifier_ocr/model/ocr_result_model.dart';
import 'dart:async';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  late String email;
  late String password;
  bool validate = false;

  final nama = TextEditingController();
  final email1 = TextEditingController();
  final nik = TextEditingController();
  final status = TextEditingController();
  final tglLahir = TextEditingController();
  final agama = TextEditingController();
  final alamat = TextEditingController();
  final berlakuHingga = TextEditingController();
  final jenisKelamin = TextEditingController();
  final kewarganegara = TextEditingController();
  final pekerjaan = TextEditingController();

  late String _jenisKelamin;
  List<String> listOfJenis = ['Laki-laki', 'Perempuan'];

  late String _kewarganegara;
  List<String> listOfNegara = ['WNI', 'WNA'];

  OcrResultModel? result;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanKtp() async {
    OcrResultModel? res;
    try {
      res = await MncIdentifierOcr.startCaptureKtp(
          withFlash: true, cameraOnly: true);
    } catch (e) {
      debugPrint('something goes wrong $e');
    }

    if (!mounted) return;

    setState(() {
      result = res;

      nama.text = result?.ktp?.nama ?? '';
      nik.text = result?.ktp?.nik ?? '';
      tglLahir.text = result?.ktp?.tglLahir ?? '';
      alamat.text = result?.ktp?.alamat ?? '';
      agama.text = result?.ktp?.agama ?? '';
      status.text = result?.ktp?.statusPerkawinan ?? '';
      pekerjaan.text = result?.ktp?.pekerjaan ?? '';
      berlakuHingga.text = result?.ktp?.berlakuHingga ?? '';
      _jenisKelamin = result?.ktp?.jenisKelamin ?? '';
      _kewarganegara = result?.ktp?.kewarganegaraan ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoadingOverlay(
        isLoading: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                const SizedBox(
                  height: 48.0,
                ),
                const SizedBox(
                  height: 48.0,
                ),
                Stack(
                  children: [
                    Text('Ktp data: ${result?.toJson()}'),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: scanKtp,
                              child: const Text('SCAN KTP')),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black),
                  controller: email1,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your email',
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black),
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password'),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  controller: nama,
                  hintText: 'Nama Lengkap',
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  controller: nik,
                  hintText: 'NIK',
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  controller: tglLahir,
                  hintText: 'Tanggal Lahir',
                ),
                const SizedBox(
                  height: 8.0,
                ),
                DropDownForm(
                  hintText: "Jenis Kelamin",
                  listOf: listOfJenis,
                  onChanged: (value) {
                    setState(() {
                      _jenisKelamin = value!;
                    });
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  controller: alamat,
                  hintText: 'Alamat',
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  controller: agama,
                  hintText: 'Agama',
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  controller: status,
                  hintText: 'Status Perkawinan',
                ),
                const SizedBox(
                  height: 8.0,
                ),
                DropDownForm(
                  hintText: "Kewarganegara",
                  listOf: listOfNegara,
                  onChanged: (value) {
                    setState(() {
                      _kewarganegara = value!;
                    });
                  },
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  controller: pekerjaan,
                  hintText: 'Pekerjaan',
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  controller: berlakuHingga,
                  hintText: 'Berlaku Hinnga',
                ),
                Hero(
                  tag: 'registerButton',
                  child: RoundedButton(
                    textColor: Colors.white,
                    color: const Color(0xFF243D41),
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        CollectionReference collRef =
                            FirebaseFirestore.instance.collection('Users');
                        List data = [
                          email1.text.isEmpty,
                          agama.text,
                          alamat.text,
                          berlakuHingga.text,
                          _jenisKelamin,
                          kewarganegara.text,
                          nama.text,
                          nik.text,
                          pekerjaan.text,
                          status.text,
                          tglLahir.text
                        ];
                        collRef.add({
                          'Email': email1.text,
                          'agama': agama.text,
                          'alamat': alamat.text,
                          'berlakuHingga': berlakuHingga.text,
                          'jenisKelamin': _jenisKelamin,
                          'kewarganegara': kewarganegara.text,
                          'nama': nama.text,
                          'nik': nik.text,
                          'pekerjaan': pekerjaan.text,
                          'status': status.text,
                          'tglLahir': tglLahir.text,
                        });
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        Navigator.pushNamed(context, HomeScreen.id);
                        setState(() {
                          showSpinner = false;
                        });
                      } catch (e) {
                        setState(() {
                          showSpinner = false;
                        });
                        Alert(
                                context: context,
                                title: "Failed to Register",
                                type: AlertType.error,
                                desc: "Incorrect Email Or Password.")
                            .show();
                      }
                    },
                    text: 'Register',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextFormField extends StatelessWidget {
  TextFormField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  final TextEditingController controller;
  final String hintText;
  bool validate = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.black),
      decoration: kTextFieldDecoration.copyWith(
        hintText: hintText,
        errorText: validate ? "Value Can't Be Empty" : null,
      ),
    );
  }
}
