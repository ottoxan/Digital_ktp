import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_ktp/constants.dart';
import 'package:digital_ktp/firestore.dart';
import 'package:digital_ktp/screens/registration_screen_ori.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  final TextEditingController email = TextEditingController();
  final TextEditingController cardType = TextEditingController();
  final TextEditingController nameHolder = TextEditingController();
  final TextEditingController tglLahir = TextEditingController();
  final TextEditingController jenis = TextEditingController();
  final TextEditingController alamat = TextEditingController();
  final TextEditingController polDa = TextEditingController();
  final FirestoreService firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late String _typeCard;
  List<String> typesCard = ['SIM A', 'SIM B', 'SIM C'];

  @override
  void initState() {
    super.initState();
  }

  void clearTextControllers() {
    email.clear();
    cardType.clear();
    nameHolder.clear();
    tglLahir.clear();
    jenis.clear();
    alamat.clear();
    polDa.clear();
  }

  void openNoteBox({
    String? docID,
    String? ucardType,
    String? unameHolder,
    String? utglLahir,
    String? ujenis,
    String? ualamat,
    String? upolDa,
  }) {
    if (docID != null) {
      cardType.text = ucardType ?? '';
      nameHolder.text = unameHolder ?? '';
      tglLahir.text = utglLahir ?? '';
      jenis.text = ujenis ?? '';
      alamat.text = ualamat ?? '';
      polDa.text = upolDa ?? '';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            children: [
              DropDownForm(
                listOf: typesCard,
                onChanged: (value) {
                  setState(() {
                    _typeCard = value!;
                  });
                },
                hintText: 'Card Type',
              ),
              buildTextField(controller: cardType, hint: 'Card Type'),
              buildTextField(controller: nameHolder, hint: 'Nama'),
              buildTextField(controller: tglLahir, hint: 'Tanggal Lahir'),
              buildTextField(controller: jenis, hint: 'Jenis'),
              buildTextField(controller: alamat, hint: 'Alamat'),
              buildTextField(controller: polDa, hint: 'POLDA'),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (docID == null) {
                firestoreService.addCard(
                  cardType.text,
                  nameHolder.text,
                  tglLahir.text,
                  jenis.text,
                  alamat.text,
                  polDa.text,
                );
              } else {
                firestoreService.updateCard(
                  docID,
                  cardType.text,
                  nameHolder.text,
                  tglLahir.text,
                  jenis.text,
                  alamat.text,
                  polDa.text,
                );
              }
              clearTextControllers();
              Navigator.pop(context);
            },
            child: Text(docID == null ? 'Add' : 'Update'),
          )
        ],
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: kTextFieldDecoration.copyWith(hintText: hint),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: firestoreService.getCardsStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text('No Cards');
                  }

                  final cardsList = snapshot.data!.docs;
                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cardsList.length,
                    itemBuilder: (context, index) {
                      final document = cardsList[index];
                      final docID = document.id;
                      final data = document.data() as Map<String, dynamic>;

                      return buildCard(
                        docID: docID,
                        cardT: data['cardType'],
                        nameHolder: data['nameHolder'],
                        tglLahir: data['tglLahir'],
                        jenis: data['jenis'],
                        alamat: data['alamat'],
                        polDa: data['polDa'],
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 20),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            FloatingActionButton(
              onPressed: () => openNoteBox(),
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard({
    required String docID,
    required String cardT,
    required String nameHolder,
    required String tglLahir,
    required String jenis,
    required String alamat,
    required String polDa,
  }) {
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
              Text(cardT, style: const TextStyle(color: Colors.white)),
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Image(
                  image: AssetImage('images/user.png'),
                  height: 100,
                ),
              ),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('1. $nameHolder',
                    style: const TextStyle(color: Colors.white)),
                Text('2. $tglLahir',
                    style: const TextStyle(color: Colors.white)),
                Text('3. $jenis', style: const TextStyle(color: Colors.white)),
                Text('4. $alamat', style: const TextStyle(color: Colors.white)),
                Text('5. $polDa', style: const TextStyle(color: Colors.white)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => openNoteBox(
                        docID: docID,
                        ucardType: cardT,
                        unameHolder: nameHolder,
                        utglLahir: tglLahir,
                        ujenis: jenis,
                        ualamat: alamat,
                        upolDa: polDa,
                      ),
                      icon: const Icon(Icons.settings, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () => firestoreService.deleteCard(docID),
                      icon: const Icon(Icons.delete, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
