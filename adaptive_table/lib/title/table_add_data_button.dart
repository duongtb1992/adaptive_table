import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import '../image/svg_asset_image.dart';

class TableAddDataButton extends StatelessWidget {

  const TableAddDataButton({super.key,
    required this.onAdd,
    required this.color
  });

  final Function() onAdd;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onAdd,
      child: SizedBox(
        width: 28,
        height: 28,
        child: SvgAssetImage('assets/svg/ic_add_data_table.svg',
          fit: BoxFit.contain,
          color: color,
        )
      ),
    );
  }

}