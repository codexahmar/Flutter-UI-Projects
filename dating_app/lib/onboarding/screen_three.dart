import 'package:flutter/material.dart';

class ScreenThree extends StatelessWidget {
  const ScreenThree({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 90,
        ),
        // ignore: sized_box_for_whitespace
        Container(
          height: 500,
          child: Image.asset(
            "assets/images/girl3.png",
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        const Text(
          "Premium",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFFE94057)),
        ),
        const SizedBox(
          height: 15,
        ),
        const Text(
          "Sign up today and enjoy the first month \n of premium benefits on us.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
