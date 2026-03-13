import 'package:adaptive_table/filter/filter_view.dart';
import 'package:adaptive_table/paging/paging_buttons.dart';
import 'package:adaptive_table/search/search_table_text_field.dart';
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
  final String? errorString;
  //
  final bool enableHideColumn;
  //
  final int pagingCount;
  final Function(int) onClickPagingIndex;
  //
  final Color primaryColor;
  final Color lightPrimaryColor;
  final List<Color> itemColors;

  const TableWidget({super.key,
    required this.items,
    required this.columns,
    required this.tableTitle,
    required this.onAdd,
    this.enableHideColumn = false,
    this.pagingCount = 1,
    required this.onClickPagingIndex,
    this.isLoading = false,
    this.isError = false,
    this.errorString,
    this.primaryColor = const Color(0xffe33f64),
    this.lightPrimaryColor= const Color(0xfffff8fa),
    this.itemColors = const [
      Color(0xfffff8fa),
      Color(0xfff8f8f8),
    ],
    this.loadingWidget,
    this.errorWidget,
    this.onSearchChange,
    this.onSearchSubmit,
    this.searchHintText,
  });

  @override
  Widget build(BuildContext context) {
    final table = TableModel(
        items: items,
        columns: columns,
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => HideColumnCubit(columns: columns)
        )
      ],
      child: BlocBuilder<HideColumnCubit, int>(
          builder: (context, state) {
            return Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TableTitle(text: tableTitle),
                          const SizedBox(width: 12),
                          TableAddDataButton(onAdd: onAdd, color: primaryColor)
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SearchTableTextField(
                              primaryColor: primaryColor,
                              lightPrimaryColor: lightPrimaryColor,
                              onSearchChange: onSearchChange,
                              onSearchSubmit: onSearchSubmit,
                              hintText: searchHintText ?? '',
                          ),
                          // SizedBox(width: 8),
                          // FilterView(
                          //     primaryColor: primaryColor,
                          //     lightPrimary: lightPrimaryColor,
                          //     columns: columns
                          // )
                        ],
                      ),
                    ]
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TableHeader(
                      table: table,
                      enableHideColumn: enableHideColumn,
                      color: primaryColor,
                      lightColor: lightPrimaryColor,
                    ),
                ),
                Expanded(
                    child: Builder(
                        builder: (context) {
                          if (isLoading) {
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                loadingWidget ?? CircularProgressIndicator(color: primaryColor)
                              ],
                            );
                          }
                          if (isError) {
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                errorWidget ?? Text(errorString ?? 'No Data',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontFamily: 'Afacad',
                                    ),
                                )
                              ],
                            );
                          }
                          return TableContent(
                            table: table,
                            itemColors: itemColors,
                          );
                        }
                    )
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.0667, top: 16),
                  child: Align(
                    alignment: Alignment.center,
                    child: PagingButtons(
                        onClickPagingIndex: onClickPagingIndex,
                        pagingCount: pagingCount,
                        primaryColor: primaryColor,
                        lightPrimaryColor: lightPrimaryColor,
                    )
                  ),
                ),
              ],
            );
          }
      )
    );
  }
}