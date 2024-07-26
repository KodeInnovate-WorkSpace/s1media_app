import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:s1media_app/screens/enquire_form.dart';
import 'package:s1media_app/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/user_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _current = 0;
  late List<Widget> _items;
  UserController userObj = UserController();

  @override
  void initState() {
    super.initState();
    _items = [
      buildImageContainer(
        "assets/deal_done_broker.jpeg",
        "Deal Done Brokers",
        "Video tours of properties and highlighting unique features and amenities",
      ),
      buildImageContainer(
        "assets/the_restro.jpeg",
        "The Restro",
        "Capturing the ambiance & culinary delights and showcasing special dishes & events",
      ),
      buildImageContainer("assets/autoz_plus.png", "Autoz Plus", "Updates on new and old cars and bikes, buy and sell opportunities, market trends"),
      buildImageContainer(
        "assets/the_foodizz.jpeg",
        "The Foodizz",
        "Step-by-step cooking videos and featuring professional chefs and home cooks",
      ),
      buildImageContainer(
        "assets/royalz_hotels.jpeg",
        "Royalz Hotels",
        "Virtual tours of hotel facilities and highlighting services and guest experience",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          title: const Text(
                            "Logout",
                            style: TextStyle(fontFamily: 'Gilroy-ExtraBold', color: Colors.black),
                          ),
                          content: const Text(
                            "Are you sure you want to logout?",
                            style: TextStyle(color: Colors.black),
                          ),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    style: ButtonStyle(
                                      overlayColor: WidgetStateProperty.all(Colors.red[900]),
                                    ),
                                    child: const Text(
                                      "No",
                                      style: TextStyle(color: Color(0xffEF4B4B), fontFamily: "Gilroy-Black"),
                                    )),
                                TextButton(
                                    onPressed: () async {
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      await prefs.remove('isLoggedIn');
                                      Get.offAll(() => const LoginScreen());
                                    },
                                    style: ButtonStyle(
                                      overlayColor: WidgetStateProperty.all(Colors.grey[700]),
                                    ),
                                    child: const Text(
                                      "Yes",
                                      style: TextStyle(color: Colors.black, fontFamily: "Gilroy-Black"),
                                    )),
                              ],
                            )
                          ],
                        ));
              },
              icon: const Icon(
                Icons.login,
                color: Color(0xffBA1D17),
              ))
        ],
        title: Image.asset(
          "assets/full_logo.png",
          width: 120,
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Our Services",
              style: TextStyle(
                fontFamily: "ClashDisplay",
                fontSize: 28,
              ),
            ),
            const Text(
              "At S1Media, we offer a range of services designed to showcase your business:",
              style: TextStyle(fontFamily: "ClashDisplay", fontSize: 15, color: Color(0xff8A8B8B), fontWeight: FontWeight.w100),
            ),
            const SizedBox(
              height: 25,
            ),
            CarouselSlider(
                items: _items,
                options: CarouselOptions(
                  height: 380.0,
                  autoPlay: false,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: false,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                      HapticFeedback.selectionClick();
                    });
                    // Get.snackbar("Vibration", "", duration: const Duration(milliseconds: 600));
                  },
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildDots(),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDots() {
    return List<Widget>.generate(_items.length, (int index) {
      return Container(
        width: 8.0,
        height: 8.0,
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _current == index ? const Color(0xffBA1D17) : const Color.fromRGBO(0, 0, 0, 0.1),
        ),
      );
    });
  }

  Widget buildImageContainer(String imagePath, String title, String subText) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(45.0),
        color: Colors.grey[100],
        image: DecorationImage(
          image: AssetImage(imagePath),
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
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      // Sub-text
                      Text(
                        subText,
                        style: const TextStyle(color: Colors.white),
                      ),
                      // const SizedBox(height: 8.0),
                      // Enquire button
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            var userDetails = await userObj.fetchUserDetails();
                            Get.to(() => EnquireForm(userDetails: userDetails));
                          },
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            backgroundColor: WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.disabled)) {
                                  return Colors.white;
                                }
                                return Colors.white;
                              },
                            ),
                          ),
                          child: const Text(
                            "Enquire",
                            style: TextStyle(color: Color(0xffBA1D17), fontWeight: FontWeight.bold),
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
    );
  }
}
