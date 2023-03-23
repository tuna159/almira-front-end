import 'package:flutter/material.dart';

enum MenuItems { itemBlock, itemUnblock }

const itemBlock = MenuItemCheck(
  text: 'Block',
  icon: Icons.delete,
);

const itemUnblock = MenuItemCheck(
  text: 'Unblock',
  icon: Icons.delete,
);

class MenuItemCheck {
  final String text;
  final IconData icon;

  const MenuItemCheck({
    required this.text,
    required this.icon,
  });
}
