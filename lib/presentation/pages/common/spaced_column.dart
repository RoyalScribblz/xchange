import "package:flutter/material.dart";

class SpacedColumn extends StatelessWidget {
  const SpacedColumn({
    super.key,
    required this.spaceHeight,
    required this.children,
  });

  final double spaceHeight;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < children.length; i++) ...[
          children[i],
          if (i != children.length - 1) SizedBox(height: spaceHeight),
        ]
      ],
    );
  }
}
