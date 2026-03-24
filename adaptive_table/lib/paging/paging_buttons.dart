import '../buttons/custom_button.dart';
import '../cubit/table_paging_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/table_paging_cubit.dart';

class PagingButtons extends StatelessWidget {
  const PagingButtons({
    super.key,
    required this.onClickPagingIndex,
    required this.pagingCount,
    required this.primaryColor,
    required this.lightPrimaryColor,
  });

  final Function(int) onClickPagingIndex;
  final int pagingCount;
  final Color primaryColor, lightPrimaryColor;

  @override
  Widget build(BuildContext context) {
    if (pagingCount <= 1) return const SizedBox.shrink();
    return BlocProvider(
      create: (context) => TablePagingCubit(
        count: pagingCount,
        onClickPagingIndex: onClickPagingIndex,
      ),
      child: BlocBuilder<TablePagingCubit, int>(
        builder: (context, state) {
          final cubit = context.read<TablePagingCubit>();
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Prev button
              IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: cubit.min ? Colors.grey.shade300 : primaryColor,
                ),
                onPressed: cubit.min ? null : () => cubit.prev(),
              ),

              // Page index buttons
              for (int i in cubit.getSmallIndex())
                _buildItem(context, i, state),
              if (cubit.hasHeadElipsis)
                _buildItem(context, null, state),
              for (int i in cubit.getMiddleIndexes())
                _buildItem(context, i, state),
              if (cubit.hasMiddleElipsis)
                _buildItem(context, null, state),
              for (int i in cubit.getBigIndexes())
                _buildItem(context, i, state),

              // Next button
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: cubit.max ? Colors.grey.shade300 : primaryColor,
                ),
                onPressed: cubit.max ? null : () => cubit.next(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, int? index, int currentIndex) {
    // Ellipsis
    if (index == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Text('...', style: TextStyle(color: Colors.black54)),
      );
    }

    final cubit = context.read<TablePagingCubit>();
    final isActive = index == currentIndex;

    return GestureDetector(
      onTap: () => cubit.goto(index),
      child: Container(
        constraints: const BoxConstraints(minWidth: 35),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isActive ? primaryColor : const Color(0xFFDDDDDD),
          ),
        ),
        child: Center(
          child: Text(
            '${index + 1}',
            style: TextStyle(
              color: isActive ? primaryColor : Colors.black87,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}