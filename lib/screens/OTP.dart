import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:s1media_app/screens/home.dart';
import 'package:s1media_app/screens/login.dart';
import '../controller/auth_controller.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  final String otp;

  const OtpScreen({super.key, required this.email, required this.otp});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
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
          style: TextStyle(fontSize: 17, fontFamily: 'cgb'),
        ),
        elevation: 0,
        backgroundColor: const Color(0xfff7f7f7),
        surfaceTintColor: Colors.transparent,
        leading: PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (didPop) return;

            final bool shouldPop = await _showBackDialog() ?? false;
            if (context.mounted && shouldPop) {
              Get.back();
            }
          },
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () async {
              final bool shouldPop = await _showBackDialog() ?? false;
            },
          ),
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
              // style: TextStyle(color: Color(0xffc9cace), fontSize: 16, fontFamily: 'Satoshi-Bold'),
              style: TextStyle(color: Color(0xffc9cace), fontSize: 18, fontFamily: 'cgb'),
            ),
            Text(
              widget.email,
              // style: const TextStyle(fontSize: 17, fontFamily: 'Satoshi-Medium'),
              style: const TextStyle(fontSize: 18, fontFamily: 'cgb'),
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
                          // style: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: 'Satoshi-Black'),
                          style: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: 'cgblack'),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showBackDialog() async {
    var _style = const TextStyle(fontFamily: 'cgb', color: Colors.black);
    return showDialog(
        context: context,
        useSafeArea: true,
        barrierColor: const Color.fromRGBO(0, 0, 0, 0.8),
        builder: (_) => AlertDialog(
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
              title: const Text(
                "Are You Sure?",
                style: TextStyle(fontFamily: 'cgblack', color: Color(0xffBA1D17)
                ),
              ),
              content: Text(
                "Do you want to go back and change the email address",
                style: _style,
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "No",
                      style: _style,
                    )),
                TextButton(
                    onPressed: () {
                      Get.offAll(() => const LoginScreen());
                    },
                    child: Text(
                      "Yes",
                      style: _style,
                    ))
              ],
            ));
  }
}
