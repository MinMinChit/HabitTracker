import 'package:flutter/material.dart';

class CategoryIcon extends StatelessWidget {
  const CategoryIcon({
    Key? key,
    required this.onTap,
    required this.categoriesIconName,
    required this.color,
  }) : super(key: key);

  final Function() onTap;
  final String categoriesIconName;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 3,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: 2.0,
            ),
          ),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/$categoriesIconName'),
          ),
        ),
      ),
    );
  }
}
