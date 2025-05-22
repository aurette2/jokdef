// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:final_jokdef/models/UserModel.dart';

import 'services/UserService.dart';



class AuthScreen extends StatefulWidget {
  final Function(int, String, String) onChangeStep;
  const AuthScreen({
    Key? key,
    required this.onChangeStep,
  }) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RegExp emailRegex = RegExp(r"[a-z0-9\._-]+@[a-z0-9\._-]+\.[a-z]+");

  String _email = "";
  String _password = "";
  String valueChoose = "Company";
  List listItem = ["Company", "Adminstration"];
  bool _isSecret = true;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: w,
                    height: h * 0.15,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("img/login1.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),


                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    width: w,
                    child: Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            text: 'Welcome to\n'.toUpperCase(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30.0,
                            ),
                            children: [
                              TextSpan(
                                text: 'appname\n'.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Sign into your account ',
                          style: TextStyle(fontSize: 20.0, color: Color.fromARGB(255, 71, 71, 71)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Enter your email'),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          onChanged: (value) => setState(() => _email = value),
                          validator: (value) =>
                              value!.isEmpty || !emailRegex.hasMatch(value)
                                  ? 'Please enter a valid email'
                                  : null,
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 10,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Ex: jok.def@gmail.com',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.0
                        ),
                        Text('Enter your password'),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          onChanged: (value) => setState(() => _password = value),
                          validator: (value) => value!.length < 6
                              ? 'Enter a passwords, 6 caracters min required'
                              : null,
                          obscureText: _isSecret,
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 10,
                          ),
                          decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () => setState(() => _isSecret = !_isSecret),
                              child: Icon(!_isSecret
                                  ? Icons.visibility
                                  : Icons.visibility_off,),

                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        DropdownButtonFormField(
                          hint: Text("Company / Administration", textAlign: TextAlign.center,),
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 20,
                          isExpanded: true,
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 10,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          onChanged: (newValue) {
                            setState(() {
                              valueChoose = newValue as String;
                            });
                          },
                          items: listItem.map((valueItem) {
                            return DropdownMenuItem(
                              value: valueItem,
                              child: Text(valueItem),
                            );
                          }).toList(),
                        ),

                        SizedBox(
                          height: 20.0,
                        ),

                        Container(
                          alignment: Alignment.centerRight,
                          child: Column(
                            children: [
                              Text(
                                "Forgot Password ?",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 20.0,
                        ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20),
                              textStyle: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold)),
                          onPressed:
                          !emailRegex.hasMatch(_email) && _password.length < 6
                              ? null
                              : () async {
                            if (_formKey.currentState!.validate()) {
                              print(_email);
                              print(_password);

                              if(valueChoose =='Company'){
                                widget.onChangeStep(0, _email, _password);
                              } else {
                                widget.onChangeStep(1, _email, _password);
                              }

                            }
                          },
                          child: Text(
                            "Sign in".toUpperCase(),
                          ),
                        ),
                      ],
                    ),


                ),
            ],
          ),
      ]),
      ),
    ));
  }
}
