import 'package:flutter/material.dart';
import 'package:maca_ipe/componetes_gerais/constants.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({Key? key, required String title})
      : super(key: key, title: Text(title), backgroundColor: bgColor);
}
