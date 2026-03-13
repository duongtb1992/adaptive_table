import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseCubit<T> extends Cubit<T> {
  BaseCubit(super.initialState);

  baseEmit(T value) {
    if (isClosed) return;
    emit(value);
  }
}

abstract class BaseBloc<E, S> extends Bloc<E, S> {
  BaseBloc(super.initialState);

  void baseEmit(Emitter<S> emit, S state) {
    if (isClosed) return;
    emit(state);
  }
}
