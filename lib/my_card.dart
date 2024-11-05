import 'package:digital_ktp/card_data.dart';
import 'package:digital_ktp/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final CardModel card;
  final _auth = FirebaseAuth.instance;

  MyCard({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    getUserData() async {
      final email = _auth.currentUser?.email;
      if (email != null) {
        return getUserDetails(email);
      }
    }

    return FutureBuilder(
      future: getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            UserModel userData = snapshot.data as UserModel;
            return Container(
              padding: const EdgeInsets.all(20),
              height: 200,
              width: 350,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        card.cardType,
                        style: TextStyle(color: Colors.white),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Image(
                          image: AssetImage('images/user.png'),
                          height: 100,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '1.${userData.name}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '2.${userData.tglLahir}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '3.${userData.jenisKelamin}',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '4.${userData.alamat}',
                        style: TextStyle(color: Colors.white),
                      ),
                      const Text(
                        '5.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )
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
    );
  }
}
