import 'package:brew_app/models/brew.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBService {
  final String uid;
  DBService({this.uid});

  //collection refference
  final CollectionReference brewCollection =
      Firestore.instance.collection('brews');

  Future updateUserData(
      String sugars, String name, int strenght, bool milk) async {
    return await brewCollection.document(uid).setData({
      'sugars': sugars,
      'name': name,
      'strenght': strenght,
      'milk': milk,
    });
  }

  //brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Brew(
        milk: doc.data['milk'] ?? true,
        name: doc.data['name'] ?? '',
        strenght: doc.data['strenght'] ?? 0,
        sugar: doc.data['sugar'] ?? '0',
      );
    }).toList();
  }

  // get brews streems
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }
}
