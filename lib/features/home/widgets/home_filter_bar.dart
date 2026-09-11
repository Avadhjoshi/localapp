import 'package:flutter/material.dart';

import '../../../models/SubCategory.dart';

class HomeFilterBar extends StatelessWidget {
  final List<SubCategory_list> subCategories;
  final Function(int) onSelected;

  const HomeFilterBar({
    required this.subCategories,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: subCategories.length,
      itemBuilder: (context, index) {
        final item = subCategories[index];
        return ListTile(
          title: Text(item.SubCategoryName),
          onTap: () {
            Navigator.pop(context);
            onSelected(int.parse(item.SubCategoryId));
          },
        );
      },
    );
  }
}
