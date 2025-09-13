import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:todoapp/service/auth_service.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({super.key});

  @override
  State<PhoneAuthPage> createState() => _PhoneAuthPageState();
}

class _PhoneAuthPageState extends State<PhoneAuthPage> {

  int start = 30;
  bool wait = false;
  String buttonName = "Send";

  TextEditingController phoneController = TextEditingController();
  AuthClass authClass = AuthClass();
  String verificationId = "";
  String otp = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Signup',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 100),
              phoneTextField(),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width - 30,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                    Text("Enter 6 digit OTP" ,style: TextStyle(color: Colors.white, fontSize: 16),),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              otpField(),
              SizedBox(height: 20),
              RichText(text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Send OTP again in',
                    style: TextStyle(color: Colors.yellowAccent, fontSize: 16),
                  ),
                TextSpan(
                    text: "00:$start",
                    style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
              ),
                  TextSpan(
                    text: " sec",
                    style: TextStyle(color: Colors.yellowAccent, fontSize: 16),
                  ),
                  TextSpan(
                    text: ""
                  ),
                ]
              )),
              SizedBox(height: 20),

              InkWell(
                onTap: () {
                  // Handle OTP verification
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red, Colors.orange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      'Verify OTP',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget phoneTextField() {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextFormField(
        controller: phoneController,
        keyboardType: TextInputType.phone,
        style: TextStyle(color: Colors.white, fontSize: 17),// ✅ This shows numeric keypad
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Enter your Phone Number',
          hintStyle: TextStyle(color: Colors.white54, fontSize: 17),
          contentPadding: EdgeInsets.symmetric(vertical: 19, horizontal: 8),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            child: Text(
              "(+92)",
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),
          suffixIcon: InkWell(
            onTap: wait ? null : () async {
              StartTimer();
              setState(() {
                start = 30;
                wait = true;
                buttonName = "Resend";
              });
              await authClass.verifyPhoneNumber(
                "+92${phoneController.text}",
                context,
                setData,
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Text(
                buttonName,
                style: TextStyle(
                  color: wait ? Colors.grey : Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      )
    );
  }

  Widget otpField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: OtpTextField(
        numberOfFields: 6,
        borderRadius: BorderRadius.circular(12),
        fieldWidth: 45,
        showFieldAsBox: true,
        filled: true,
        fillColor: Colors.white.withOpacity(0.15),
        borderColor: Colors.white.withOpacity(0.3),
        focusedBorderColor: Colors.blueAccent,
        cursorColor: Colors.blueAccent,
        textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        onCodeChanged: (code) {},
        onSubmit: (verificationCode) {},
      ),
    );
  }


  void StartTimer() {
    const oneSec = Duration(seconds: 1);
    Timer timer = Timer.periodic(oneSec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          wait = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  void setData() {
    setState(() {
      verificationId = verificationId;

    });
    StartTimer();
  }
}
