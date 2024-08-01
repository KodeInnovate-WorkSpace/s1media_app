import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:s1media_app/controller/service_controller.dart';

class AdminController {
  var logger = Logger();
  ServiceController serObj = ServiceController();
  List<Map<String, dynamic>> serData = [];

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
    } catch (e) {
      logger.e("Error storing service", error: e);
    }
  }
}
