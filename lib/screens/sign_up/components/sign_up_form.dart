import 'package:flutter/material.dart';
import 'package:shop_app/components/IconSurf.dart';

import '../../../components/handle_error.dart';
import '../../../constants.dart';
import '../../register_success/register_success_screen.dart';
import '../../../controllers/user.controller.dart';
import 'package:quickalert/quickalert.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? conform_password;
  bool remember = false;
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
              password = value;
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
          TextFormField(
            obscureText: true,
            onSaved: (newValue) => conform_password = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: passwordNull);
              } else if (value.isNotEmpty && password == conform_password) {
                removeError(error: passwordMatch);
              }
              conform_password = value;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: passwordNull);
                return "";
              } else if ((password != value)) {
                addError(error: passwordMatch);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Confirm Password",
              hintText: "Re-enter your password",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: IconSurf(svg: "assets/icons/Lock.svg"),
            ),
          ),
          HandleError(errors: errors),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );
                _formKey.currentState!.save();
                try {
                  final data =
                      await registerAPI(email: email, password: password);
                  if (data['error'] != null) {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      text: data['error'],
                    );
                    return;
                  }
                  Navigator.pushNamed(context, RegisterSuccessScreen.routeName);
                } catch (error) {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.error,
                    text: 'Something went wrong!',
                  );
                }
              }
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }
}
