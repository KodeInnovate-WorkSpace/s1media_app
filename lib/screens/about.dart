import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widget/choose_us_container.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void myLaunchURL(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "assets/full_logo.png",
          width: 120,
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Expertise in Digital, Design & Development",
                style: TextStyle(
                  fontFamily: "cgblack",
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '''S1MEDIA is a dynamic media company dedicated to helping businesses in the real estate, restaurant, culinary, old or new car deals and hospitality enhance their online presence. Based on Mahape Road, our team of skilled shooting editors travels to your location to create stunning video content that we share across our YouTube channel and social media platforms.
                ''',
                style: TextStyle(fontSize: 16),
              ),

              const Divider(),

              // Privacy
              ListTile(
                title: const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  myLaunchURL("https://kodeinnovate-workspace.github.io/s1media_policy/privacy_policy.html");
                },
              ),

              //Terms
              ListTile(
                title: const Text(
                  'Terms & Conditions',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  myLaunchURL("https://kodeinnovate-workspace.github.io/s1media_policy/terms.html");
                },
              ),

              const Center(
                child: Text(
                  "S1Media, Kalyan Phata near indian oil petrol pump - 421208",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xffBA1D17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
