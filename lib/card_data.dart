class CardModel {
  String cardType;
  String nameHolder;
  String tglLahir;
  String jenis;
  String alamat;
  String polDa;

  CardModel({
    required this.cardType,
    required this.nameHolder,
    required this.tglLahir,
    required this.jenis,
    required this.alamat,
    required this.polDa,
  });
}


List<CardModel> myCards = [
  CardModel(
    cardType: "SIM A",
    nameHolder: "",
    tglLahir: "",
    jenis: "",
    alamat: "",
    polDa: "",
  ),
  CardModel(
    cardType: "SIM B",
    nameHolder: "Usman",
    tglLahir: "",
    jenis: "",
    alamat: "",
    polDa: "",
  ),
  CardModel(
    cardType: "SIM C",
    nameHolder: "Usman",
    tglLahir: "",
    jenis: "",
    alamat: "",
    polDa: "",
  ),
];