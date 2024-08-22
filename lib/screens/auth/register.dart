import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../controllers/auth_controller.dart';
import '../../helpers/globals.dart';
import '../../helpers/validator.dart';
import '../../widgets/common.dart';
import 'auth_layout.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> textEditingController = {
    "cp__member_first_name": TextEditingController(),
    "cp__member_last_name": TextEditingController(),
    "cp__member_email": TextEditingController(),
    "cp__member_password": TextEditingController(),
    "cp__member_phone": TextEditingController(),
  };

  String phoneNumber = '';

  String countryCode = '';

  @override
  Widget build(BuildContext context) {
    return authLayout(
        title: df("df_register"),
        body: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: inputDecoration(
                  label: df("df_first_name"),
                  prefixIcon: const Icon(Icons.person),
                ),
                controller: textEditingController["cp__member_first_name"],
                validator: (value) {
                  return Validator.isEmpty(value) ? df("df_required") : null;
                },
                textInputAction: TextInputAction.next,
              ),
              br(),
              TextFormField(
                decoration: inputDecoration(
                  label: df("df_last_name"),
                  prefixIcon: const Icon(Icons.add_card_rounded),
                ),
                controller: textEditingController["cp__member_last_name"],
                validator: (value) {
                  return Validator.isEmpty(value) ? df("df_required") : null;
                },
                textInputAction: TextInputAction.next,
              ),
              br(),
              inputEmail(emailController: textEditingController["cp__member_email"]),


              br(),
              IntlPhoneField(
                controller:textEditingController["cp__member_phone"],
                decoration: inputDecoration(
                  label: df("df_phone")
                ),
                onChanged: (phone) {
                  setState(() {
                    phoneNumber = phone.number;
                    countryCode = phone.countryCode;
                  });
                },
                validator: (value){
                  return !Validator.isPhone(value.toString()) ? df("df_required_phone") : null;
                },
              ),



              br(),
              inputPassword(passwordController:textEditingController["cp__member_password"] ),
              br(),
              TextFormField(
                decoration: inputDecoration(
                  label: df("df_confirm_password"),
                  prefixIcon: const Icon(Icons.lock_clock),
                ),
                obscureText: true,
                validator: (value) {
                  return value !=
                          textEditingController["cp__member_password"]?.text
                      ? df("df_required_confirm_password")
                      : null;
                },
              ),
              br(),
              Obx(
                () => AuthController.isLoading.value
                    ? appLoader()
                    : button(
                        text: "Submit",
                        icon: const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                        onPressed: () {

                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          textEditingController["cp__member_phone"]?.text = "$countryCode/$phoneNumber";
                          var data =
                              textEditingControllerData(textEditingController);
                          AuthController.register(data);
                        }),
              ),
            ],
          ),
        ));
  }
}
