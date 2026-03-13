import 'base_cubit.dart';

class TablePagingCubit extends BaseCubit<int> {
  int count;
  Function(int) onClickPagingIndex;
  //
  TablePagingCubit({required this.count, required this.onClickPagingIndex}) : super(0);

  bool get max => state + 1 == count;

  bool get min => state == 0;

  void next() {
    if (!max) {
      onClickPagingIndex.call(state + 1);
      emit(state + 1);
    }
  }

  void prev() {
    if (!min) {
      onClickPagingIndex.call(state - 1);
      emit(state - 1);
    }
  }

  void goto(int index) {
    if (index >= 0 && index < count && index != state) {
      onClickPagingIndex.call(index);
      emit(index);
    }
  }

  List<int> getSmallIndexes() {
    if (count <= 5) return List.generate(count, (i) => i);
    if (state == 0) return List.generate(3, (i) => i);
    if (state >= count - 3) return List.generate(3, (i) => count - 5 + i);
    return [state - 1, state, state + 1];
  }

  List<int> getBigIndexes() {
    if (count <= 5) return [];
    return [count - 2, count - 1];
  }

  bool get hasHeadElipsis {
    return count > 5 && state >= 2;
  }

  bool get hasMiddleElipsis {
    return count > 5 && state < count - 4;
  }
}