import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference cards =
      FirebaseFirestore.instance.collection('cards');

  Future<void> addCard(String cardType, String nameHolder, String tglLahir,
      String jenis, String alamat, String polDa) {
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

  Future<void> updateCard(String docID, String ucardType, String unameHolder,
      String utglLahir, String ujenis, String ualamat, String upolDa) {
    return cards.doc(docID).update({
      'cardType': ucardType,
      'nameHolder': unameHolder,
      'tglLahir': utglLahir,
      'jenis': ujenis,
      'alamat': ualamat,
      'polDa': upolDa,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> deleteCard(String docID) {
    return cards.doc(docID).delete();
  }
}
