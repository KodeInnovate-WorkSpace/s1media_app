import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:s1media_app/controller/admin_controller.dart';
import 'package:s1media_app/widget/enquire_text_field.dart';
import '../controller/user_controller.dart';

class AddService extends StatefulWidget {
  const AddService({super.key});

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  final _formkey = GlobalKey<FormState>();
  AdminController adminObj = AdminController();

  TextEditingController titleController = TextEditingController();
  TextEditingController subTextController = TextEditingController();
  TextEditingController imgUrlController = TextEditingController();
  List<TextEditingController> vidUrlControllers = [TextEditingController()];
  UserController userObj = UserController();

  String? initialDropdownValue;
  File? _image;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    subTextController.dispose();
    imgUrlController.dispose();
    for (var controller in vidUrlControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addVideoUrlField() {
    setState(() {
      vidUrlControllers.add(TextEditingController());
    });
  }

  void _removeVideoUrlField(int index) {
    setState(() {
      if (vidUrlControllers.length > 1) {
        vidUrlControllers[index].dispose();
        vidUrlControllers.removeAt(index);
      }
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage(File image) async {
    final storageRef = FirebaseStorage.instance.ref().child('/serviceImages/${DateTime.now().millisecondsSinceEpoch}');
    final uploadTask = storageRef.putFile(image);
    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();
    Get.snackbar("Image Uploaded", "");
    return downloadUrl;
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
                      // Camera and Gallery
                      _image != null ? Image.file(_image!, height: 100, width: 100) : const Text("No image selected"),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xfff7f8fa),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xffE8E9EB), width: 1),
                            ),
                            child: TextButton(
                              onPressed: () => _pickImage(ImageSource.camera),
                              style: ButtonStyle(overlayColor: WidgetStateProperty.all(Colors.transparent)),
                              child: const Text(
                                "Open Camera",
                                style: TextStyle(color: Colors.grey, fontFamily: "cgb", fontSize: 15),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xfff7f8fa),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xffE8E9EB), width: 1),
                            ),
                            // width: double.infinity,
                            child: TextButton(
                              onPressed: () => _pickImage(ImageSource.gallery),
                              style: ButtonStyle(overlayColor: WidgetStateProperty.all(Colors.transparent)),
                              child: const Text(
                                "Open Gallery",
                                style: TextStyle(color: Colors.grey, fontFamily: "cgb", fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

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

                      // Vid Url
                      Column(
                        children: vidUrlControllers.asMap().entries.map((entry) {
                          int index = entry.key;
                          TextEditingController controller = entry.value;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              children: [
                                Expanded(
                                  child: enquireTextField(controller, "Video URL ${index + 1}", setState, (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter video url';
                                    }
                                    return null;
                                  }),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle),
                                  onPressed: () => _removeVideoUrlField(index),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          _addVideoUrlField();
                        },
                        child: const Text(
                          "Add Another Video URL",
                          style: TextStyle(color: Color(0xffdc3545), fontFamily: 'cgb', fontSize: 15),
                        ),
                      ),
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
                          List<String> vidUrlsList = vidUrlControllers.map((controller) => controller.text).toList();
                          String imgUrl = '';
                          if (_image != null) {
                            imgUrl = await _uploadImage(_image!);
                          }
                          await adminObj.storeService(
                            imgUrl,
                            titleController.text,
                            subTextController.text,
                            vidUrlsList,
                          );
                        } else {
                          Get.snackbar("Empty Field", "Please fill necessary details to continue", duration: const Duration(milliseconds: 600));
                        }
                      },
                      child: const Text(
                        "Add Service",
                        style: TextStyle(color: Colors.white, fontFamily: "cgblack", fontSize: 19),
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
