import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/components/IconSurf.dart';
import 'package:shop_app/screens/init_screen.dart';
import '../../../components/handle_error.dart';
import '../../../constants.dart';
import '../../../helper/keyboard.dart';
import '../../forgot_password/forgot_password_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quickalert/quickalert.dart';
import '../../../controllers/user.controller.dart';

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool? remember = false;
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => email = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: emailNull);
              } else if (RegExpEmail.hasMatch(value)) {
                removeError(error: invalidEmail);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: emailNull);
                return "";
              } else if (!RegExpEmail.hasMatch(value)) {
                addError(error: invalidEmail);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "Enter your email",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: IconSurf(svg: "assets/icons/Mail.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            obscureText: true,
            onSaved: (newValue) => password = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: passwordNull);
              } else if (value.length >= 6) {
                removeError(error: passwordShort);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: passwordNull);
                return "";
              } else if (value.length < 6) {
                addError(error: passwordShort);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Password",
              hintText: "Enter your password",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: IconSurf(svg: "assets/icons/Lock.svg"),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: mainColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              const Text("Remember me"),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: const Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          HandleError(errors: errors),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 4,
                child: SizedBox(
                  width: 240,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        KeyboardUtil.hideKeyboard(context);
                        // EasyLoading.show(status: 'loading...');
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.loading,
                          title: 'Loading',
                          text: 'Loading...',
                        );
                        try {
                          final data =
                              await loginAPI(email: email, password: password)
                                  .timeout(const Duration(seconds: 15));
                          Navigator.pop(context);
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          if (data['error'] != null) {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              text: data['error'],
                            );
                            return;
                          }
                          final dataUser = json.encode(data['user']);
                          await prefs.setString('data', dataUser);
                          
                          await prefs.setString('token', data['token']);
                          Navigator.pushNamedAndRemoveUntil(context, InitScreen.routeName, (route) => false,);
                        } catch (e) {
                          // EasyLoading.dismiss();
                          Navigator.pop(context);
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.info,
                            text: 'Cannot connect to server',
                          );
                        }
                      }
                    },
                    child: const Text(
                      "Continue",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              
            ],
          ),
        ],
      ),
    );
  }
}
