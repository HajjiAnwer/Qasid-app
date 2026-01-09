import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;
  final Color backgroundColor;
  final bool centerTitle;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.leading,
    this.actions,
    this.backgroundColor = Colors.blue,
    this.centerTitle = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // RTL support: AppBar automatically handles leading/actions order
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: centerTitle,
      leading: leading,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          fontFamily: 'DINNextLTArabic', // make sure font is loaded
        ),
      ),
      actions: actions,
      automaticallyImplyLeading: false, // we control leading manually
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
