import 'package:doll_app/models/navigator_detail_data.dart';
import 'package:doll_app/models/price_item.dart';
import 'package:doll_app/ui/widgets/icon_text_button.dart';
import 'package:doll_app/ui/widgets/form/baby_text_form_field.dart';
import 'package:doll_app/utils/data_format_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants.dart';

/// 可動態新增輸入框
class BabyDetailDialog extends StatefulWidget {
  final PriceItem? data;
  const BabyDetailDialog({
    Key? key,
    this.data,
  }) : super(key: key);

  @override
  _BabyDetailDialogState createState() => _BabyDetailDialogState();
}

class _BabyDetailDialogState extends State<BabyDetailDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();
  String? _iconType;
  String _name = '';
  double? _price;

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      _iconType = widget.data!.type;
      _name = widget.data!.name ?? '';
      _price = widget.data!.price;
      _textController.text = widget.data!.name ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonWidgets = priceOptionsButton.map((button) {
      return IconTextButton(
        icon: button.icon,
        text: button.text,
        color: button.color,
        isShowed: _iconType == button.text,
        onPressed: () {
          _textController.text = button.text;
          setState(() {
            _iconType = button.text;
          });
        },
      );
    }).toList();

    return AlertDialog(
      title: const Text(
        '款項明細',
        textAlign: TextAlign.center,
      ),
      content: Form(
        key: _formKey,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: buttonWidgets.take(5).toList(),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: buttonWidgets.skip(5).toList(),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: BabyTextFormField(
                      controller: _textController,
                      hintText: '名稱',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return '必填項目';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _name = value!;
                      },
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: BabyTextFormField(
                        initialValue: formatPrice(_price),
                        hintText: '金額',
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          return null;
                        },
                        onSaved: (value) {
                          _price = double.tryParse(value!);
                        },
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        Row(
          children: [
            if (widget.data != null)
              Expanded(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(
                      NavigatorDetailData(
                        mode: 'delete',
                        priceItem: PriceItem(
                          name: _name,
                          type: _iconType ?? '其他',
                          price: _price ?? 0,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    '刪除',
                    style: TextStyle(
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
            SizedBox(width: 10),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ),
                onPressed: () {
                  // Do something when the "OK" button is pressed
                  Navigator.of(context).pop();
                },
                child: Text(
                  '取消',
                  style: TextStyle(
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Navigator.of(context).pop(
                      NavigatorDetailData(
                        mode: widget.data != null ? 'edit' : 'add',
                        priceItem: PriceItem(
                          name: _name,
                          type: _iconType ?? '其他',
                          price: _price ?? 0,
                        ),
                      ),
                    );
                  }
                },
                child: const Text('確定'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
