import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../helpers/globals.dart';
import '../../widgets/common.dart';
import 'auth_layout.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key,this.title="df_forgot_password"});
  final String title;

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();

  final Map<String, TextEditingController> textEditingController = {
    "cp__member_email": TextEditingController(),
    "cp__member_password": TextEditingController(),
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(isAuth()){
      textEditingController["cp__member_email"]?.text = auth("cp__member_email");
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      authLayout(
        title: df(widget.title),
        body: Form(
          key: formKey,
          child: Column(
            children: [
              inputEmail(emailController: textEditingController["cp__member_email"]),
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
                          AuthController.forgotPassword(data);
                        }),
              ),
            ],
          ),
        ));
  }
}
