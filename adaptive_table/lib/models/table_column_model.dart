import 'package:flutter/Material.dart';

abstract class TableColumnBase<T> {
  String get title;
  String get key;

  Widget buildCell(BuildContext context, T item);

  Widget buildFilter(BuildContext context);

  int? get flex;
  double? get width;
  MainAxisAlignment? alignment;
  bool get hasFilter;

  /// If true, column is pinned (does not scroll horizontally).
  /// Defaults to true for backward compatibility.
  bool get isFixed;
}


//T là class của hàng
//V là class của thuộc tính của T (V là class của cột)
class TableColumnModel<T, V> extends TableColumnBase<T> {
  @override
  final String title;

  @override
  final String key;

  final V Function(T item) getter;

  final Widget Function(BuildContext context, V value) builder;

  final Widget Function(BuildContext context)? filterBuilder;

  @override
  final int? flex;

  @override
  final double? width;

  @override
  final MainAxisAlignment? alignment;

  @override
  final bool isFixed;

  TableColumnModel({
    required this.title,
    required this.key,
    required this.getter,
    required this.builder,
    this.width,
    this.flex,
    this.alignment = MainAxisAlignment.center,
    this.filterBuilder,
    this.isFixed = true,
  }) : assert(
          isFixed || width != null,
          'Column "$key" has isFixed=false but no width is set. '
          'Scrollable columns must have an explicit width.',
        );

  @override
  Widget buildCell(BuildContext context, T item) {
    final value = getter(item);
    return builder(context, value);
  }

  @override
  Widget buildFilter(BuildContext context) {
    return filterBuilder?.call(context) ?? Container();
  }

  @override
  bool get hasFilter => filterBuilder != null;
}