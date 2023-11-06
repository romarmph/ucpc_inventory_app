import 'package:flutter/material.dart';
import 'package:ucpc_inventory_management_app/exports.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.isSelected,
    required this.isSelectMode,
  });

  final Product product;
  final bool isSelected;
  final bool isSelectMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        shadowColor: Colors.grey[300],
        elevation: 1,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _renderThumbnail(product.imageUrls, constraints),
                      Container(
                        height: constraints.maxHeight * 0.5 - 4,
                        padding: const EdgeInsets.all(8),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Spacer(),
                            Text(
                              '₱${product.price}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${product.quantity} in stock',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(
                        product.isPopular
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        size: 36,
                        color: product.isPopular
                            ? Colors.yellow[700]
                            : Colors.grey,
                      ),
                      onPressed: _markAsPopular,
                    ),
                  ),
                  isSelectMode
                      ? Positioned(
                          top: 0,
                          left: 0,
                          child: Checkbox(
                            value: isSelected,
                            onChanged: (value) {},
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _markAsPopular() async {
    final productDatabase = ProductDatabase.instance;

    try {
      await productDatabase.updateProduct(
        product.copyWith(isPopular: !product.isPopular),
      );
    } catch (e) {
      _showUnkownErrorDialog();
    }
  }

  void _showUnkownErrorDialog() {
    QuickAlert.show(
      context: navigatorKey.currentContext!,
      type: QuickAlertType.error,
      title: 'Unknown Error',
      text: 'An unknown error has occured. Please try again later.',
    );
  }

  Widget _renderThumbnail(List imageUrls, BoxConstraints constraints) {
    if (imageUrls.isEmpty) {
      return Container(
        height: constraints.maxHeight * 0.5 - 4,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image,
              size: 48,
              color: Colors.white,
            ),
            SizedBox(height: 8),
            Text(
              'No Image',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: product.imageUrls.first,
      fit: BoxFit.cover,
      height: constraints.maxHeight * 0.5,
      width: double.infinity,
      errorWidget: (context, url, error) {
        return const Icon(Icons.error);
      },
      placeholder: (context, url) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
