import 'package:flutter/material.dart';

 ValueNotifier <bool> isbutten = ValueNotifier(false);

 
void checkcontroler({
  required TextEditingController email,
  required TextEditingController password,
  required TextEditingController userbane,
}) {
  // ignore: unused_local_variable
  email.addListener(() {
    if (email.text.isNotEmpty &&
        password.text.isNotEmpty &&
        userbane.text.isNotEmpty) {
      isbutten.value = true;
    } else {
      isbutten.value = false;
    }
  });
  password.addListener(() {
    if (email.text.isNotEmpty &&
        password.text.isNotEmpty &&
        userbane.text.isNotEmpty) {
      isbutten.value = true;
    } else {
      isbutten.value = false;
    }
  });
  userbane.addListener(() {
    if (email.text.isNotEmpty &&
        password.text.isNotEmpty &&
        userbane.text.isNotEmpty) {
      isbutten.value = true;
    } else {
      isbutten.value = false;
    }
  });
}
