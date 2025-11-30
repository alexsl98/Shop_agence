import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onLogout;
  final Widget? title;

  const CustomAppBar({super.key, required this.onLogout, this.title});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(46)),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          title: const CircleAvatar(),
          actions: [
            IconButton(icon: const Icon(Icons.logout), onPressed: onLogout),
          ],
        ),
      ),
    );
  }
}
