import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helpers/http_helper.dart';
import '../widgets/common.dart';
import 'index.dart';


class HttpError extends StatefulWidget {
  const HttpError({super.key});

  @override
  State<HttpError> createState() => _HttpErrorState();
}

class _HttpErrorState extends State<HttpError> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.network_check_sharp,
                color: Colors.black,
                size: 150,
              ),
              Text(
                HttpHelper.getErrorText(),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize:30),
              ),
              br(),
              SizedBox(
                width: 300,
                child: button(
                  icon: const Icon(Icons.refresh,color: Colors.white,),
                  text: "Try Again",
                  onPressed: (){
                    Get.offAll(()=>const Index());
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
