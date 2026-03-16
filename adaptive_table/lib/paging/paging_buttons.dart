import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../buttons/custom_button.dart';
import '../cubit/table_paging_cubit.dart';

class PagingButtons extends StatelessWidget {
  
  const PagingButtons({super.key, 
    required this.onClickPagingIndex,
    required this.pagingCount,
    required this.primaryColor,
    required this.lightPrimaryColor
  });
  
  final Function(int) onClickPagingIndex;
  final int pagingCount;
  final Color primaryColor, lightPrimaryColor;
  
  @override
  Widget build(BuildContext context) {
    if (pagingCount <= 1) return Container();
    return BlocProvider(
      create: (context) => TablePagingCubit(count: pagingCount, onClickPagingIndex: onClickPagingIndex),
      child: BlocBuilder<TablePagingCubit, int>(
        builder: (context, state) {
          final cubit = context.read<TablePagingCubit>();
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (!cubit.min)
                        CustomButton(
                          width: 42,
                          height: 38,
                          widget: Icon(Icons.arrow_back_ios_new_rounded,
                            color: primaryColor,
                            size: 12,
                          ),
                          bgColor: lightPrimaryColor,
                          onPressed: () {
                            cubit.prev();
                          },
                        ),
                    ],
                  ),
              ),
              const SizedBox(width: 32),
              //index buttons
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
              //
              const SizedBox(width: 32),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (!cubit.max)
                      CustomButton(
                        width: 42,
                        height: 38,
                        widget: Icon(Icons.arrow_forward_ios_rounded,
                          color: primaryColor,
                          size: 12,
                        ),
                        bgColor: lightPrimaryColor,
                        onPressed: () {
                          cubit.next();
                        },
                      ),
                  ],
                ),
              ),
            ],
          );
        }
      )
    );
  }

  Widget _buildItem(BuildContext context, int? index, int currentIndex) {
    final cubit = context.read<TablePagingCubit>();
    return Padding(
        padding: const EdgeInsets.all(6.0),
        child: Builder(
          builder: (context) {
            if (index == null) {
              return const CustomButton(
                width: 42,
                height: 38,
                label: '...',
                textColor: Color(0xff3d3d3d),
                bgColor: Color(0xfff5f5f5),
                borderColor: Color(0xfff5f5f5),
                useShadow: false,
              );
            }
            return CustomButton(
              hPadding: 6,
              width: 40,
              height: 36,
              label: '${index + 1}',
              textColor: index == currentIndex
                  ? primaryColor
                  : const Color(0xff3d3d3d),
              borderColor: index == currentIndex
                  ? primaryColor
                  : lightPrimaryColor,
              bgColor: lightPrimaryColor,
              onPressed: () {
                cubit.goto(index);
              },
            );
          }
        ),
    );
  }
  
}