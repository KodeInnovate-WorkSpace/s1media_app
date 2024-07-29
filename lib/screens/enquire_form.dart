import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:s1media_app/widget/enquire_text_field.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/user_controller.dart';

class EnquireForm extends StatefulWidget {
  final String serviceName;

  const EnquireForm({super.key, required this.serviceName});

  @override
  State<EnquireForm> createState() => _EnquireFormState();
}

class _EnquireFormState extends State<EnquireForm> {
  final _formkey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController msgController = TextEditingController();
  TextEditingController serviceController = TextEditingController();
  UserController userObj = UserController();

  @override
  void initState() {
    super.initState();
    serviceController.text = widget.serviceName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        toolbarHeight: 40,
      ),
      body: StreamBuilder<Map<String, String?>>(
        stream: userObj.getUserDetailsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: Colors.red,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No user details available'));
          } else {
            final userDetails = snapshot.data!;
            emailController.text = userDetails['email'] ?? '';
            phoneController.text = userDetails['phone'] ?? '';

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Send us your details, and we will get back to you",
                        style: TextStyle(
                          fontFamily: "cgblack",
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(height: 20),
                      StatefulBuilder(builder: (context, setState) {
                        return Column(
                          children: [
                            //Email
                            enquireTextField(emailController, "Enter your email address", setState, (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is empty';
                              }
                              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                return 'Enter a valid email';
                              }
                              return null;
                            }),
                            const SizedBox(height: 20),

                            //Phone
                            enquireTextField(phoneController, "Enter your phone number", setState, (value) {
                              if (value == null || value.isEmpty) {
                                return 'Phone number is empty';
                              }
                              if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                return 'Enter a valid phone number';
                              }
                              return null;
                            }),
                            const SizedBox(height: 20),

                            //Service
                            enquireTextField(serviceController, "Enter the service", setState, (value) {
                              if (value == null || value.isEmpty) {
                                return 'Service is empty';
                              }
                              return null;
                            }),
                            const SizedBox(height: 20),

                            //Name
                            enquireTextField(nameController, "Enter your name", setState, (value) {
                              if (value == null || value.isEmpty) {
                                return 'Name is empty';
                              }
                              return null;
                            }),
                            const SizedBox(height: 20),

                            //Message
                            enquireTextField(msgController, "Message", setState, (value) {
                              if (value == null || value.isEmpty) {
                                return 'Message is empty';
                              }
                              return null;
                            }),
                          ],
                        );
                      }),
                      const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(color: const Color(0xffdc3545), borderRadius: BorderRadius.circular(10)),
                        width: double.infinity,
                        child: TextButton(
                            onPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                HapticFeedback.selectionClick();
                                await sendWhatsAppMessage();
                              } else {
                                Get.snackbar("Empty Field", "Please fill necessary details to continue", duration: const Duration(milliseconds: 600));
                              }
                            },
                            child: const Text(
                              "Enquire",
                              style: TextStyle(color: Colors.white, fontFamily: "Satoshi-Black", fontSize: 18),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> sendWhatsAppMessage() async {
    String email = emailController.value.text;
    String phone = phoneController.value.text;
    String name = nameController.value.text;
    String message = msgController.value.text;
    String service = serviceController.text;

    // if (email.isEmpty || phone.isEmpty || service.isEmpty || name.isEmpty || message.isEmpty) {
    //   // Get.snackbar("Empty Field", "Please fill necessary details to continue", duration: const Duration(milliseconds: 600));
    //   log('Please fill all the fields');
    //   return;
    // }

    String fullMessage = "Email: $email\nPhone: $phone\nService: $service\nName: $name\n $message";
    String phoneNumber = dotenv.env['RECEIVER_PHONE']!; // Replace with the recipient's phone number

    // Construct the WhatsApp URL
    String whatsappUrl = "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(fullMessage)}";

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      log('Could not launch $whatsappUrl');
    }
  }
}
