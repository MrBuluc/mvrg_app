import 'package:flutter/material.dart';

class RankDropdownButton extends StatelessWidget {
  final String? value;
  final void Function(String?)? onChanged;

  const RankDropdownButton(
      {Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: DropdownButton<String>(
        focusColor: Colors.white,
        value: value,
        style: const TextStyle(color: Colors.white),
        iconEnabledColor: Colors.black,
        onChanged: onChanged,
        items: ["0", "1", "2", "3"]
            .map<DropdownMenuItem<String>>(
                (String itemsValue) => DropdownMenuItem<String>(
                    value: itemsValue,
                    child: Text(
                      itemsValue,
                      style: const TextStyle(color: Colors.black),
                    )))
            .toList(),
      ),
    );
  }
}
