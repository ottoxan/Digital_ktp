import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
    final CollectionReference cards =
      FirebaseFirestore.instance.collection('cards');


  Future<void> addCard(String cardType, String nameHolder,
      String tglLahir, String jenis, String alamat, String polDa) {
    return cards.add({
      'cardType': cardType,
      'nameHolder': nameHolder,
      'tglLahir': tglLahir,
      'jenis': jenis,
      'alamat': alamat,
      'polDa': polDa,
      'timestamp': Timestamp.now()
    });
  }

  Stream<QuerySnapshot> getCardsStream() {
    final cardsStream =
        cards.orderBy('timestamp', descending: true).snapshots();

    return cardsStream;
  }
}
