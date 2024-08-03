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
  File? imageFile;

  //Store new service and check if id already exist
  Future<void> storeService(String imageUrl, String title, String subText, List<String> vidUrl) async {
    try {
      serData = await serObj.fetchServiceData();
      // Check if service already exists
      final querySnapshot = await FirebaseFirestore.instance.collection('service').where('title', isEqualTo: title).get();

      if (querySnapshot.docs.isNotEmpty) {
        Get.snackbar("Service already exists", "Service with the same title already exist in database");
        logger.w("Service already exists");
        return;
      }
      // Calculate the new service ID
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
      Get.snackbar("Service Added", "New service added successfully");
      logger.i("Service stored successfully");
    } catch (e) {
      Get.snackbar("Service not added", "Something went wrong");
      logger.e("Error storing service", error: e);
    }
  }

  // Upload image and add service to Firestore
  Future<String> uploadImage() async {
    if (imageFile == null) {
      throw Exception("No image selected");
    }

    try {
      final storageRef = FirebaseStorage.instance.ref().child('/serviceImages/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageRef.putFile(imageFile!);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      Get.snackbar("Error uploading image", "Something went wrong");
      logger.e("Error uploading image", error: e);
      rethrow;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
  }
}
