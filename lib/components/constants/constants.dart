import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

const red = Colors.red;
const deepOrange = Colors.deepOrange;
const orange = Colors.orange;
const theme = Color.fromRGBO(72, 83, 153, 1);
const secondaryTheme = Color.fromRGBO(93, 183, 233, 1);
const white = Colors.white;
const grey = Colors.grey;
const trans = Colors.transparent;
const amber = Colors.amber;
const black = Colors.black;
const blue = Color.fromRGBO(93, 183, 234, 1);
const pink = Colors.pink;
const green = Colors.green;
const backgroundColor = Color.fromARGB(255, 229, 229, 229);

const realmeWidth = 941;

const lottiePath = "assets/lottie";
const imagesPath = "assets/images";

const infinity = double.infinity;

RegExp regExpAlphaNumeric = RegExp(r'^[a-zA-Z0-9_]*$');
RegExp regExpEmojis = RegExp(
  '(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])',
);

const List<String> listOfWeekdays = [
  "",
  "Mon",
  "Tue",
  "Wed",
  "Thu",
  "Fri",
  "Sat",
  "Sun",
];
const List<String> listOfMonths = [
  "",
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];

const Map<String, IconData> typesOfTasks = {
  "Personal": MdiIcons.accountOutline,
  "Work": MdiIcons.briefcaseOutline,
  "Business": MdiIcons.handshakeOutline,
  "Family": MdiIcons.humanMaleFemaleChild,
  "Miscellaneous": MdiIcons.collage,
};
