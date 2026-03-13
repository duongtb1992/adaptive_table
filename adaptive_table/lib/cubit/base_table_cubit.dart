

import '../models/table_column_model.dart';
import 'base_cubit.dart';
import 'common_table_state.dart';

class BaseTableCubit<T> extends BaseCubit<CommonTableState<T>> {

  final List<TableColumnModel<T, dynamic>> columns;

  BaseTableCubit({
    required this.columns,
  }) : super(
    CommonTableState(
        items: [],
        hiddenColumns: [],
    )
  );

  init() async {
    //call initial (GET)
    List<T> items = [];
    emit(state.copyWith(items: items));
  }
}