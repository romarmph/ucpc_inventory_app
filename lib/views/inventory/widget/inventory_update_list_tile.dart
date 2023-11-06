import 'package:flutter/material.dart';
import 'package:ucpc_inventory_management_app/exports.dart';

class InventoryUpdateListTile extends ConsumerStatefulWidget {
  const InventoryUpdateListTile({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _InventoryUpdateListTileState();
}

class _InventoryUpdateListTileState
    extends ConsumerState<InventoryUpdateListTile> {
  final quantityController = TextEditingController();
  String newQuantity = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      height: 160,
      child: LayoutBuilder(builder: (context, constraints) {
        return Card(
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: _renderThumbnail(widget.product.imageUrls, constraints),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Text('Current Quantity: ${widget.product.quantity}'),
                          const Spacer(),
                          IconButton(
                            onPressed: () => _showUpdateDialog(ref),
                            icon: const Icon(Icons.edit_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text('New Quantity: ${quantityController.text}'),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  void _showUpdateDialog(WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.product.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        final quantity = int.tryParse(quantityController.text);
                        ref.read(updatedProductsProvider.notifier).update(
                              (state) => [
                                ...state,
                                widget.product.copyWith(quantity: quantity)
                              ],
                            );
                        setState(() {
                          newQuantity = quantityController.text;
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text('Update'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _renderThumbnail(List urls, BoxConstraints constraints) {
    if (urls.isEmpty) {
      return Container(
        color: Colors.grey,
        height: constraints.maxHeight,
        width: constraints.maxWidth,
        child: const Center(child: Icon(Icons.image_not_supported_rounded)),
      );
    }

    return SizedBox(
      height: constraints.maxHeight,
      width: constraints.maxWidth,
      child: CachedNetworkImage(
        imageUrl: widget.product.imageUrls.first,
        fit: BoxFit.cover,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
