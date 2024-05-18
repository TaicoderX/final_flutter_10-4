import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HandleError extends StatelessWidget {
  final List<String?> errors;

  const HandleError({Key? key, required this.errors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: errors.map((error) => _buildErrorRow(error!)).toList(),
    );
  }

  Widget _buildErrorRow(String error) {
    return Row(
      children: [
        SvgPicture.asset(
          "assets/icons/Error.svg",
          height: 16,
          width: 16,
        ),
        const SizedBox(width: 10),
        Text(error),
      ],
    );
  }
}