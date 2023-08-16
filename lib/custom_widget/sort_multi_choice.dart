import 'package:flutter/material.dart';
import 'package:parking_finder/utilities/app_colors.dart';

class MultipleChipChoiceWidget extends StatefulWidget {
  final List<String> reportList;

  const MultipleChipChoiceWidget({Key? key, required this.reportList})
      : super(key: key);

  @override
  State<MultipleChipChoiceWidget> createState() =>
      _MultipleChipChoiceWidgetState();
}

class _MultipleChipChoiceWidgetState extends State<MultipleChipChoiceWidget> {
  String selectedChoice = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: widget.reportList
            .map(
              (item) => Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: ChoiceChip(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: AppColors.primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  selectedColor: AppColors.primaryColor,
                  backgroundColor: Colors.white,
                  onSelected: (value) {
                    setState(() {
                      selectedChoice = item;
                    });
                  },
                  padding: const EdgeInsets.all(7),
                  label: Text(item),
                  selected: selectedChoice == item,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
