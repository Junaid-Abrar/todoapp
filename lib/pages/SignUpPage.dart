import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:todoapp/pages/SignInPage.dart';
import 'package:todoapp/pages/phoneAuthPage.dart';

import '../service/auth_service.dart';
import 'HomePage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool circular = false;
  bool _obscurePassword = true;

  AuthClass authClass = AuthClass();

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign Up",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              textItem(context, 'Email', emailController, false, TextInputType.emailAddress),
              SizedBox(height: 15),
              textItem(context, 'Password', passController, true, TextInputType.visiblePassword),
              SizedBox(height: 30),
              colorButton(context),
              SizedBox(height: 20),
              Text("Or", style: TextStyle(color: Colors.white, fontSize: 17)),
              SizedBox(height: 20),
              buttonItem(context, "assets/google.svg", "Continue with Google", 25 , () async{
                await authClass.googleSignInMethod(context);
              }),
              SizedBox(height: 15),
              buttonItem(context, "assets/phone.svg", "Continue with Phone", 25 , () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PhoneAuthPage()));
              }),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?",
                      style: TextStyle(color: Colors.white, fontSize: 17)),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignInPage()), (route) => false);
                    },
                    child: Text("Login",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }

  Widget buttonItem(
      BuildContext context, String imagePath, String buttonName, double size, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width - 60,
        height: 50,
        child: Card(
          color: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Colors.grey, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imagePath.endsWith('.svg')
                  ? SvgPicture.asset(
                      imagePath,
                      height: size,
                      width: size,
                    )
                  : Image.asset(
                      imagePath,
                      height: size,
                      width: size,
                    ),
              SizedBox(width: 15),
              Text(
                buttonName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textItem(BuildContext context, String labelText,
      TextEditingController controller, bool obscureText, TextInputType keyboardType) {
    return Container(
      width: MediaQuery.of(context).size.width - 70,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText && _obscurePassword,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: 17, color: Colors.white),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                width: 2,
                color: Colors.amber,
              )),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                width: 2,
                color: Colors.red,
              )),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                width: 2,
                color: Colors.red,
              )),
          labelText: labelText,
          labelStyle: TextStyle(fontSize: 16, color: Colors.white70),
          errorStyle: TextStyle(color: Colors.red, fontSize: 14),
          prefixIcon: Icon(
            labelText.toLowerCase() == 'email' ? Icons.email_outlined : Icons.lock_outline,
            color: Colors.white70,
          ),
          suffixIcon: obscureText ? IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.white70,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ) : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.5),
          ),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter your ${labelText.toLowerCase()}';
          }
          if (labelText.toLowerCase() == 'email') {
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email address';
            }
          }
          if (labelText.toLowerCase() == 'password') {
            if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
          }
          return null;
        },
      ),
    );
  }

  Widget colorButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (!_formKey.currentState!.validate()) {
          return;
        }
        
        String email = emailController.text.trim();
        String password = passController.text.trim();

        setState(() {
          circular = true;
        });

        try {
          await firebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          print("User created: $email");

          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
        }
        catch (e) {

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        } finally {
          setState(() {
            circular = false;
          });
        }
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width - 90,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red, Colors.orange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: circular
              ? CircularProgressIndicator(color: Colors.white)
              : Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
