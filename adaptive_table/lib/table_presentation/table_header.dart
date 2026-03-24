import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/hide_column_cubit.dart';
import '../models/table_model.dart';
import 'hide_column_button.dart';
import 'hide_column_dropdown.dart';

class TableHeader<T> extends StatelessWidget {

  const TableHeader({super.key,
    required this.table,
    required this.enableHideColumn,
    required this.color,
    required this.lightColor,
  });

  final TableModel<T> table;
  final bool enableHideColumn;
  final Color color, lightColor;

  @override
  Widget build(BuildContext context) {
    final hideColumnCubit = context.read<HideColumnCubit>();
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 28
          ),
          child: Row(
            children: table.columns.map((col) {
              if (hideColumnCubit.isHidden(col)) {
                return Container();
              }
              if (col.flex != null) {
                return Expanded(
                    flex: col.flex!,
                    child: Row(
                        mainAxisAlignment: col.alignment ?? MainAxisAlignment.center,
                        children: [
                          Text(
                            col.title,
                            style: TextStyle(
                              color: color,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Afacad',
                            ),
                          ),
                        ]
                    )
                );
              }
              if (col.width != null) {
                return SizedBox(
                    width: col.width!,
                    child: Row(
                        mainAxisAlignment: col.alignment ?? MainAxisAlignment.center,
                        children: [
                          Text(
                            col.title,
                            style: TextStyle(
                              color: color,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Afacad',
                            ),
                          ),
                        ]
                    )
                );
              }
              return Container();
            }).toList(),
          ),
        ),
        //hide column
        if (enableHideColumn)
          Positioned(
              right: 0,
              child: HideColumnButton(
                  onTap: (buttonContext, buttonKey) {
                    hideColumnCubit.reset();
                    //
                    HideColumnDropdownOverlay.show(buttonContext,
                        buttonKey,
                        hideColumnCubit,
                        table.columns,
                        color,
                        lightColor
                    );
                  },
                color: color,
              )
          )
      ],
    );
  }
}