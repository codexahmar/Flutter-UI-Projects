import 'package:flutter/material.dart';

class Buttons extends StatefulWidget {
  final String text;
  final Color color;
  final TextStyle textStyle;
  final double elevation;
  final Widget? destination;

  const Buttons({
    super.key,
    required this.text,
    required this.color,
    this.textStyle =
        const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
    this.elevation = 0,
    this.destination,
  });

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to the destination screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget.destination!),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.color,
        minimumSize: Size(295, 56),
        elevation: widget.elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        widget.text,
        style: widget.textStyle,
      ),
    );
  }
}
