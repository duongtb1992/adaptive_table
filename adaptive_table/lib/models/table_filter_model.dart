import 'package:flutter/Material.dart';

class TableFilterModel<T, V> {
  final String title;
  final String key;
  final V Function(T item) getter; //valueGetter
  final Widget Function(BuildContext context, V value) builder;

  TableFilterModel({
    required this.title,
    required this.key,
    required this.getter,
    required this.builder,
  });
}