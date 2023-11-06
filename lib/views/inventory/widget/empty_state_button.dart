import 'package:flutter/material.dart';
import 'package:ucpc_inventory_management_app/exports.dart';

class ImagesEmptyStateAddButton extends ConsumerWidget {
  const ImagesEmptyStateAddButton({
    super.key,
    required this.constraints,
    required this.onTap,
  });

  final BoxConstraints constraints;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: constraints.maxWidth,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.indigo[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.indigo[200]!,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              color: Colors.indigo[400],
            ),
            Text(
              'Add Image',
              style: TextStyle(
                color: Colors.indigo[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
