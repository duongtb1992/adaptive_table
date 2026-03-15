import 'package:adaptive_table/models/table_column_model.dart';

import 'hide_column_cubit.dart';

class ShowFilterCubit extends HideColumnCubit{
  ShowFilterCubit({required super.columns});

  List<TableColumnBase> get availableFilters {
    return columns.where((e) => e.hasFilter).toList();
  }

  List<TableColumnBase> get shownFilters {
    return availableFilters.where((e) => !hiddenColumnKeys.contains(e.key)).toList();
  }
}