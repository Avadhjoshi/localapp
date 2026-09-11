import 'package:flutter/material.dart';
import 'package:localapp/BlogListWidget.dart';

import '../../../models/BlogList.dart';

class HomeBlogList extends StatelessWidget {
  final List<Blog_list> blogs;
  final bool isLoadingMore;
  final String categoryId;
  final String privacyType;
  final String? privacyImage;
  final String? whatsAppText;
  final String? whatsAppNumber;

  const HomeBlogList({
    required this.blogs,
    required this.isLoadingMore,
    required this.categoryId,
    required this.privacyType,
    this.privacyImage,
    this.whatsAppText,
    this.whatsAppNumber,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: blogs.length + 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        if (index == blogs.length) {
          return isLoadingMore
              ? const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          )
              : const SizedBox();
        }

        return BlogListWidget(
          blogs[index],
          categoryId,
          categoryId,
          privecyType: privacyType,
          privacyImage: privacyImage,
          whatsAppNumber: whatsAppNumber,
          whatsAppText: whatsAppText,
        );
      },
    );
  }
}
