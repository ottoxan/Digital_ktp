import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_ktp/card_data.dart';
import 'package:digital_ktp/constants.dart';
import 'package:digital_ktp/firestore.dart';
import 'package:digital_ktp/my_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  final TextEditingController cardType = TextEditingController();
  final TextEditingController nameHolder = TextEditingController();
  final TextEditingController tglLahir = TextEditingController();
  final TextEditingController jenis = TextEditingController();
  final TextEditingController alamat = TextEditingController();
  final TextEditingController polDa = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();

  void openNoteBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          children: [
            TextField(
              controller: cardType,
              decoration: kTextFieldDecoration.copyWith(hintText: 'CardType'),
            ),
            TextField(
              controller: nameHolder,
            ),
            TextField(
              controller: tglLahir,
            ),
            TextField(
              controller: jenis,
            ),
            TextField(
              controller: alamat,
            ),
            TextField(
              controller: polDa,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              firestoreService.addCard(cardType.text, nameHolder.text,
                  tglLahir.text, jenis.text, alamat.text, polDa.text);

              Navigator.pop(context);
            },
            child: Text('Add'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              onPressed: openNoteBox,
              child: Text('Tambah Kartu'),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: firestoreService.getCardsStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List cardsList = snapshot.data!.docs;

                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cardsList.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = cardsList[index];
                      String docID = document.id;

                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;

                      String cardT = data['cardType'];
                      String nameHolder = data['nameHolder'];
                      String tglLahir = data['tglLahir'];
                      String jenis = data['jenis'];
                      String alamat = data['alamat'];
                      String polDa = data['polDa'];

                      return Column(
                        children: [
                          Container(
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
                                      cardT,
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
                                      '1.${nameHolder}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      '2.${tglLahir}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      '3.${jenis}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      '4.${alamat}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      '5.${polDa}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 20,
                      );
                    },
                  );
                } else {
                  return const Text('No Cards');
                }
              },
            ),
            // Container(
            //   padding: const EdgeInsets.all(20),
            //   child: ListView.separated(
            //     itemBuilder: (context, index) {
            //       return MyCard(
            //         card: myCards[index],
            //       );
            //     },
            //     separatorBuilder: (context, index) {
            //       return const SizedBox(
            //         height: 20,
            //       );
            //     },
            //     itemCount: myCards.length,
            //     shrinkWrap: true,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
