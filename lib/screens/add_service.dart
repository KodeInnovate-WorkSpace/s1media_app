import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:s1media_app/widget/enquire_text_field.dart';
import '../controller/user_controller.dart';

class AddService extends StatefulWidget {
  const AddService({super.key});

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  final _formkey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController subTextController = TextEditingController();
  TextEditingController imgUrlController = TextEditingController();
  TextEditingController vidUrlController = TextEditingController();
  UserController userObj = UserController();

  String? initialDropdownValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        toolbarHeight: 40,
        title: const Text(
          "Add Service",
          style: TextStyle(
            fontFamily: "cgblack",
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                StatefulBuilder(builder: (context, setState) {
                  return Column(
                    children: [
                      //Title
                      enquireTextField(titleController, "Title", setState, (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter title';
                        }
                        return null;
                      }),
                      const SizedBox(height: 20),

                      //Sub-Text
                      enquireTextField(subTextController, "Sub-Text", setState, (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter sub-text';
                        }
                        return null;
                      }),
                      const SizedBox(height: 20),

                      //Image
                      enquireTextField(imgUrlController, "Image URL", setState, (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter image url';
                        }
                        return null;
                      }),
                      const SizedBox(height: 20),

                      //Video
                      enquireTextField(vidUrlController, "Video URLs", setState, (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter video url';
                        }
                        return null;
                      }),
                      const SizedBox(height: 20),

                      const SizedBox(height: 20),
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
                        } else {
                          Get.snackbar("Empty Field", "Please fill necessary details to continue", duration: const Duration(milliseconds: 600));
                        }
                      },
                      child: const Text(
                        "Add Service",
                        style: TextStyle(color: Colors.white, fontFamily: "Satoshi-Black", fontSize: 18),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
