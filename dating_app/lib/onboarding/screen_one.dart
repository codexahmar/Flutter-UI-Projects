import 'package:flutter/material.dart';

class ScreenOne extends StatelessWidget {
  const ScreenOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 90,
        ),
        Container(
          height: 500,
          child: Image.asset("assets/images/girl1.png"),
        ),
        const SizedBox(
          height: 30,
        ),
        const Text(
          "Algorithm",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFFE94057)),
        ),
        const SizedBox(
          height: 15,
        ),
        const Text(
          "Users going through a vetting process \n to ensure you never match with bots.",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}
