import 'package:flutter/material.dart';

class SelectedProductCounter extends StatelessWidget {
  const SelectedProductCounter({
    super.key,
    required this.selectedCount,
    required this.onPressed,
  });

  final int selectedCount;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Selected: $selectedCount',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            Icons.close_rounded,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
