import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_validator/form_validator.dart';
import 'package:password_strength/password_strength.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthState { login, signIn }

class Studlogin extends StatefulWidget {
  const Studlogin({Key? key}) : super(key: key);

  @override
  _StudloginState createState() => _StudloginState();
}

class _StudloginState extends State<Studlogin> {
  //authmode
  String errorMessage = '';
  bool isLogin = true;
  AuthState authMode = AuthState.login;

  //controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();

  //supabase
  final supabase = Supabase.instance.client;

  //keys
  final _formKey = GlobalKey<FormState>();
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
                segments: const <ButtonSegment<AuthState>>[
                  ButtonSegment(value: AuthState.login, label: Text('Login')),
                  ButtonSegment(
                      value: AuthState.signIn, label: Text('Sign Up')),
                ],
                selected: <AuthState>{authMode},
                onSelectionChanged: (Set<AuthState> newSelection) {
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
                          border: OutlineInputBorder(),
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
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
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
                    const SizedBox(height: 10),
                    Visibility(
                        visible: !isLogin,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
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
                            const SizedBox(height: 10),
                          ],
                        )),
                    // ElevatedButton(
                    //     style: ButtonStyle(
                    //         backgroundColor:
                    //             MaterialStatePropertyAll(Colors.amber.shade200),
                    //         shape:
                    //             MaterialStatePropertyAll(RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(6),
                    //         ))),
                    //     onPressed: () {
                    //       if (_formKey.currentState!.validate()) {
                    //         Navigator.of(context).pushReplacementNamed("/home");
                    //       }
                    //     },
                    //     child: Row(
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         const Icon(Icons.login),
                    //         const SizedBox(width: 10),
                    //         Text(isLogin ? 'Login' : "Sign Up")
                    //       ],
                    //     ))
                  ],
                ),
              )
            ],
          )),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if (isLogin) {
              final response = await supabase.auth.signInWithPassword(
                  email: emailController.text,
                  password: passwordController.text);
            } else {
              final response = await supabase.auth.signUp(
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
