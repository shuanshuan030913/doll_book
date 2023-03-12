import 'package:doll_app/ui/widgets/form/baby_detail_dialog.dart';
import 'package:doll_app/ui/widgets/form/baby_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return BabyDetailDialog();
              },
            );
          },
          child: AbsorbPointer(
            absorbing: false,
            child: BabyTextFormField(
              enabled: false,
              hintText: '+金額',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
        ),
      ],
    );
  }
}
