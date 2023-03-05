import 'package:doll_app/colors.dart';
import 'package:doll_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class DropdownWidget extends StatefulWidget {
  final String status;
  final Function(String) onOptionSelected;

  const DropdownWidget({
    Key? key,
    required this.status,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  _DropdownWidgetState createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  String _selectedOption = '';
  final List<String> _options = statusOptions;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(
          color: primaryColor,
          width: 2.0,
        ),
      ),
      child: ListTile(
        // contentPadding:
        //     const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
        title: Text(
          widget.status,
        ),
        trailing: Text(_selectedOption ?? ''),
        onTap: () {
          showMaterialModalBottomSheet(
            context: context,
            builder: (context) => Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: ListView.builder(
                itemCount: _options.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_options[index]),
                    onTap: () {
                      widget.onOptionSelected(_options[index]);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
