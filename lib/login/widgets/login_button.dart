import 'package:flutter/material.dart';

class LoginButton extends StatefulWidget {
  final Function onPressed;
  final String label;
  final bool isDisabled = false;
  final Color color = Colors.teal;

  const LoginButton({
    super.key,
    required this.onPressed,
    required this.label,
    isDisabled = false,
    color = Colors.teal,
  });

  @override
  State<LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40.0,
      child: ElevatedButton(
        onPressed: () => widget.isDisabled ? null : widget.onPressed(),
        style: ElevatedButton.styleFrom(backgroundColor: widget.isDisabled ? Colors.grey : Colors.teal),
        child: Text(widget.label.toUpperCase()),
      ),
    );
  }
}
