import 'package:flutter/Material.dart';

class SearchTableTextField extends StatelessWidget {

  const SearchTableTextField({super.key,
    this.onSearchChange,
    this.onSearchSubmit,
    this.hintText = 'Tìm kiếm',
    required this.primaryColor,
    required this.lightPrimaryColor,
  });

  final Function(String)? onSearchChange, onSearchSubmit;
  final String hintText;
  final Color primaryColor, lightPrimaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 258,
      decoration: BoxDecoration(
        color: lightPrimaryColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: primaryColor,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          const Icon(Icons.search, color: Color(0xff6d6d6d), size: 20),
          const SizedBox(width: 8,),
          Expanded(
            child: TextField(
              style: const TextStyle(
                  fontFamily: 'Afacad',
                  color: Color(0xff6d6d6d),
                  fontSize: 16,
                  letterSpacing: 0.3,
                  height: 1.25
              ),
              onChanged: onSearchChange,
              onSubmitted: onSearchSubmit,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                    fontFamily: 'Afacad',
                    color: Color(0xff6d6d6d),
                    fontSize: 16,
                    letterSpacing: 0.3,
                    height: 1.25
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          )
        ],
      ),
    );
  }
}