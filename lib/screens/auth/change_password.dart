import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../controllers/auth_controller.dart';
import '../../helpers/globals.dart';
import '../../helpers/validator.dart';
import '../../widgets/common.dart';
import 'auth_layout.dart';



class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> textEditingController = {
    "cp__member_code": TextEditingController(),
    "cp__member_password": TextEditingController(),
  };

  @override
  Widget build(BuildContext context) {
    return   authLayout(
        title: df("df_change_password"),
        body: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: inputDecoration(
                  label: df("df_code"),
                  prefixIcon: const Icon(Icons.numbers),
                ),
                controller: textEditingController["cp__member_code"],
                validator: (value) {
                  return !Validator.isNumber(value!) ? df("df_required_code") : null;
                },
              ),
              br(),
              inputPassword(passwordController:textEditingController["cp__member_password"] ),

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
                      AuthController.changePassword(data);
                    }),
              ),
            ],
          ),
        ));
  }
}
