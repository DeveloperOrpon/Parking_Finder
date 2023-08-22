import 'package:flutter/material.dart';
import 'package:parking_finder/utilities/app_colors.dart';

class MenuItemWidget extends StatelessWidget {
  final MenuClass? item;
  final Widget? widthBox;
  final void Function(int)? callback;
  final bool? selected;

  const MenuItemWidget({
    Key? key,
    this.item,
    this.widthBox,
    this.callback,
    this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => callback!(item!.index),
      style: TextButton.styleFrom(
        backgroundColor: selected!
            ? AppColors.primaryColor.withOpacity(.7)
            : AppColors.primaryColor.withOpacity(.1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            item!.icon,
            color: selected! ? Colors.white : AppColors.primaryColor,
            size: 24,
          ),
          widthBox!,
          Expanded(
            child: Text(
              item!.title,
              style: TextStyle(
                  color: selected! ? Colors.white : null,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}

class MenuClass {
  final String title;
  final IconData icon;
  final int index;

  const MenuClass(this.title, this.icon, this.index);
}

const List<MenuClass> mainMenu = [
  MenuClass("Profile", Icons.payment, 0),
  MenuClass("Notifications", Icons.notifications, 2),
  MenuClass("Support", Icons.help, 3),
  MenuClass("NearBy Garage", Icons.garage, 4),
  MenuClass("NearBy Parking", Icons.local_parking, 5),
];
