import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final TextStyle? titleTextStyle;
  final Widget? leading;

  CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    required this.titleTextStyle,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: titleTextStyle),
      actions: actions,
      backgroundColor: const Color.fromARGB(255, 1, 20, 49),
      foregroundColor: Colors.white,
      leading: leading,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(kToolbarHeight);
  }
}
