import 'package:brew_app/models/brew.dart';
import 'package:brew_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DBService {
  final String uid;
  DBService({this.uid});

  //collection refference
  final CollectionReference brewCollection =
      Firestore.instance.collection('brews');

  Future updateUserData(
      String sugar, String name, int strength, bool milk) async {
    return await brewCollection.document(uid).setData({
      'sugar': sugar,
      'name': name,
      'strength': strength,
      'milk': milk,
    });
  }

  //brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Brew(
        milk: doc.data['milk'] ?? true,
        name: doc.data['name'] ?? '',
        strength: doc.data['strength'] ?? 0,
        sugar: doc.data['sugar'] ?? '0',
      );
    }).toList();
  }

  //userdata from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      sugar: snapshot.data['sugar'],
      strength: snapshot.data['strength'],
      milk: snapshot.data['milk'],
    );
  }


  // get brews streems
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}
