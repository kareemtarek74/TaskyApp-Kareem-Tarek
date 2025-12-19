import 'package:flutter/material.dart';
import 'package:kareem_tarek/core/utils/text_styles.dart';

class ActiveFilterChip extends StatelessWidget {
  final String label;
  final VoidCallback onDeleted;

  const ActiveFilterChip({
    super.key,
    required this.label,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: Styles.styleMedium14(context).copyWith(color: Colors.white),
      ),
      backgroundColor: Colors.black,
      deleteIcon: const Icon(Icons.close, size: 14, color: Colors.white),
      onDeleted: onDeleted,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide.none,
    );
  }
}
