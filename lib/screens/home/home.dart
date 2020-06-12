import 'package:brew_app/models/brew.dart';
import 'package:brew_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:brew_app/services/db.dart';
import 'package:provider/provider.dart';
import 'package:brew_app/screens/home/brew_list.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Brew>>.value(
      value: DBService().brews,
      child: Scaffold(
        backgroundColor: Colors.brown[50],
        appBar: AppBar(
          title: Text('Brew App'),
          backgroundColor: Colors.brown[400],
          elevation: 0,
          actions: <Widget>[
            FlatButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(Icons.person),
              label: Text('logout'),
            )
          ],
        ),
        body: BrewList(),
      ),
    );
  }
}
