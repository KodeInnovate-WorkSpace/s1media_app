import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:s1media_app/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('isLoggedIn');
                Get.offAll(() => const LoginScreen());
              },
              icon: const Icon(Icons.login))
        ],
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
              "Choose your service ",
              style: TextStyle(fontSize: 28, color: Color(0xff8A8B8B)),
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
                    Get.snackbar("Vibration", "", duration: const Duration(milliseconds: 600));
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

  final List<Widget> _items = [
    Container(
      width: double.infinity,
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(45.0),
        color: Colors.grey[100],
        image: const DecorationImage(image: AssetImage("assets/deal_done_broker.jpeg"), fit: BoxFit.fill),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              "Deal Done Brokers",
              style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
            ),

            //sub-text
            const Text(
              "Video tours of properties and Highlighting uniue features and amenities",
              style: TextStyle(color: Colors.white),
            ),
            Center(
              child: ElevatedButton(onPressed: () {}, child: const Text("Enquire")),
            )
          ],
        ),
      ),
    ),
    Container(
      width: double.infinity,
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(45.0),
        color: Colors.grey[100],
        image: const DecorationImage(image: AssetImage("assets/the_restro.jpeg"), fit: BoxFit.fill),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              "The Restro",
              style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
            ),

            //sub-text
            const Text(
              "Capturing the ambiance & culinary delights and Showcasing special dishes & events",
              // maxLines: 1,

              // style: TextStyle(color: Color(0xff8A8B8B)),
              style: TextStyle(color: Colors.white),
            ),

            Center(
              child: ElevatedButton(onPressed: () {}, child: const Text("Enquire")),
            )
          ],
        ),
      ),
    ),
  ];

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
}
