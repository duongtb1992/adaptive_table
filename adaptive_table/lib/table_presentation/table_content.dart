import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/hide_column_cubit.dart';
import '../models/table_model.dart';

class TableContent<T> extends StatelessWidget {

  const TableContent({super.key,
    required this.table,
    this.itemColors = const [
      Color(0xfffff8fa),
      Color(0xfff8f8f8),
    ],
  });

  final TableModel<T> table;
  final List<Color> itemColors;

  @override
  Widget build(BuildContext context) {
    final hiddenColumnCubit = context.read<HideColumnCubit>();
    return SingleChildScrollView(
      child: Column(
        children: [
          for (final item in table.items)
            Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: itemColors[table.items.indexOf(item) % itemColors.length],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  child: Row(
                    children: table.columns.map((col) {
                      //
                      if (hiddenColumnCubit.isHidden(col)) {
                        return Container();
                      }
                      //
                      if (col.flex != null) {
                        return Expanded(
                          flex: col.flex!,
                          child: Row(
                            mainAxisAlignment: col.alignment ?? MainAxisAlignment.center,
                            children: [
                              col.buildCell(context, item),
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
                                  col.buildCell(context, item),
                                ]
                            )
                        );
                      }
                      return Container();
                    }).toList(),
                  ),
                ),
            )
        ],
      ),
    );
  }
}