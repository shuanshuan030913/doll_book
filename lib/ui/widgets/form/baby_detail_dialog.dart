import 'package:doll_app/ui/widgets/icon_text_button.dart';
import 'package:doll_app/ui/widgets/form/baby_text_form_field.dart';
import 'package:doll_app/models/detail_type_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 可動態新增輸入框
class BabyDetailDialog extends StatefulWidget {
  const BabyDetailDialog({
    Key? key,
  }) : super(key: key);

  @override
  _BabyDetailDialogState createState() => _BabyDetailDialogState();
}

class _BabyDetailDialogState extends State<BabyDetailDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();
  String _iconType = '';
  String _name = '';
  double? _price;

  final List<DetailTypeButton> firstRowButton = [
    DetailTypeButton(
      icon: Icons.face,
      color: const Color.fromARGB(255, 255, 169, 119),
      text: '娃娃',
    ),
    DetailTypeButton(
      icon: Icons.checkroom,
      color: const Color.fromARGB(255, 241, 225, 132),
      text: '娃衣',
    ),
    DetailTypeButton(
      icon: Icons.auto_graph,
      color: const Color.fromARGB(255, 217, 154, 239),
      text: '加骨',
    ),
    DetailTypeButton(
      icon: Icons.pets,
      color: const Color.fromARGB(255, 125, 219, 192),
      text: '耳朵',
    ),
    DetailTypeButton(
      icon: Icons.nightlight,
      color: const Color.fromARGB(255, 129, 135, 243),
      text: '尾巴',
    ),
  ];

  final List<DetailTypeButton> secondRowButton = [
    DetailTypeButton(
      icon: Icons.cut,
      color: const Color.fromARGB(255, 161, 220, 133),
      text: '髮型',
    ),
    DetailTypeButton(
      icon: Icons.cake,
      color: const Color.fromARGB(255, 235, 136, 136),
      text: '出生證',
    ),
    DetailTypeButton(
      icon: Icons.redeem,
      color: const Color.fromARGB(255, 127, 184, 244),
      text: '特典',
    ),
    DetailTypeButton(
      icon: Icons.local_shipping,
      color: const Color.fromARGB(255, 123, 226, 244),
      text: '運費',
    ),
    DetailTypeButton(
      icon: Icons.add_reaction,
      color: const Color.fromARGB(255, 213, 213, 213),
      text: '其他',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
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
                children: firstRowButton.map((button) {
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
                }).toList(),
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: secondRowButton.map((button) {
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
                }).toList(),
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: BabyTextFormField(
                      controller: _textController,
                      hintText: '名稱',
                      onSaved: (value) {
                        _name = value!;
                      },
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: BabyTextFormField(
                        // initialValue: _formatPrice(_priceAdd),
                        hintText: '金額',
                        keyboardType: TextInputType.number,
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
      insetPadding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
      actions: [
        TextButton(
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
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              // Do something with the form data
              print('Name: $_name');
              print('Price: $_price');
              Navigator.of(context).pop();
            }
          },
          child: Text('確定'),
        ),
      ],
    );
  }
}
