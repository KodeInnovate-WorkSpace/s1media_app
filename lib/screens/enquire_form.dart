import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:s1media_app/widget/enquire_text_field.dart';
import '../controller/user_controller.dart';

class EnquireForm extends StatefulWidget {
  final String serviceName;

  const EnquireForm({super.key, required this.serviceName});

  @override
  State<EnquireForm> createState() => _EnquireFormState();
}

class _EnquireFormState extends State<EnquireForm> {
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController serviceController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController msgController = TextEditingController();
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Send us your details, and we will get back to you",
                      style: TextStyle(fontFamily: "cgblack", fontSize: 32),
                    ),
                    const SizedBox(height: 20),
                    enquireTextField(emailController, "Enter your email address"),
                    const SizedBox(height: 20),
                    enquireTextField(phoneController, "Enter your phone number"),
                    const SizedBox(height: 20),
                    enquireTextField(serviceController, "Enter the service"),
                    const SizedBox(height: 20),
                    enquireTextField(nameController, "Enter your name"),
                    const SizedBox(height: 20),
                    enquireTextField(msgController, "Message"),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(color: const Color(0xffdc3545), borderRadius: BorderRadius.circular(10)),
                      width: double.infinity,
                      child: TextButton(
                          onPressed: () {
                            HapticFeedback.selectionClick();
                          },
                          child: const Text(
                            "Enquire",
                            style: TextStyle(color: Colors.white, fontFamily: "Satoshi-Black", fontSize: 18),
                          )),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
