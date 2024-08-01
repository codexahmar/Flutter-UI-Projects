import 'package:dating_app/authenticationScreens/otp.dart';
import 'package:dating_app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';

class Verification extends StatefulWidget {
  const Verification({super.key});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final TextEditingController _phoneController = TextEditingController();
  String _countryCode = '+92';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 170), // Adds space from the top
            const Text(
              "My Mobile",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            const Text(
              'Please enter your valid phone number. We will send you a 6-digit code to verify your account.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 100),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border:
                          Border.all(color: Colors.grey.shade400, width: 1.2),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: CountryCodePicker(
                                  onChanged: (country) {
                                    setState(() {
                                      _countryCode = country.dialCode!;
                                    });
                                  },
                                  initialSelection: 'PK',
                                  favorite: ['PK'],
                                  showCountryOnly: false,
                                  showOnlyCountryWhenClosed: false,
                                  alignLeft: true,
                                  showFlag: true,
                                  showFlagMain: true,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  searchDecoration: InputDecoration(
                                    hintText: 'Search for a country',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  searchStyle:
                                      const TextStyle(color: Colors.black),
                                ),
                              ),
                              const Positioned(
                                right: 0,
                                top: 0,
                                bottom: 0,
                                child: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        VerticalDivider(
                          color: Colors.grey.shade400,
                          thickness: 1.2,
                          width: 1.2,
                          indent: 5,
                          endIndent: 5,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '331 623 8141',
                              prefixText: '$_countryCode ',
                              prefixStyle: const TextStyle(
                                  fontSize: 16, color: Colors.black54),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Buttons(
                    text: "Continue",
                    color: Color(0xFFE94057),
                    destination: Otp(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
