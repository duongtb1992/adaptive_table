import 'package:adaptive_table/image/svg_asset_image.dart';
import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';

class FilterShowButton extends StatelessWidget {

  final Color primaryColor;
  final Function(BuildContext, GlobalKey) onTap;
  final int numShow;

  FilterShowButton({super.key,
    required this.primaryColor,
    required this.onTap,
    this.numShow = 0,
  });

  final GlobalKey buttonKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: buttonKey,
      onTap: () {
        onTap.call(context, buttonKey);
      },
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: primaryColor,
            width: 1,
          )
        ),
        child: Row(
          children: [
            SvgAssetImage('assets/svg/ic_filter.svg', width: 18),
            const SizedBox(width: 7),
            Text('Hiển thị',
              style: const TextStyle(
                fontFamily: 'Afacad',
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Color(0xff6d6d6d),
              )
            ),
            const SizedBox(width: 7),
            Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: Text('$numShow',
                  style: const TextStyle(
                    fontFamily: 'Afacad',
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                    color: Colors.white,
                  )
              ),
            )
          ],
        ),
      ),
    );
  }

}