import 'package:almira_front_end/utils/colors.dart';
import 'package:flutter/material.dart';

class SelectableImage extends StatelessWidget {
  const SelectableImage({
    Key? key,
    required this.isSelected,
    required this.imageNetwork,
    required this.onTap,
  }) : super(key: key);
  final bool isSelected;
  final String imageNetwork;
  final void Function(String imageNetwork) onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(imageNetwork),
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
              border: Border.all(
                  width: 3,
                  color: isSelected ? defaultColor : Colors.transparent)),
          child: Image.network(imageNetwork),
        ),
      ),
    );
  }
}
