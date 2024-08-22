import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../helpers/globals.dart';
import '../../widgets/common.dart';
import 'auth_layout.dart';
import 'confirm_account.dart';
import 'forgot_password.dart';
import 'register.dart';

class Login extends StatelessWidget {
  Login({super.key});

  final formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> textEditingController = {
    "cp__member_email": TextEditingController(),
    "cp__member_password": TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    return authLayout(
        title: df("df_login"),
        body:
        Form(
          key: formKey,
          child: Column(
            children: [
              inputEmail(emailController: textEditingController["cp__member_email"]),
              br(),
              inputPassword(passwordController:textEditingController["cp__member_password"] ),
              br(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(() => const ForgotPassword(),
                          transition: appTransition());
                    },
                    child: Text(
                      df("df_forgot_password"),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  )
                ],
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
                          var data =
                              textEditingControllerData(textEditingController);
                          AuthController.login(data);
                          // Get.to(() => Profile(), transition: appTransition());
                        }),
              ),
              br(),
              InkWell(
                onTap: () {
                  Get.to(() => const Register(), transition: appTransition());
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    df("df_register"),
                  ),
                ),
              ),
              br(),
              InkWell(
                onTap: () {
                  Get.to(() => const ConfirmAccount(), transition: appTransition());
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    df("df_register"),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
