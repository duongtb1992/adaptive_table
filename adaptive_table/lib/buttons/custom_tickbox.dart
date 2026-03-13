import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';

class CustomTickBox extends StatelessWidget {

  const CustomTickBox({super.key,
    required this.text,
    required this.isTick,
    required this.isLastIndex,
    required this.onTap,
    required this.primaryColor,
  });

  final String text;
  final bool isTick;
  final bool isLastIndex;
  final Function() onTap;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14.5),
          child: Row(
            children: [
              GestureDetector(
                onTap: onTap,
                child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: isTick ? primaryColor : const Color(0xffdedede),
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      boxShadow: isTick ? [
                        BoxShadow(
                          color: Colors.black.withAlpha(38),
                          blurRadius: 6,
                        )
                      ] : null
                    ),
                    child: isTick
                        ? const Icon(Icons.check_rounded, size: 12, color: Colors.white)
                        : null,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                text,
                style: const TextStyle(
                  color: Color(0xff6d6d6d),
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  height: 1.25,
                  fontFamily: 'Afacad',
                )
              ),
            ],
          ),
        ),
        if (!isLastIndex)
          Container(
              width: double.infinity,
              height: 1,
              color: const Color(0xffeeeeee)
          )
      ]
    );
  }

}