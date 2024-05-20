import 'dart:async';

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
  late final StreamSubscription<AuthState> _authSubscription;

  //controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();

  //supabase
  final supabase = Supabase.instance.client;

  //keys
  final _formKey = GlobalKey<FormState>();

  //initState
  @override
  void initState() {
    super.initState();
    _authSubscription = supabase.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      if (session != null) {
        Navigator.of(context).pushReplacementNamed("/widget_tree");
      }
    });
  }

  //dispose
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    _authSubscription.cancel();
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
                      'Find your eats @ ',
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
              const SizedBox(height: 10),
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
              const SizedBox(height: 20),
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
                    const SizedBox(height: 20),
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
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
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
                final email = emailController.text.trim();

                await supabase.auth.signInWithPassword(
                    email: email, password: passwordController.text);

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Logged in as $email!'),
                    backgroundColor: const Color.fromARGB(255, 147, 83, 0),
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(10),
                  ));
                }
              } on AuthException catch (error) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(error.message)));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Error Occurred! Please retry.')));
              }
            } else {
              final email = emailController.text.trim();
              final username = fullNameController.text.trim();
              await supabase.auth.signUp(
                  email: email,
                  password: passwordController.text,
                  data: {"username": username});
              //below 2 lines don't work
              await supabase
                  .from('studteach_user')
                  .insert({'email': email, 'username': username});
            }
          }
        },
        label: Text(isLogin ? "Login" : "Sign Up"),
        icon: const Icon(Icons.login),
      ),
    );
  }
}
