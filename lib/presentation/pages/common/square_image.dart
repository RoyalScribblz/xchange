import "package:flutter/material.dart";

class SquareImage extends StatelessWidget {
  const SquareImage({
    super.key,
    required this.assetPath,
    required this.size,
  });

  final String assetPath;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 3,
          offset: Offset(1, 2),
        ),
      ]),
      child: Image.asset(
        assetPath,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
