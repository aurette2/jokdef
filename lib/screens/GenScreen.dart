import 'package:flutter/material.dart';
import 'package:final_jokdef/models/UserModel.dart';
import 'package:final_jokdef/screens/Auth.dart';
import 'package:final_jokdef/screens/admin/HomeAdminScreen.dart';
import 'package:final_jokdef/screens/services/UserService.dart';

import 'Company/HomeCompanyScreen.dart';

class GenScreen extends StatefulWidget {
  const GenScreen({super.key});

  @override
  State<GenScreen> createState() => _GenScreenState();
}

class _GenScreenState extends State<GenScreen> {
  UserService _userService = UserService();

  List<Widget> _widgets = [];
  int _indexSelected = 0;
  String _email = '';
  String _password = '';

  @override
  void initState() {
    super.initState();

    _widgets.addAll([
      AuthScreen(
        onChangeStep: (index, email, pwd) => setState(() {
          _indexSelected = index;
          _email = email;
          _password = pwd;
          _userService
            .registration(UserModel(
              email: _email,
              password: _password,
              uid: '',
          ))
          .then((value) {
            if (_indexSelected == 0) {
              Navigator.push(
                  context,
                  MaterialPageRoute(                    
                      builder: (context) =>HomeCompanyScreen(),
                      //builder: (context) => HomeCompanyScreen(currentUser: value,),
                  ));
            }

            if (_indexSelected == 1) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeAdminScreen(),
                  ));
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(value!),
              ),
            );

          });
        }),
      ),
      
      HomeAdminScreen(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _widgets.elementAt(_indexSelected),
    );
  }
}
