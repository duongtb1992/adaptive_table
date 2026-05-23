import 'package:adaptive_table/cubit/show_filter_cubit.dart';
import 'package:adaptive_table/models/table_column_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../search/search_table_text_field.dart';
import '../table_presentation/hide_column_dropdown.dart';
import 'filter_show_button.dart';

class FilterAndSearchView<T> extends StatelessWidget {
  final Color primaryColor, lightPrimary;
  final List<TableColumnModel<T, dynamic>> columns;
  final Function(String)? onSearchChange, onSearchSubmit;
  final String hintText;
  final bool enableFilter;

  const FilterAndSearchView({
    super.key,
    required this.primaryColor,
    required this.lightPrimary,
    required this.columns,
    this.onSearchChange,
    this.onSearchSubmit,
    required this.hintText,
    required this.enableFilter,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShowFilterCubit(columns: columns),
      child: BlocBuilder<ShowFilterCubit, int>(
        builder: (context, state) {
          final cubit = context.read<ShowFilterCubit>();
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SearchTableTextField(
                primaryColor: primaryColor,
                lightPrimaryColor: lightPrimary,
                onSearchChange: onSearchChange,
                onSearchSubmit: onSearchSubmit,
                hintText: hintText,
              ),
              if (enableFilter) ...[
                SizedBox(width: 8),
                if (cubit.availableFilters.isNotEmpty)
                  FilterShowButton(
                    primaryColor: primaryColor,
                    onTap: (buttonContext, buttonKey) {
                      cubit.reset();
                      //
                      HideColumnDropdownOverlay.show(
                        buttonContext,
                        buttonKey,
                        cubit,
                        cubit.availableFilters,
                        primaryColor,
                        lightPrimary,
                        dropDownTitle: 'HIỂN THỊ FILTER',
                      );
                    },
                    numShow: cubit.shownFilters.length,
                  ),
                if (cubit.shownFilters.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(
                      height: 24,
                      width: 2,
                      color: Color(0xffd9d9d9),
                    ),
                  ),
                Flexible(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 610.0),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: cubit.shownFilters.map((e) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.0),
                            child: e.buildFilter(context),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
