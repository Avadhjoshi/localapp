import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool hideAppbar;
  final String categoryName;
  final VoidCallback onFilterTap;

  const HomeAppBar({
    required this.hideAppbar,
    required this.categoryName,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: hideAppbar
          ? GestureDetector(
        onTap: onFilterTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: const [
              Text('Filter', style: TextStyle(color: Colors.black)),
              Spacer(),
              Icon(Icons.arrow_drop_down, color: Colors.black),
            ],
          ),
        ),
      )
          : Text(
        categoryName,
        style: const TextStyle(color: Colors.black),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.black),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
