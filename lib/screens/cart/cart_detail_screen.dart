import 'package:flutter/material.dart';
import 'cart_screen.dart';
import 'package:app_flutter/services/cart_services.dart';
import 'package:app_flutter/services/order_services.dart';
import 'package:app_flutter/core/widgets/app_bar.dart';

class CartDetailScreen extends StatefulWidget {
  final Map<String, dynamic> item;
  final String userId;
  CartDetailScreen({super.key, required this.item, required this.userId});

  @override
  State<CartDetailScreen> createState() => _CartDetailScreenState();
}

class _CartDetailScreenState extends State<CartDetailScreen> {
  final cartServices = CartServices();
  final orderServices = OrderServices();
  late int quantity;
  late double total;

  @override
  void initState() {
    super.initState();
    quantity = widget.item['quantity'];
    _updatedTotal();
  }

  void _updatedTotal() {
    setState(() {
      total = widget.item['price'] * quantity;
    });
  }

  void _updatedQuantity(int newQuantity) async {
    if (newQuantity <= 0) {
      await cartServices.deleteFormCart(widget.userId, widget.item['id']);
      Navigator.pop(context);
    } else {
      await cartServices.updatedQuantityProduct(
        widget.item['id'],
        widget.userId,
        newQuantity,
      );
      setState(() {
        quantity = newQuantity;
      });
    }
  }

  void _payMent() async {
    try {
      final orderItem = {
        'id': widget.item['id'],
        'name': widget.item['name'],
        'imageUrl': widget.item['imageUrl'],
        'price': widget.item['price'],
        'quantity': widget.item['quantity'],
      };

      await orderServices.createOrder(widget.userId, [orderItem], total);
      await cartServices.deleteFormCart(widget.userId, widget.item['id']);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: const Text('Thanh toán thành công!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi thanh toán $e '),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Chi tiết sản phẩm',
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
