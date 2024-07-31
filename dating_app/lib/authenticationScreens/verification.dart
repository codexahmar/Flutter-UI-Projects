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
  String _countryCode = '+92'; // Default country code for Pakistan
  String _countryName = 'PK'; // Default country code for Pakistan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "My Mobile",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 10),
            Text(
              'Please enter your valid phone number. We will send you a 6-digit code to verify your account.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            Container(
              height: 65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.grey.shade400, width: 1.2),
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
                                _countryName = country.code!;
                              });
                            },
                            initialSelection: 'PK',
                            favorite: ['PK'],
                            showCountryOnly: false,
                            showOnlyCountryWhenClosed: false,
                            alignLeft: true,
                            showFlag: true, // Show flag
                            showFlagMain: true,
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            searchDecoration: InputDecoration(
                              hintText: 'Search for a country',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            searchStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                        Positioned(
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
                  SizedBox(
                    width: 20,
                  ),
                  VerticalDivider(
                    color: Colors.grey.shade400,
                    thickness: 1.2,
                    width: 1.2,
                    indent: 5,
                    endIndent: 5,
                  ),
                  // Add here the vertical divider
                  SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '331 623 8141',
                        prefixText: '$_countryCode ',
                        prefixStyle:
                            TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Buttons(
              text: "Continue",
              color: Colors.red,
              destination: Otp(),
            ),
          ],
        ),
      ),
    );
  }
}
