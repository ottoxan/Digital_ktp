import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_ktp/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:digital_ktp/constants.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';

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

  List<String> _pictures = [];

  late String _jenisKelamin;
  List<String> listOfJenis = ['Laki-laki', 'Perempuan'];

  late String _kewarganegara;
  List<String> listOfNegara = ['WNI', 'WNA'];

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
                _extractTextView(),
                const SizedBox(
                  height: 48.0,
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
                for (var picture in _pictures)
                  Image.file(
                    File(picture),
                  ),
                ElevatedButton(
                  onPressed: onPressed,
                  child: const Text("Photo KTP"),
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
                        List data =[email1.text.isEmpty,
                          agama.text,
                           alamat.text,
                          berlakuHingga.text,
                          _jenisKelamin,
                          kewarganegara.text,
                          nama.text,
                          nik.text,
                          pekerjaan.text,
                          status.text,
                          tglLahir.text];
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
                        // ignore: unused_local_variable
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

  Widget _extractTextView() {
    if (_pictures.isEmpty) {
      return const Center(
        child: Text("No result"),
      );
    }
    return FutureBuilder(
        future: _extractText(File(_pictures.last)),
        builder: (context, snapshot) {
          return Text(
            snapshot.data ?? "",
            style: TextStyle(
              fontSize: 25,
            ),
          );
        });
  }

  Future<String?> _extractText(File file) async {
    final textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );
    final InputImage inputImage = InputImage.fromFile(file);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    String text = recognizedText.text;
    textRecognizer.close();
    return text;
  }

  void onPressed() async {
    List<String> pictures;
    try {
      pictures = await CunningDocumentScanner.getPictures() ?? [];
      if (!mounted) return;
      setState(() {
        _pictures = pictures;
      });
    } catch (exception) {
      // Handle exception here
    }
  }
}

class DropDownForm extends StatelessWidget {
  const DropDownForm(
      {super.key,
      required this.listOf,
      required this.onChanged,
      required this.hintText});

  final List<String> listOf;
  final onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      items: listOf.map((String val) {
        return DropdownMenuItem(
          value: val,
          child: Text(
            val,
          ),
        );
      }).toList(),
      onChanged: onChanged,
      style: const TextStyle(
        color: Colors.black,
      ),
      isExpanded: true,
      isDense: true,
      decoration: kTextFieldDecoration.copyWith(hintText: hintText),
    );
  }
}

class TextFormField extends StatelessWidget {
  const TextFormField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.black),
      decoration: kTextFieldDecoration.copyWith(hintText: hintText),
    );
  }
}
