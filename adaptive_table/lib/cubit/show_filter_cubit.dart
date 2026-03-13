import 'hide_column_cubit.dart';

class ShowFilterCubit extends HideColumnCubit{
  ShowFilterCubit({required super.columns});

  List<String> get availableFilters {
    return columns.where((e) => e.hasFilter).map((e) => e.key).toList();
  }
}