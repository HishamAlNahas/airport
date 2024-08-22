import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';


import '../../controllers/auth_controller.dart';
import '../../helpers/globals.dart';
import '../../helpers/validator.dart';
import '../../widgets/common.dart';
import 'auth_layout.dart';
import 'forgot_password.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final formKey = GlobalKey<FormState>();

  String phoneNumber = '';
  String countryCode = '';
  String countryCodeNum = '';

  final Map<String, TextEditingController> textEditingController = {
    "cp__member_first_name": TextEditingController(),
    "cp__member_last_name": TextEditingController(),
    "cp__member_email": TextEditingController(),
    "cp__member_phone": TextEditingController(),
    "cp__member_country": TextEditingController(),
    "cp__member_city": TextEditingController(),
  };
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(isAuth()){
    textEditingController["cp__member_first_name"]?.text = auth("cp__member_first_name");
    textEditingController["cp__member_last_name"]?.text = auth("cp__member_last_name");
    textEditingController["cp__member_email"]?.text = auth("cp__member_email");
    textEditingController["cp__member_country"]?.text = auth("cp__member_country");
    textEditingController["cp__member_city"]?.text = auth("cp__member_city");

      setInitialPhoneNumber(auth("cp__member_phone"));
    }



  }

  void setInitialPhoneNumber(String dbPhoneNumber) {

    List<String> parts = dbPhoneNumber.split('/');
    if (parts.length == 2) {
      Country country =  PhoneNumber.getCountry(parts[0]);
      setState(() {
        countryCode =country.code;
        countryCodeNum = parts[0];
        phoneNumber = parts[1];
      });
      textEditingController["cp__member_phone"]?.text = parts[1];
    }


  }

  @override
  Widget build(BuildContext context) {
    return
    authRequired(
        authLayout(
        actions: [
          IconButton(onPressed: (){
            AuthController.logout();
          }, icon:const Icon(Icons.logout))
        ],
        title: df("df_profile"),
        body:
        Form(
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

              br(),
              IntlPhoneField(
                controller: textEditingController["cp__member_phone"],
                decoration: inputDecoration(
                  label: df("df_phone"),
                ),
                initialCountryCode: countryCode,

                initialValue: phoneNumber,
                onChanged: (phone) {
                  setState(() {
                    phoneNumber = phone.number;
                    countryCodeNum = phone.countryCode;
                  });
                },
                validator: (phone) {
                  return phone == null || Validator.isPhone(phone.number) ? df("df_required_phone") : null;
                },
              ),

              br(),
              TextFormField(
                decoration: inputDecoration(
                  label: df("df_country"),
                  prefixIcon: const Icon(Icons.lock_clock),
                ),
                controller: textEditingController["cp__member_country"],
                validator: (value) {
                  return Validator.isEmpty(value) ? df("df_required") : null;
                },
                textInputAction: TextInputAction.next,
              ),
              br(),
              TextFormField(
                decoration: inputDecoration(
                  label: df("df_city"),
                  prefixIcon: const Icon(Icons.lock_clock),
                ),
                controller: textEditingController["cp__member_city"],
                validator: (value) {
                  return Validator.isEmpty(value) ? df("df_required") : null;
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
                      textEditingController["cp__member_phone"]?.text = "$countryCodeNum/$phoneNumber";
                      var data =
                      textEditingControllerData(textEditingController);
                      AuthController.updateProfile(data);
                      textEditingController["cp__member_phone"]?.text = phoneNumber;
                    }),
              ),
              br(),
              InkWell(
                onTap: () {

                  // var data = {"cp__member_email":auth("cp__member_email")};

                  // AuthController.forgotPassword(data);
                  Get.to(() =>  ForgotPassword(title: df("df_confirm_email"),), transition: appTransition());
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    df("df_change_password"),
                  ),
                ),
              ),
            ],
          ),
        )

    ));




  }
}
