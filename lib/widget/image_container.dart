import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../model/myservice.dart';
import '../screens/enquire_form.dart';
import '../screens/video.dart';

Widget buildImageContainer(MyService service, List<MyService> myServices) {
  return GestureDetector(
    onTap: () {
      Get.to(() => const VideoScreen());
    },
    child: Container(
      width: double.infinity,
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(45.0),
        color: Colors.grey[100],
        image: DecorationImage(
          image: AssetImage(service.imagePath),
          fit: BoxFit.fill,
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(45.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.black.withOpacity(0.2),
                  height: 158,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        service.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "cgblack",
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      // Sub-text
                      Text(
                        service.subText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "cgb",
                        ),
                      ),
                      // Enquire button
                      Center(
                        child: OutlinedButton(
                          onPressed: () async {
                            HapticFeedback.selectionClick();
                            Get.to(
                              () => EnquireForm(serviceName: service.title, services: myServices.map((s) => s.title).toList()),
                              // transition: Transition.rightToLeft,
                              transition: Transition.fadeIn,
                              duration: const Duration(milliseconds: 500),
                              // curve: Curves.easeInOut,
                            );
                          },
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            side: WidgetStateProperty.all<BorderSide>(
                              const BorderSide(
                                color: Color(0xffBA1D17), // Set the border color
                                width: 2.5, // Set the border width
                              ),
                            ),
                          ),
                          child: const Text(
                            "Enquire",
                            style: TextStyle(color: Colors.white, fontFamily: 'cgblack'),
                          ),
                        ),
                      ),
                    ],
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
