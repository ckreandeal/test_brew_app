import 'package:brew_app/models/user.dart';
import 'package:brew_app/services/db.dart';
import 'package:brew_app/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_app/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingForm extends StatefulWidget {
  @override
  _SettingFormState createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  String _currentName;
  String _currentSugars;
  int _currentStrength;
  bool _currentMilk;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return StreamBuilder<UserData>(
        stream: DBService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userdata = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Update your brew settings.',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    initialValue: userdata.name,
                    decoration: textInputDecoration,
                    validator: (val) =>
                        val.isEmpty ? 'Please enter the name' : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  SizedBox(height: 20),
                  //dropdown
                  DropdownButtonFormField(
                    decoration: textInputDecoration,
                    value: _currentSugars ?? userdata.sugar,
                    onChanged: (val) => setState(() => _currentSugars = val),
                    items: sugars.map((sugar) {
                      return DropdownMenuItem(
                        value: sugar,
                        child: Text('$sugar sugars'),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  //slider
                  Slider(
                    min: 100,
                    max: 900,
                    divisions: 8,
                    onChanged: (val) =>
                        setState(() => _currentStrength = val.round()),
                    value: (_currentStrength ?? userdata.strength).toDouble(),
                    activeColor:
                        Colors.brown[_currentStrength ?? userdata.strength],
                    inactiveColor:
                        Colors.brown[_currentStrength ?? userdata.strength],
                  ),
                  RaisedButton(
                      color: Colors.pink[400],
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await DBService(uid: user.uid).updateUserData(
                            _currentSugars ?? userdata.sugar,
                            _currentName ?? userdata.name,
                            _currentStrength ?? userdata.strength,
                            _currentMilk ?? userdata.milk,
                          );
                          Navigator.pop(context);
                        }
                      }),
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
