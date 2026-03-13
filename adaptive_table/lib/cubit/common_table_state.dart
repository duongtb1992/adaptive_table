import 'package:equatable/equatable.dart';

class CommonTableState<T> extends Equatable {

  final List<T> items;
  final List<String> hiddenColumns;

  const CommonTableState({
    required this.items,
    required this.hiddenColumns
  });

  CommonTableState<T> copyWith({
    List<T>? items,
    List<String>? hiddenColumns,
  }) {
    return CommonTableState<T>(
        items: items ?? this.items,
        hiddenColumns: hiddenColumns ?? this.hiddenColumns
    );
  }

  @override
  List<Object?> get props => [items];
}