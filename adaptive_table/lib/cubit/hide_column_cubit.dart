import '../models/table_column_model.dart';
import 'base_cubit.dart';

class HideColumnCubit extends BaseCubit<int> {
  List<String> hiddenColumnKeys = [];
  List<String> pendingHiddenColumnKeys = [];
  List<TableColumnBase> columns;
  //
  HideColumnCubit({required this.columns}) : super(0);
  //
  void hideOrUnhide(TableColumnBase model) {
    if (isPendingHidden(model)) {
      pendingHiddenColumnKeys.remove(model.key);
    }
    else {
      pendingHiddenColumnKeys.add(model.key);
    }
    emit(state + 1);
  }
  //
  void update() {
    hiddenColumnKeys = [...pendingHiddenColumnKeys];
    emit(state + 1);
  }
  //
  void reset() {
    pendingHiddenColumnKeys = [...hiddenColumnKeys];
    emit(state + 1);
  }
  //
  bool isHidden(TableColumnBase model) {
    return hiddenColumnKeys.contains(model.key);
  }

  bool isPendingHidden(TableColumnBase model) {
    return pendingHiddenColumnKeys.contains(model.key);
  }
}