import 'dart:async'; // Import for Timer
import 'package:dating_app/profileUpdates/profile_details.dart';
import 'package:dating_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class Otp extends StatefulWidget {
  const Otp({super.key});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  String otp = '';
  late Timer _timer;
  int _start = 60;

  @override
  void initState() {
    super.initState();
    // Initialize the timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.red),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _start > 0
                  ? "00:${_start < 10 ? '0$_start' : _start}"
                  : "Time's up!",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.black),
            ),
            SizedBox(height: 35),
            Text(
              "Type the verification code \nwe've sent you.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            PinCodeTextField(
              length: 6,
              obscureText: false,
              animationType: AnimationType.fade,
              appContext: context,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(15),
                fieldHeight: 70,
                fieldWidth: 60,
                activeFillColor: Colors.red,
                inactiveFillColor: Colors.white,
                selectedFillColor: Colors.red,
                activeColor: Colors.red,
                inactiveColor: Colors.red,
                selectedColor: Colors.red,
              ),
              cursorColor: Colors.red,
              animationDuration: Duration(milliseconds: 300),
              backgroundColor: Colors.transparent,
              enableActiveFill: true,
              textStyle: TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  otp = value;
                });
              },
              onCompleted: (value) {
                // Navigate to the next screen when OTP is complete
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileDetails()),
                );
              },
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 70),
              child: Buttons(text: "Send again", color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
