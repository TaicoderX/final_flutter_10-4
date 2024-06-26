import 'package:flutter/material.dart';

import '../../components/RoundSocal.dart';
import '../../constants.dart';
import 'components/sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";

  const SignUpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Sign Up",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    const Text("Register Account", style: headingStyle),
                    const Text(
                      "Complete your details or continue \nwith social media",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const SignUpForm(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RoundSocal(
                          icon: "assets/icons/google-icon.svg",
                          press: () {},
                        ),
                        RoundSocal(
                          icon: "assets/icons/facebook-2.svg",
                          press: () {},
                        ),
                        RoundSocal(
                          icon: "assets/icons/twitter.svg",
                          press: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'By continuing your confirm that you agree \nwith our Term and Condition',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
