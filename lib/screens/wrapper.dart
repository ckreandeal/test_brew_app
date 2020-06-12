import 'package:brew_app/models/user.dart';
import 'package:brew_app/screens/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home/home.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return Auth();
    } else {
      return Home();
      
    }
  }
}
