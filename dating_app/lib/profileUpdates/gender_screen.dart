import 'package:dating_app/profileUpdates/passions_screen.dart';
import 'package:dating_app/widgets/buttons.dart';
import 'package:flutter/material.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({super.key});

  @override
  State<GenderScreen> createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  String _selectedGender = "";
  bool _isCustomGenderSelected = false;
  bool _showDropdown = false;
  final List<String> _otherGenders = ["Transgender", "Bigender", "Other"];

  void _selectGender(String gender) {
    setState(() {
      _selectedGender = gender;
      _isCustomGenderSelected = false;
      _showDropdown = false;
    });
  }

  void _toggleDropdown() {
    setState(() {
      _isCustomGenderSelected = !_isCustomGenderSelected;
      _selectedGender = _isCustomGenderSelected ? "Choose Another" : "";
      _showDropdown = _isCustomGenderSelected;
    });
  }

  void _selectCustomGender(String gender) {
    setState(() {
      _selectedGender = gender;
      _isCustomGenderSelected = true;
      _showDropdown = false;
    });
  }

  Widget _buildGenderOption(String gender) {
    bool isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: gender == "Choose Another"
          ? _toggleDropdown
          : () => _selectGender(gender),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFE94057) : Colors.grey,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              gender,
              style: TextStyle(
                color: isSelected ? const Color(0xFFE94057) : Colors.black,
                fontSize: 18,
              ),
            ),
            Row(
              children: [
                if (isSelected)
                  const Icon(
                    Icons.check,
                    color: Color(0xFFE94057),
                    size: 24,
                  ),
                if (gender == "Choose Another")
                  const Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black54,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Color(0xFFE94057),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            const Text(
              "I am a",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 130),
            Column(
              children: [
                _buildGenderOption("Man"),
                _buildGenderOption("Woman"),
                _buildGenderOption("Choose Another"),
                if (_showDropdown)
                  Column(
                    children: _otherGenders.map((gender) {
                      return GestureDetector(
                        onTap: () => _selectCustomGender(gender),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                gender,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Buttons(
                text: "Continue",
                color: Color(0xFFE94057),
                destination: PassionsScreen(),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
