import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = selected ? Colors.blue.shade100 : Colors.grey.shade100;
    final border = selected ? Colors.blue : Colors.grey.shade300;
    final textColor = selected ? Colors.blue.shade800 : Colors.black87;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: border),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
