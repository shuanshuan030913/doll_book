import 'package:doll_app/models/detail_type_button.dart';
import 'package:doll_app/models/price_item.dart';
import 'package:doll_app/ui/widgets/form/baby_detail_dialog.dart';
import 'package:doll_app/ui/widgets/form/baby_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants.dart';
import '../../../utils/data_format_utils.dart';

/// 可動態新增輸入框
class DynamicallyTextFormField extends StatefulWidget {
  /// 總計
  final double? total;

  /// 金額明細
  final List<PriceItem>? priceItems;

  final Function(List<PriceItem>, double)? onChanged;
  final FocusNode? focusNode;
  final Function? closeFocus;

  DynamicallyTextFormField({
    Key? key,
    this.total,
    required this.priceItems,
    this.onChanged,
    this.focusNode,
    this.closeFocus,
  }) : super(key: key);

  @override
  _DynamicallyTextFormFieldState createState() =>
      _DynamicallyTextFormFieldState();
}

class _DynamicallyTextFormFieldState extends State<DynamicallyTextFormField> {
  List<PriceItem> _priceItems = [];
  double _total = 0;

  @override
  void initState() {
    super.initState();
    _priceItems = widget.priceItems ?? [];
    _total = widget.total ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  widget.closeFocus!();
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return BabyDetailDialog();
                    },
                  ).then((result) {
                    /// 點擊新增
                    if (result != null) {
                      double totalPrice = _priceItems.fold(
                        0.0, // initial value of the accumulator
                        (accumulator, item) => accumulator + item.price,
                      );
                      setState(() {
                        _priceItems.add(result.priceItem);
                        _total = totalPrice + result.priceItem.price;
                      });
                      widget.onChanged!(
                        _priceItems,
                        _total,
                      );
                    }
                  });
                },
                child: AbsorbPointer(
                  absorbing: false,
                  child: Container(
                    child: Stack(
                      children: [
                        BabyTextFormField(
                          focusNode: widget.focusNode,
                          enabled: false,
                          hintText: '+ 金額',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                        Positioned(
                          top: 14,
                          right: 12,
                          child: Text(
                            formatPrice(widget.total),
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Column(
          children: [
            ..._priceItems.map((item) {
              final DetailTypeButton itemTypeData = priceOptionsButton
                  .firstWhere((button) => button.text == item.type);
              final itemIndex = _priceItems.indexOf(item);
              return SizedBox(
                height: 40,
                child: GestureDetector(
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return BabyDetailDialog(
                          data: item,
                        );
                      },
                    ).then((result) {
                      if (result != null && result.mode == 'delete') {
                        /// 點擊刪除
                        setState(() {
                          _priceItems.remove(item);
                        });
                      } else if (result != null) {
                        /// 點擊編輯
                        List<PriceItem> newPriceItems = List.from(_priceItems);
                        newPriceItems[itemIndex] = result.priceItem;
                        double totalPrice = newPriceItems.fold(
                          0.0, // initial value of the accumulator
                          (accumulator, item) => accumulator + item.price,
                        );
                        setState(() {
                          _priceItems = newPriceItems;
                          _total = totalPrice;
                        });
                        widget.onChanged!(
                          _priceItems,
                          _total,
                        );
                      }
                    });
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            SizedBox(width: 12),
                            Container(
                              width: 28,
                              height: 28,
                              child: CircleAvatar(
                                backgroundColor: itemTypeData.color,
                                child: Icon(
                                  itemTypeData.icon,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(item.name),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '\$ ${formatPrice(item.price)}',
                          textAlign: TextAlign.right,
                        ),
                      ),
                      SizedBox(width: 12),
                    ],
                  ),
                ),
              );
            }).toList()
          ],
        ),
      ],
    );
  }
}
