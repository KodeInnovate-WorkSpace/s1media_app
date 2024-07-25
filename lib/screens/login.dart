import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool loginLoading = false;

  @override
  void initState() {
    super.initState();
    loginLoading = false;
  }

  @override
  void dispose() {
    loginLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthController authObj = AuthController();

    return Container(
      decoration: const BoxDecoration(
        // image: DecorationImage(image: AssetImage("assets/login_bg_red.png"), fit: BoxFit.cover),
        color: Color(0xffBA1D17),
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: Center(
            child: Image.asset(
              // "assets/logo.png",
              "assets/full_logo_white.png",
              height: 80,
            ),
          ),
          toolbarHeight: 280,
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(70.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email
                      GestureDetector(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 15, left: 22, right: 0, bottom: 0),
                                child: Text(
                                  'Email',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Padding(
                                // padding: const EdgeInsets.all(12.0),
                                padding: const EdgeInsets.only(top: 0, left: 10, right: 0, bottom: 0),
                                child: SizedBox(
                                  width: 250,
                                  child: TextFormField(
                                    controller: emailController,
                                    cursorColor: const Color(0xffdc3545),
                                    keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(color: Colors.grey),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: "Enter your email address",
                                      hintStyle: TextStyle(color: Color(0xffdcdcdc)),
                                    ),
                                    autofocus: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        Get.snackbar("Please Enter Email", "Your email field is empty", snackStyle: SnackStyle.GROUNDED, colorText: Colors.white);
                                        return "";
                                      } else if (!_isValidEmail(value)) {
                                        Get.snackbar("Please enter a valid email", "The email you've entered is incorrect", snackStyle: SnackStyle.GROUNDED, colorText: Colors.white);
                                        return "";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () async {
                          HapticFeedback.selectionClick();

                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              loginLoading = true;
                            });

                            await authObj.saveUser(emailController.text);

                            // Reset loginLoading after navigation
                            setState(() {
                              loginLoading = false;
                            });
                          } else {
                            log("Email or phone is not valid");
                          }
                        },
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                          ),
                          backgroundColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                              if (states.contains(WidgetState.disabled)) {
                                return const Color(0xffBA1D17);
                              }
                              return const Color(0xffBA1D17);
                            },
                          ),
                        ),
                        child: loginLoading
                            ? const SizedBox(
                                width: 250,
                                height: 50.0,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : const SizedBox(
                                width: 250,
                                height: 50.0,
                                child: Center(
                                  child: Text(
                                    "Next",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
