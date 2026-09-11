import 'package:flutter/material.dart';

class GroupPreviewTileNew extends StatelessWidget {
  final List<String> initials;
  final String titleText;
  final String membersOnline;

  const GroupPreviewTileNew({
    super.key,
    required this.initials,
    required this.titleText,
    required this.membersOnline,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 30),

        /// Avatar Stack
        SizedBox(
          width: 72,
          height: 34,
          child: Stack(
            clipBehavior: Clip.none,
            children: [

              for (int i = 0; i < initials.length && i < 3; i++)
                Positioned(
                  left: i * 21,
                  child: _avatar(initials[i]),
                ),

              /// Online dot
              Positioned(
                left: 16 * (initials.length - 1) + 25,
                bottom: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),

        /// Text Section
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "${titleText} ",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 2),

               Text(
                "$membersOnline  currently viewing",
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF9E9E9E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _avatar(String letter) {
    return Container(
      width: 30,
      height: 30,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF22C55E), // outer green ring
      ),
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white, // white gap
        ),
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFEFEFEF), // inner grey
          ),
          alignment: Alignment.center,
          child: Text(
            letter,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
