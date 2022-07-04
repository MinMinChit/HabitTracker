import 'package:flutter/material.dart';
import '../constants.dart';

class ButtonContainer extends StatelessWidget {
  const ButtonContainer({
    Key? key,
    required this.onTap,
    required this.buttonString,
    required this.buttonSign,
  }) : super(key: key);

  final Function() onTap;
  final String buttonString;
  final String buttonSign;
  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      stepWidth: double.infinity,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          height: 54,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                buttonString,
                style: kTextButtonStyle,
              ),
              Text(
                buttonSign,
                style: kTextButtonStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
