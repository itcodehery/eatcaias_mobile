import 'dart:async';

import 'package:Eat.Caias/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import 'package:password_strength/password_strength.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthType { login, signIn }

class Studlogin extends StatefulWidget {
  const Studlogin({Key? key}) : super(key: key);

  @override
  _StudloginState createState() => _StudloginState();
}

class _StudloginState extends State<Studlogin> {
  //authmode
  String errorMessage = '';
  bool isLogin = true;
  bool isObscured = true;
  AuthType authMode = AuthType.login;
  late final StreamSubscription<AuthState> _auth;

  //controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();

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
        Navigator.of(context).pushReplacementNamed("/widget_tree");
      }
    });
  }

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
                      'Welcome to ',
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
              const SizedBox(height: 20),
              SegmentedButton(
                selectedIcon: const Icon(Icons.login),
                style: ButtonStyle(
                    side: MaterialStatePropertyAll(BorderSide(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    )),
                    foregroundColor: MaterialStatePropertyAll(
                        Theme.of(context).colorScheme.primary)),
                segments: const <ButtonSegment<AuthType>>[
                  ButtonSegment(value: AuthType.login, label: Text('Login')),
                  ButtonSegment(value: AuthType.signIn, label: Text('Sign Up')),
                ],
                selected: <AuthType>{authMode},
                onSelectionChanged: (Set<AuthType> newSelection) {
                  setState(() {
                    authMode = newSelection.first;
                    isLogin = !isLogin;
                  });
                },
              ),
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
                          label: Text('Your CAIAS Email')),
                      controller: emailController,
                      validator: (value) {
                        ValidationBuilder().email().maxLength(50).build();
                        if (!(value!.contains('@caias.in'))) {
                          return "Enter a CAIAS email!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: true,
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
                              if (estimatePasswordStrength(value) < 0.3) {
                                return 'Password is too weak';
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
                    const SizedBox(height: 10),
                    Visibility(
                        visible: !isLogin,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                  ),
                                  label: Text('Full Name')),
                              controller: fullNameController,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(20),
                                FilteringTextInputFormatter.singleLineFormatter,
                                FilteringTextInputFormatter.deny(" ",
                                    replacementString: "-")
                              ],
                              validator: (value) {
                                if (value == null && !isLogin) {
                                  return "The field is required!";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        )),
                  ],
                ),
              )
            ],
          )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if (isLogin) {
              try {
                await supabase.auth
                    .signInWithPassword(
                        email: emailController.text,
                        password: passwordController.text)
                    .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Logged in as ${emailController.text}'))));
              } on AuthException catch (e) {
                setState(() {
                  errorMessage = e.message;
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        '$errorMessage | Please retry by restarting the app')));
              }
            } else {
              await supabase.auth.signUp(
                  email: emailController.text,
                  password: passwordController.text,
                  data: {"username": fullNameController.text});
            }
          }
        },
        label: Text(isLogin ? "Login" : "Sign Up"),
        icon: const Icon(Icons.login),
      ),
    );
  }
}
