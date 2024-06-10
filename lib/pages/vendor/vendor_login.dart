import 'dart:async';

import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VendorLogin extends StatefulWidget {
  const VendorLogin({Key? key}) : super(key: key);

  @override
  _VendorLoginState createState() => _VendorLoginState();
}

class _VendorLoginState extends State<VendorLogin> {
  //authmode
  String errorMessage = '';
  bool isObscured = true;
  late final StreamSubscription<AuthState> _auth;

  //controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();

  //supabase
  final supabase = Supabase.instance.client;

  //keys
  final _formKey = GlobalKey<FormState>();

  //initstate
  @override
  void initState() {
    super.initState();
    _auth = supabase.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      if (session != null) {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed("vwidget_tree");
      }
    });
  }

  //dispose
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    _auth.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(children: [
                  WidgetSpan(
                    child: Text(
                      'Make your store @ ',
                      style: TextStyle(
                        color: Colors.brown.shade500,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  WidgetSpan(
                      child: Text(
                    'eat.CAIAS',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade700,
                        fontSize: 24),
                  ))
                ]),
              ),
              const SizedBox(height: 5),
              const Text(
                  'To register your store and become a vendor, contact the developer at haririo321@gmail.com'),
              const SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          label: Text('Your Email')),
                      controller: emailController,
                      validator: (value) {
                        ValidationBuilder().email().maxLength(50).build();

                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: isObscured,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                label: Text('Password')),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "The field is required!";
                              }

                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                isObscured = !isObscured;
                              });
                            },
                            icon: isObscured
                                ? const Icon(Icons.hide_source)
                                : const Icon(Icons.password)),
                      ],
                    ),
                  ],
                ),
              )
            ],
          )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final email = emailController.text.trim();
          if (_formKey.currentState!.validate()) {
            try {
              await supabase.auth.signInWithPassword(
                  email: email, password: passwordController.text);
            } on AuthException catch (e) {
              errorMessage = e.message;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(errorMessage),
                duration: const Duration(seconds: 7),
              ));
            }
          }
        },
        label: const Text("Login"),
        icon: const Icon(Icons.login),
      ),
    );
  }
}
