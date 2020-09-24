import 'package:flutter/material.dart';
import 'package:freshgrownweb/constants/decorations.dart';
import 'package:freshgrownweb/services/authservive.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
        child: SizedBox(
          width: 400.0,
          height: 600.0,
          child: ListView(
            children: [
              Center(
                child: Text(
                  'SIGNIN TO FRESH GROWN',
                  style:
                      TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Center(
                  child: CircleAvatar(
                radius: 80.0,
                backgroundImage: AssetImage('assets/logos/001.png'),
              )),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Email'),
                          validator: (val) =>
                              val.isEmpty ? 'Enter a Admin email' : null,
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration:
                              textInputDecoration.copyWith(hintText: 'Password'),
                          validator: (val) =>
                              val.length < 6 ? 'Enter a valid password' : null,
                          obscureText: true,
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                        ),
                        SizedBox(height: 20.0),
                        SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                            elevation: 0.0,
                            color: Color.fromRGBO(0x57, 0xb8, 0x46, 1),
                            child: Text(
                              'SIGN IN',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                error = '';
                              });
                              if (_formKey.currentState.validate()) {
                                dynamic result = await _auth.signInAdmin(
                                    email.trim(), password.trim());
                                if (result == null) {
                                  setState(() {
                                    error = 'Login failed';
                                  });
                                } else {
                                  // Navigator.pushReplacement(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (BuildContext context) =>
                                  //             ProviderWidget()));
                                }
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 12.0,
                        ),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 18.0),
                        )
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
