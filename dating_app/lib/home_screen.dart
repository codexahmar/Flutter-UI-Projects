import 'package:dating_app/authenticationScreens/signup.dart';
import 'package:dating_app/onboarding/screen_one.dart';
import 'package:dating_app/onboarding/screen_three.dart';
import 'package:dating_app/onboarding/screen_two.dart';
import 'package:dating_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: controller,
            children: [
              const ScreenOne(),
              const ScreenTwo(),
              const ScreenThree(),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SmoothPageIndicator(
                    controller: controller,
                    count: 3,
                    effect: const ScrollingDotsEffect(
                      activeDotColor: Colors.red,
                      dotColor: Colors.grey, // Inactive dot color
                      dotHeight: 8.0,
                      dotWidth: 8.0,
                      spacing: 8.0,
                    ),
                  ),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    child: const Buttons(
                      text: "Create an account",
                      color: Color(0xFFE94057),
                      destination: SignUp(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {},
                    child: RichText(
                      text: const TextSpan(
                        text: "Already have an account? ",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Signup',
                            style: TextStyle(
                              color: Color(0xFFE94057),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
