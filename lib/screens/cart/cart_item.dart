import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:app_flutter/services/cart_services.dart';
import 'cart_detail_screen.dart';

class CartItem extends StatefulWidget {
  final Map<String, dynamic> item;
  final String userId;
  final CartServices cartServices;
  final bool isSelected;
  final Function(bool?) onChanged;
  CartItem({
    super.key,
    required this.item,
    required this.userId,
    required this.cartServices,
    required this.isSelected,
    required this.onChanged,
  });

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.item['quantity'];
  }

  void _updatedQuantity(int newQuantity) async {
    if (newQuantity <= 0) {
      await widget.cartServices.deleteFormCart(
        widget.userId,
        widget.item['id'],
      );
    } else {
      await widget.cartServices.updatedQuantityProduct(
        widget.item['id'],
        widget.userId,
        newQuantity,
      );
      setState(() {
        quantity = newQuantity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(value: widget.isSelected, onChanged: widget.onChanged),
            widget.item['imageUrl'] != null &&
                    widget.item['imageUrl'].isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: widget.item['imageUrl'],
                    width: 50,
                    fit: BoxFit.cover,
                  )
                : Icon(Icons.shopping_cart),
          ],
        ),
        title: Text(widget.item['name']),
        subtitle: Text('${widget.item['price']} VNĐ'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                _updatedQuantity(quantity - 1);
              },
              icon: const Icon(Icons.remove_circle, color: Colors.red),
            ),
            Text(
              '$quantity',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () {
                _updatedQuantity(quantity + 1);
              },
              icon: const Icon(Icons.add_circle, color: Colors.green),
            ),
            IconButton(
              onPressed: () {
                widget.cartServices.deleteFormCart(
                  widget.userId,
                  widget.item['id'],
                );
              },
              icon: const Icon(Icons.delete),
              color: Colors.grey,
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return CartDetailScreen(
                  item: widget.item,
                  userId: widget.userId,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
