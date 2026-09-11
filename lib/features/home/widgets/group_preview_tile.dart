import 'package:flutter/material.dart';

class GroupPreviewTile extends StatelessWidget {
  final String groupName;
  final List<String> initials;
  final String titleText;   // only names part like: "test, best"
  final String suffixText;  // e.g. "and 1200+ active members"

  const GroupPreviewTile({
    super.key,
    required this.groupName,
    required this.initials,
    required this.titleText,
    required this.suffixText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 Initials Avatars
          SizedBox(
            width: 80,
            child: Stack(
              children: List.generate(
                initials.length > 3 ? 3 : initials.length,
                    (index) => Positioned(
                  left: index * 22,
                      child: CircleAvatar(
                      radius: 15, // outer for border
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 16, // inner actual avatar
                        backgroundColor: _avatarColor(index),
                        child: Text(
                          initials[index],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

              ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          /// 🔹 Text Section
          Expanded(
            child: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
                children: [
                  // 🔹 Names (Bold)
                  TextSpan(
                    text: titleText,
                    style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                  ),

                  // 🔹 Manual suffix (Normal)
                  if (suffixText.isNotEmpty)
                    TextSpan(
                      text: ' $suffixText',
                      style: const TextStyle(fontWeight: FontWeight.normal,  color: Colors.grey,),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 Different colors for avatars
  Color _avatarColor(int index) {
    final colors = [
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
    ];
    return colors[index % colors.length];
  }
}
