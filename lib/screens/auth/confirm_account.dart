import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../controllers/auth_controller.dart';
import '../../helpers/globals.dart';
import '../../helpers/validator.dart';
import '../../widgets/common.dart';
import 'auth_layout.dart';


class ConfirmAccount extends StatefulWidget {
  const ConfirmAccount({super.key});

  @override
  State<ConfirmAccount> createState() => _ConfirmAccountState();
}

class _ConfirmAccountState extends State<ConfirmAccount> {

  final formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> textEditingController = {
    "cp__member_code": TextEditingController(),
  };


  @override
  Widget build(BuildContext context) {
    return authLayout(
      title: df("df_confirm_account"),
      body:
      Form(
        key: formKey,
        child: Column(
          children: [
            Text(
              df("df_enter_the_code_sent_on_your_email"),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500
              ),
            ),
          br(),

            TextFormField(
              decoration: inputDecoration(
                label: df("df_code"),
                prefixIcon: const Icon(Icons.mail),
              ),
              controller: textEditingController["cp__member_code"],
              validator: (value) {
                return !Validator.isNumber(value!) ? df("df_required_number") : null;
              },
              textInputAction: TextInputAction.next,
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
                    AuthController.confirmAccount(data);

                  }),
            ),
            br(),

          ],
        ),
      ),
    );

  }
}
