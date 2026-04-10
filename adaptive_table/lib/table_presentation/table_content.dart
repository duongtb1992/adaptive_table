import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/hide_column_cubit.dart';
import '../models/table_model.dart';

class TableContent<T> extends StatelessWidget {
  const TableContent({
    super.key,
    required this.table,
    this.itemColors = const [
      Color(0xfffff8fa),
      Color(0xfff8f8f8),
    ],
    required this.onTapItem,
    this.showDeleteButton = false,
    this.onDeleteItem,
    this.firstItemTopMargin = 16.0,
    this.expandedRowBuilder,
    this.canDelete,
  }) ;

  final TableModel<T> table;
  final List<Color> itemColors;
  final Function(T)? onTapItem;
  final bool showDeleteButton;
  final Function(T)? onDeleteItem;
  final double firstItemTopMargin;

  final Widget Function(T item)? expandedRowBuilder;

  final bool Function(T)? canDelete;


  @override
  Widget build(BuildContext context) {
    final hiddenColumnCubit = context.read<HideColumnCubit>();
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          for (int i = 0; i < table.items.length; i++)
            Padding(
              padding: EdgeInsets.only(
                top: i == 0 ? firstItemTopMargin : 0,
                bottom: 16,
              ),
              child: _TableItemRow<T>(
                item: table.items[i],
                table: table,
                itemColor: itemColors[i % itemColors.length],
                onTapItem: onTapItem,
                hiddenColumnCubit: hiddenColumnCubit,
                showDeleteButton: showDeleteButton,
                expandedRowBuilder: expandedRowBuilder,
                onDeleteItem: onDeleteItem,
                canDelete: canDelete,
              ),
            ),
        ],
      ),
    );
  }
}

class _TableItemRow<T> extends StatefulWidget {
  const _TableItemRow({
    required this.item,
    required this.table,
    required this.itemColor,
    required this.onTapItem,
    required this.hiddenColumnCubit,
    required this.showDeleteButton,
    this.expandedRowBuilder,
    required this.onDeleteItem,
    this.canDelete,
  });

  final T item;
  final TableModel<T> table;
  final Color itemColor;
  final Function(T)? onTapItem;
  final HideColumnCubit hiddenColumnCubit;
  final bool showDeleteButton;
  final Function(T)? onDeleteItem;
  final Widget Function(T item)? expandedRowBuilder;
  final bool Function(T)? canDelete;

  @override
  State<_TableItemRow<T>> createState() => _TableItemRowState<T>();
}

class _TableItemRowState<T> extends State<_TableItemRow<T>> {
  bool _isHovered = false;

  bool _isExpanded = false;



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  if (widget.onTapItem == null) return;
                  widget.onTapItem!.call(widget.item);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.itemColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: _isHovered ? [
                      BoxShadow(
                        color: Colors.black.withAlpha(38),
                        blurRadius: 6,
                        offset: const Offset(1, 1),
                      ),
                    ] : [],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: Row(
                    children: [
                      ...widget.table.columns.map((col) {
                        if (widget.hiddenColumnCubit.isHidden(col)) return Container();
                        if (col.flex != null) {
                          return Expanded(
                            flex: col.flex!,
                            child: Row(
                              mainAxisAlignment: col.alignment ?? MainAxisAlignment.center,
                              children: [
                                Flexible(child: col.buildCell(context, widget.item)), // ✅
                              ],
                            ),
                          );
                        }
                        if (col.width != null) {
                          return SizedBox(
                            width: col.width!,
                            child: Row(
                              mainAxisAlignment: col.alignment ?? MainAxisAlignment.center,
                              children: [
                                Flexible(child: col.buildCell(context, widget.item)), // ✅
                              ],
                            ),
                          );
                        }
                        return Container();
                      }),

                      if (widget.expandedRowBuilder != null)
                        GestureDetector(
                          onTap: () => setState(() => _isExpanded = !_isExpanded),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: AnimatedRotation(
                              turns: _isExpanded ? 0.5 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: const Icon(
                                Icons.expand_more_rounded,
                                size: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              if (widget.showDeleteButton && _isHovered && (widget.canDelete?.call(widget.item) ?? true))
                Positioned(
                  top: -8,
                  right: -8,
                  child: GestureDetector(
                    onTap: () => widget.onDeleteItem?.call(widget.item),
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.red, width: 1),
                      ),
                      child: const Icon(Icons.close_rounded, size: 13, color: Colors.red),
                    ),
                  ),
                ),
            ],
          ),
        ),

        if (_isExpanded && widget.expandedRowBuilder != null)
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeInOut,
            child: Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4),
              child: widget.expandedRowBuilder!(widget.item),
            ),
          ),
      ],
    );
  }
}