import 'package:flutter/material.dart';
import 'package:digital_ktp/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:digital_ktp/screens/home_screen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../rounded_button.dart';
import 'package:local_auth_android/local_auth_android.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';

  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthentication auth = LocalAuthentication();
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  late String email;
  late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LoadingOverlay(
        isLoading: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black),
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
                style: const TextStyle(
                  color: Colors.black,
                ),
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password.',
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              Hero(
                tag: 'loginButton',
                child: RoundedButton(
                  color: const Color(0xFF243D41),
                  textColor: Colors.white,
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      // ignore: unused_local_variable
                      final user = await _auth.signInWithEmailAndPassword(
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
                              title: "Failed Login",
                              type: AlertType.error,
                              desc: "Incorrect Email Or Password.")
                          .show();
                      print(e);
                    }
                  },
                  text: 'Login',
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              ElevatedButton(
                  onPressed: () async {
                    final bool canAuthenticateWithBiometrics =
                        await auth.canCheckBiometrics;
                    final bool canAuthenticate =
                        canAuthenticateWithBiometrics ||
                            await auth.isDeviceSupported();

                    print({'Cek Suport': canAuthenticate});

                    final List<BiometricType> availableBiometrics =
                        await auth.getAvailableBiometrics();

                    print({'Cek Available': availableBiometrics});

                    if (canAuthenticate) {
                      try {
                        final bool didAuthenticate = await auth.authenticate(
                            options: const AuthenticationOptions(
                                biometricOnly: true),
                            localizedReason:
                                'Masukkan sidik jari untuk tetap login ',
                            authMessages: [
                              AndroidAuthMessages(
                                cancelButton: 'Batalkan',
                                signInTitle: 'Digital KTP',
                              )
                            ]);
                        print({'cek apakah finger benar': didAuthenticate});

                        // Jika didAuthenticate bernilai true, maka ambil data dari localdatabase
                        if (didAuthenticate == true) {
                          try {
                            // ignore: unused_local_variable
                            final user = await _auth.signInWithEmailAndPassword(
                                email: '123@gmail.com', password: '123456');
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
                                    title: "Failed Login",
                                    type: AlertType.error,
                                    desc: "Incorrect Email Or Password.")
                                .show();
                            print(e);
                          }
                        } else {
                          Alert(
                                  context: context,
                                  title: "Failed Login",
                                  type: AlertType.error,
                                  desc: "Incorrect Email Or Password.")
                              .show();
                        }
                        // Jsonfile , securestorage / get_storange / sqflite
                      } on PlatformException catch (error) {
                        print(error);
                      }
                    }
                  },
                  child: const Icon(Icons.fingerprint))
            ],
          ),
        ),
      ),
    );
  }
}
