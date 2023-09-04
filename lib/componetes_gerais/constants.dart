import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const Color primaryColor = Colors.green; // Verde
const Color secondaryColor = Color(0xFFADFF2F); // Verde claro
const Color textColorBT = Color(0xFF000000); // Preto
const Color textColor = Color.fromARGB(255, 255, 255, 255); // Branco
const Color buttonColor = Colors.greenAccent; // Verde
const Color alertColor = Colors.red; // Vermelho
const Color bgColor2 = Color.fromARGB(255, 45, 72, 85);
const Color bgColor = Color.fromARGB(255, 72, 108, 125);
const Color iconColor = Colors.red;

const defaultPadding = 16.0;
const fontTitle = 20.0;
const fontSubTitle = 16.0;
const romaneioArea = 480.0;

const maxWidthArea = 900;

DataCell columnData(String data, {String message = ''}) {
  return DataCell(Tooltip(
      message: message,
      child: Text(data, style: const TextStyle(fontSize: 16))));
}

DataCell columnDataField(String data, VoidCallbackAction function, {String message = ''}) {
  return DataCell(Tooltip(
      message: message,
      child: TextField(onChanged: (value) => function, style: const TextStyle(fontSize: 16))));
}

DataColumn columnTable(String title) {
  return DataColumn(
    label: Text(
      title,
      style: const TextStyle(color: textColor),
    ),
  );
}

DataCell columnIconBtn(VoidCallback press, String icon) {
  return DataCell(
    SvgPicture.asset(
      icon,
      height: 25,
    ),
    onTap: press,
  );
}
