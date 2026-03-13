import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';

class HideColumnButton extends StatelessWidget {

  HideColumnButton({super.key, required this.onTap, required this.color});

  final Function(BuildContext, GlobalKey) onTap;
  final Color color;

  final GlobalKey buttonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: buttonKey,
      onTap: () {
        onTap.call(context, buttonKey);
      },
      child: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Icon(Icons.visibility_off, color: Colors.white, size: 16),
      ),
    );
  }


}