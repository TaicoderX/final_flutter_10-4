import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconSurf extends StatelessWidget {
  final String svg;

  const IconSurf({Key? key, required this.svg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SvgPicture.asset(
        svg,
        height: 16,
        width: 16,
      ),
    );
  }
}

