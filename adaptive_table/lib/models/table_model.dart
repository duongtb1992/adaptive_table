import 'package:adaptive_table/models/table_column_model.dart';

class TableModel<T> {
  final List<T> items;
  final List<TableColumnBase<T>> columns;
  //
  TableModel({
    required this.items,
    required this.columns,
  });
}