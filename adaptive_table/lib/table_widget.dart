import 'package:adaptive_table/filter/filter_and_search_view.dart';
import 'package:adaptive_table/paging/paging_buttons.dart';
import 'package:adaptive_table/table_presentation/table_content.dart';
import 'package:adaptive_table/table_presentation/table_header.dart';
import 'package:adaptive_table/title/table_add_data_button.dart';
import 'package:adaptive_table/title/table_title.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/hide_column_cubit.dart';
import 'models/table_column_model.dart';
import 'models/table_model.dart';

class TableWidget<T> extends StatelessWidget {
  final String tableTitle;

  //
  final List<T> items;
  final List<TableColumnModel<T, dynamic>> columns;

  //
  final Function() onAdd;

  //
  final Function(String)? onSearchChange, onSearchSubmit;
  final String? searchHintText;

  //
  final bool isLoading;
  final Widget? loadingWidget;
  final bool isError;
  final Widget? errorWidget;
  final Widget? emptyWidget;
  final String? errorString;

  //
  final bool enableHideColumn;

  //
  final bool enableFilter;
  final Widget? cardsWidget;

  //
  final int pagingCount;
  final Function(int) onClickPagingIndex;

  //
  final Color primaryColor;
  final Color lightPrimaryColor;
  final List<Color> itemColors;

  //
  final Function(T)? onTapItem;
  final bool hideAddButton;

  final bool showDeleteButton;

  final Function(T)? onDeleteItem;

  final Widget Function(T item)? expandedRowBuilder;
  final bool Function(T)? canDelete;

  final List<String> initialHiddenKeys;
  final Function(List<String>)? onHiddenKeysChanged;
  final double? headerFontSize;
  final double? fontSizeTitle;
  final double firstItemTopMargin;

  const TableWidget({
    super.key,
    required this.items,
    required this.columns,
    required this.tableTitle,
    required this.onAdd,
    this.enableHideColumn = false,
    this.enableFilter = true,
    this.cardsWidget,
    this.pagingCount = 1,
    required this.onClickPagingIndex,
    this.isLoading = false,
    this.isError = false,
    this.errorString,
    this.primaryColor = const Color(0xffe33f64),
    this.lightPrimaryColor = const Color(0xfffff8fa),
    this.itemColors = const [Color(0xfffff8fa), Color(0xfff8f8f8)],
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.onSearchChange,
    this.onSearchSubmit,
    this.searchHintText,
    this.onTapItem,
    this.hideAddButton = false,
    this.showDeleteButton = false,
    this.onDeleteItem,
    this.expandedRowBuilder,
    this.canDelete,
    this.initialHiddenKeys = const [],
    this.onHiddenKeysChanged,
    this.headerFontSize,
    this.fontSizeTitle,
    this.firstItemTopMargin = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    final table = TableModel(items: items, columns: columns);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HideColumnCubit(
            columns: columns,
            onChanged: onHiddenKeysChanged,
            initialHiddenKeys: initialHiddenKeys,
          ),
        ),
      ],
      child: SyncScrollProvider(
        builder: (context, syncController) {
          return BlocBuilder<HideColumnCubit, int>(
            builder: (context, state) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TableTitle(
                              text: tableTitle,
                              fontSize: fontSizeTitle,
                            ),
                            const SizedBox(width: 4),
                            if (!hideAddButton)
                              TableAddDataButton(
                                onAdd: onAdd,
                                color: primaryColor,
                              ),
                          ],
                        ),
                        const SizedBox(width: 6),

                        Expanded(
                          child: FilterAndSearchView(
                            primaryColor: primaryColor,
                            lightPrimary: lightPrimaryColor,
                            columns: columns,
                            onSearchChange: onSearchChange,
                            onSearchSubmit: onSearchSubmit,
                            hintText: searchHintText ?? '',
                            enableFilter: enableFilter,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ?cardsWidget,
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TableHeader(
                      table: table,
                      fontSize: headerFontSize,
                      enableHideColumn: enableHideColumn,
                      color: primaryColor,
                      lightColor: lightPrimaryColor,
                      syncController: syncController,
                    ),
                  ),
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        if (isLoading) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              loadingWidget ??
                                  CircularProgressIndicator(
                                    color: primaryColor,
                                  ),
                            ],
                          );
                        }
                        if (isError) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              errorWidget ??
                                  Text(
                                    errorString ?? 'No Data',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontFamily: 'Afacad',
                                    ),
                                  ),
                            ],
                          );
                        }
                        if (items.isEmpty) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              emptyWidget ??
                                  Text(
                                    errorString ?? 'No Data',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontFamily: 'Afacad',
                                    ),
                                  ),
                            ],
                          );
                        }
                        return TableContent(
                          table: table,
                          itemColors: itemColors,
                          onTapItem: onTapItem,
                          showDeleteButton: showDeleteButton,
                          onDeleteItem: onDeleteItem,
                          expandedRowBuilder: expandedRowBuilder,
                          canDelete: canDelete,
                          syncController: syncController,
                          firstItemTopMargin: firstItemTopMargin,
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: PagingButtons(
                      key: ValueKey(pagingCount),
                      onClickPagingIndex: onClickPagingIndex,
                      pagingCount: pagingCount,
                      primaryColor: primaryColor,
                      lightPrimaryColor: lightPrimaryColor,
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class SyncScrollControllerGroup {
  final List<ScrollController> _controllers = [];
  double _offset = 0;

  ScrollController addAndGet() {
    final c = ScrollController(initialScrollOffset: _offset);
    _controllers.add(c);
    c.addListener(() {
      if (c.offset == _offset) return;
      _offset = c.offset;
      for (var other in _controllers) {
        if (other != c && other.hasClients) {
          other.position.jumpTo(_offset);
        }
      }
    });
    return c;
  }

  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
  }
}

class SyncScrollProvider extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    SyncScrollControllerGroup controller,
  )
  builder;

  const SyncScrollProvider({super.key, required this.builder});

  @override
  State<SyncScrollProvider> createState() => _SyncScrollProviderState();
}

class _SyncScrollProviderState extends State<SyncScrollProvider> {
  final controller = SyncScrollControllerGroup();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, controller);
}
