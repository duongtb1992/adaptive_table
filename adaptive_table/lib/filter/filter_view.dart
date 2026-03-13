import 'package:adaptive_table/cubit/show_filter_cubit.dart';
import 'package:adaptive_table/models/table_column_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'filter_show_button.dart';

class FilterView<T> extends StatelessWidget {

  final Color primaryColor, lightPrimary;
  final List<TableColumnModel<T, dynamic>> columns;

  const FilterView({super.key,
    required this.primaryColor,
    required this.lightPrimary,
    required this.columns
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShowFilterCubit(columns: columns),
      child: BlocBuilder<ShowFilterCubit, int>(
          builder: (context, state) {
            final cubit = context.read<ShowFilterCubit>();
            return Row(
              children: [
                if (cubit.availableFilters.isNotEmpty)
                  FilterShowButton(
                      primaryColor: primaryColor,
                      onTap: (context, buttonKey) {
                      }
                  ),
              ],
            );
          },
      )
    );
  }

}