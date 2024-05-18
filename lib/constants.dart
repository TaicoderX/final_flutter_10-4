import 'package:flutter/material.dart';

const mainColor = Colors.green;
const greyColor = Color(0xFF979797);
const blackColor = Colors.black;

const kAnimationDuration = Duration(milliseconds: 200);

const headingStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp RegExpEmail =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

const String emailNull = "Please Enter your email";
const String invalidEmail = "Please Enter Valid Email";
const String passwordNull = "Please Enter your password";
const String passwordShort = "Password is too short";
const String passwordMatch = "Passwords don't match";

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: const BorderSide(color: blackColor),
  );
}
