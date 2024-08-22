import 'package:flutter/material.dart';

import '../helpers/globals.dart';

class Flight extends StatelessWidget {
  Flight({super.key});

  final formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> textEditingController = {
    "cp__member_email": TextEditingController(),
    "cp__member_password": TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    parr("kkkkkkkkkkkkkk");
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/logo.png"),
      ),
    );
  }
}
