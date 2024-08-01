import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:s1media_app/controller/service_controller.dart';

class AdminController {
  var logger = Logger();
  ServiceController serObj = ServiceController();
  List<Map<String, dynamic>> serData = [];
  File? _image;

  //Store new service and check if id already exist
  Future<void> storeService(String imageUrl, String title, String subText, List<String> vidUrl) async {
    try {
      serData = await serObj.fetchServiceData();
      // Check if sub-category already exists
      final querySnapshot = await FirebaseFirestore.instance.collection('service').where('title', isEqualTo: title).get();

      if (querySnapshot.docs.isNotEmpty) {
        logger.w("Sub-Category already exists");
        return;
      }
      // Calculate the new sub-category ID
      int newId = serData.length + 1;

      // Check if the ID is already used
      bool isIdUsed = true;
      while (isIdUsed) {
        final idCheckSnapshot = await FirebaseFirestore.instance.collection('service').where('id', isEqualTo: newId).get();

        if (idCheckSnapshot.docs.isEmpty) {
          isIdUsed = false;
        } else {
          newId += 1;
        }
      }

      await FirebaseFirestore.instance.collection('service').add({
        'id': newId,
        'imageUrl': imageUrl,
        'title': title,
        'subText': subText,
        'vidUrl': vidUrl,
      });
      logger.i("Service stored successfully");
      Get.snackbar("Service Added", "New service added successfully");
      Get.back();
    } catch (e) {
      logger.e("Error storing service", error: e);
      Get.snackbar("Service not added", "Something went wrong");
    }
  }

  // Upload image and add sub-category to Firestore
  Future<String> uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('/serviceImages/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      Get.snackbar("Image Uploaded", "");
      return downloadUrl;
    } catch (e) {
      logger.e("Error uploading image", error: e);
      rethrow;
    }
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }
  }

  Future<void> openCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }
  }
}
