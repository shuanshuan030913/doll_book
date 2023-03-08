import 'package:doll_app/ui/components/icon_text_button.dart';
import 'package:doll_app/ui/form/BabyTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

/// 可動態新增輸入框
class DynamicallyTextFormField extends StatefulWidget {
  final String? initialValue;
  final String? hintText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final Function(String?)? onSaved;

  const DynamicallyTextFormField({
    Key? key,
    this.initialValue,
    this.hintText,
    this.keyboardType,
    this.inputFormatters,
    this.controller,
    this.onSaved,
  }) : super(key: key);

  @override
  _DynamicallyTextFormFieldState createState() =>
      _DynamicallyTextFormFieldState();
}

class _DynamicallyTextFormFieldState extends State<DynamicallyTextFormField> {
  // String _selectedOption = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // if (isEditable) {
            //   // allow user to edit field
            // } else {
            // show some other view or do something else
            showMaterialModalBottomSheet(
              context: context,
              builder: (context) => Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            IconTextButton(
                              icon: Icons.face,
                              text: '娃娃',
                              color: const Color.fromARGB(255, 255, 169, 119),
                            ),
                            SizedBox(width: 14),
                            IconTextButton(
                              icon: Icons.checkroom,
                              text: '娃衣',
                              color: Color.fromARGB(255, 244, 223, 127),
                            ),
                            SizedBox(width: 14),
                            IconTextButton(
                              icon: Icons.auto_graph,
                              text: '裝骨',
                              color: Color.fromARGB(255, 213, 127, 244),
                            ),
                            SizedBox(width: 14),
                            IconTextButton(
                              icon: Icons.pets,
                              text: '耳朵',
                              color: Color.fromARGB(255, 145, 172, 253),
                            ),
                            SizedBox(width: 14),
                            IconTextButton(
                              icon: Icons.nightlight,
                              text: '尾巴',
                              color: Color.fromARGB(255, 129, 135, 243),
                            ),
                            SizedBox(width: 14),
                            IconTextButton(
                              icon: Icons.sell,
                              text: '出生證',
                              color: Color.fromARGB(255, 238, 145, 145),
                            ),
                            SizedBox(width: 14),
                            IconTextButton(
                              icon: Icons.redeem,
                              text: '特典',
                              color: Color.fromARGB(255, 127, 184, 244),
                            ),
                            SizedBox(width: 14),
                            IconTextButton(
                              icon: Icons.local_shipping,
                              text: '運費',
                              color: Color.fromARGB(255, 127, 217, 244),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
            // }
          },
          child: AbsorbPointer(
            absorbing: false,
            child: BabyTextFormField(
              enabled: false,
              hintText: '金額',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
        ),
      ],
    );
  }
}
