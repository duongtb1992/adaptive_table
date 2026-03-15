import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../buttons/custom_button.dart';
import '../buttons/custom_tickbox.dart';
import '../cubit/hide_column_cubit.dart';
import '../models/table_column_model.dart';

class HideColumnDropdownOverlay {
  static OverlayEntry? _overlayEntry;

  static void show(BuildContext context,
      GlobalKey key,
      HideColumnCubit cubit,
      List<TableColumnBase> columns,
      Color primaryColor,
      Color lightPrimaryColor,
      {String dropDownTitle = 'CHỌN CỘT HIỂN THỊ'}
  ) {
    if (_overlayEntry != null) {
      hide();
      return;
    }

    final renderBox = key.currentContext!.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    final position = renderBox.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );

    final size = renderBox.size;

    print('x-y: ${position.dx}-${position.dy}');

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            GestureDetector(
              onTap: hide,
              child: Container(color: Colors.transparent),
            ),
            Positioned(
              left: position.dx + size.width - 267,
              top: position.dy + size.height + 8,
              child: HideColumnDropdownPanel(
                columns: columns,
                cubit: cubit,
                onCancel: hide,
                primaryColor: primaryColor,
                lightPrimaryColor: lightPrimaryColor,
                dropDownTitle: dropDownTitle,
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

class HideColumnDropdownPanel extends StatelessWidget {

  const HideColumnDropdownPanel({super.key,
    required this.cubit,
    required this.columns,
    required this.onCancel,
    required this.primaryColor,
    required this.lightPrimaryColor,
    required this.dropDownTitle,
  });

  final HideColumnCubit cubit;
  final List<TableColumnBase> columns;
  final Function() onCancel;
  final Color primaryColor;
  final Color lightPrimaryColor;
  final String dropDownTitle;

  @override
  Widget build(BuildContext context) {
    print('hide column panel');
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: BlocBuilder<HideColumnCubit, int>(
        bloc: cubit,
        builder: (context, state) {
          return Container(
            width: 267,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  dropDownTitle,
                  style: TextStyle(
                      fontFamily: 'Afacad',
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      height: 1.25
                  ),
                ),
                ...columns.map((e) {
                  bool isLastIndex = columns.indexOf(e) == columns.length - 1;
                  return CustomTickBox(
                      text: e.title,
                      isTick: !cubit.isPendingHidden(e),
                      isLastIndex: isLastIndex,
                      onTap: () {
                        cubit.hideOrUnhide(e);
                      },
                    primaryColor: primaryColor,
                  );
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomButton(
                      label: 'Huỷ bỏ',
                      onPressed: onCancel,
                      borderColor: Colors.transparent,
                      bgColor: Colors.transparent,
                      textColor: Color(0xff757575),
                      useShadow: false,
                    ),
                    const SizedBox(width: 9),
                    CustomButton(
                      borderColor: primaryColor,
                      bgColor: lightPrimaryColor,
                      textColor: primaryColor,
                      label: 'Xác nhận',
                      onPressed: () {
                        cubit.update();
                        //
                        onCancel.call();
                      },
                    ),
                  ]
                ),
              ],
            ),
          );
        },
      )
    );
  }
}