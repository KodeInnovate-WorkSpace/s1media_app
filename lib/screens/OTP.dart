import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:s1media_app/screens/home.dart';
import '../controller/auth_controller.dart';

class OTPScreen extends StatefulWidget {
  final String email;
  final String otp;

  const OTPScreen({super.key, required this.email, required this.otp});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();

  bool otpLoading = false;

  @override
  void initState() {
    super.initState();
    otpLoading = false;
  }

  @override
  void dispose() {
    otpLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthController authObj = AuthController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "OTP Verification",
          style: TextStyle(fontSize: 17),
        ),
        elevation: 0,
        backgroundColor: const Color(0xfff7f7f7),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      backgroundColor: const Color(0xfff7f7f7),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "We've sent a verification code to",
              style: TextStyle(fontFamily: "Gilroy-Bold", color: Color(0xffc9cace), fontSize: 16),
            ),
            Text(
              widget.email,
              style: const TextStyle(fontFamily: "Gilroy-SemiBold", fontSize: 17),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Pinput(
                controller: _otpController,
                keyboardType: TextInputType.number,
                length: 6,
                autofocus: true,
                defaultPinTheme: PinTheme(height: 60, width: 60, decoration: BoxDecoration(color: const Color(0xffEAEAEA), border: Border.all(color: Colors.transparent), borderRadius: BorderRadius.circular(6))),
                onCompleted: (pin) async {
                  // await _verifyOtp(pin);
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                HapticFeedback.selectionClick();

                if (widget.otp == _otpController.text) {
                  setState(() {
                    otpLoading = true;
                  });

                  await authObj.setLoginState(true);
                  await authObj.setUserEmail(widget.email);
                  Get.offAll(() => const HomeScreen());

                  //reset loading
                  setState(() {
                    otpLoading = false;
                  });
                } else {
                  Get.snackbar("Incorrect OTP", "Try Correcting or passing a valid OTP");
                  log("Wrong OTP");
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
              child: otpLoading
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
                          "Verify",
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
    );
  }
}
