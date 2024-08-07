import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:s1media_app/screens/login.dart';
import '../controller/auth_controller.dart';

class PhoneScreen extends StatefulWidget {
  final String email;
  const PhoneScreen({super.key, required this.email});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool phoneLoading = false;

  @override
  void initState() {
    super.initState();
    phoneLoading = false;
  }

  @override
  void dispose() {
    phoneLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthController authObj = AuthController();

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xffBA1D17),
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          title: Center(
            child: Image.asset(
              "assets/full_logo_white.png",
              height: 80,
            ),
          ),
          toolbarHeight: 180,
          leading: null,
          automaticallyImplyLeading: false,
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
                  "Phone No.",
                  // style: TextStyle(fontSize: 30, fontFamily: 'Satoshi-Black'),
                  style: TextStyle(fontSize: 35, fontFamily: 'cgblack'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Phone
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
                                  'Phone',
                                  style: TextStyle(
                                    color: Colors.black,
                                    // fontFamily: 'Satoshi-Bold',
                                    fontFamily: 'cgb',
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 0, left: 10, right: 0, bottom: 0),
                                child: SizedBox(
                                  width: 250,
                                  child: TextFormField(
                                    controller: phoneController,
                                    cursorColor: const Color(0xffdc3545),
                                    keyboardType: TextInputType.phone,
                                    // style: const TextStyle(color: Colors.grey, fontFamily: 'Satoshi-Medium'),
                                    style: const TextStyle(color: Colors.grey, fontFamily: 'cgm'),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: "Enter your phone no.",
                                      // hintStyle: TextStyle(color: Color(0xffdcdcdc), fontFamily: 'Satoshi-Medium'),
                                      hintStyle: TextStyle(color: Color(0xffdcdcdc), fontFamily: 'cgm'),
                                    ),
                                    autofocus: true,
                                    inputFormatters: [LengthLimitingTextInputFormatter(10), FilteringTextInputFormatter.digitsOnly],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        Get.snackbar(
                                          "Empty Phone Field",
                                          "Please enter phone no.",
                                          snackStyle: SnackStyle.GROUNDED,
                                          colorText: Colors.white,
                                        );
                                        return "";
                                      } else if (value.length != 10) {
                                        Get.snackbar(
                                          "Invalid Phone Number",
                                          "The phone you've entered is not 10 digits.",
                                          snackStyle: SnackStyle.GROUNDED,
                                          colorText: Colors.white,
                                        );
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
                              phoneLoading = true;
                            });
                            await authObj.sendMail(widget.email, authObj.generateOtp());
                            await authObj.updateField(widget.email, 'phone', phoneController.text);

                            // Reset Loading after navigation
                            setState(() {
                              phoneLoading = false;
                            });
                          } else {
                            log("phone is not valid");
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
                        child: phoneLoading
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
                                    // style: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: 'Satoshi-Black'),
                                    style: TextStyle(color: Colors.white, fontSize: 18.0, fontFamily: 'cgblack'),
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
}
