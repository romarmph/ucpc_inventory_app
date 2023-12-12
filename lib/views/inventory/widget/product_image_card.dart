import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ucpc_inventory_management_app/exports.dart';

class ProductImageCard extends StatelessWidget {
  const ProductImageCard({
    super.key,
    required this.url,
    required this.onPressed,
    this.isNetworkImage = false,
    this.isReadOnly = false,
  });

  final String url;
  final VoidCallback onPressed;
  final bool isNetworkImage;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                padding: const EdgeInsets.only(
                  top: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Column(
                    children: [
                      Expanded(
                        child: kIsWeb
                            ? Image.network(url)
                            : Image.file(
                                File(url),
                                fit: BoxFit.cover,
                              ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Stack(
        children: [
          Container(
            width: 200,
            height: 200,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.grey[100]!,
              borderRadius: BorderRadius.circular(12),
            ),
            child: isNetworkImage
                ? CachedNetworkImage(
                    imageUrl: url,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  )
                : Image.file(
                    File(url),
                    fit: BoxFit.cover,
                  ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Visibility(
              visible: !isReadOnly,
              child: IconButton(
                onPressed: onPressed,
                icon: CircleAvatar(
                  backgroundColor: Colors.white54,
                  child: Icon(
                    Icons.close,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
