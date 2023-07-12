import "package:flutter/gestures.dart";
import "package:flutter/material.dart";

Widget richTextHyperlink({
  required String firstText,
  required String secondText,
  required void Function()? onTap,
  double fontSize = 14,
  FontWeight fontWeight = FontWeight.normal,
  Color firstTextColor = Colors.black87,
  Color secondTextColor = Colors.black,
}) {
  return RichText(
    text: TextSpan(
      children: [
        TextSpan(
            text: firstText,
            style: TextStyle(
                fontSize: fontSize, color: firstTextColor, fontWeight: fontWeight)),
        TextSpan(
          text: secondText,
          style: hyperlinkStyle(
              fontSize: fontSize, color: secondTextColor, fontWeight: fontWeight),
          recognizer: TapGestureRecognizer()..onTap = onTap,
        ),
      ],
    ),
  );
}

Widget hyperlink({required String text, required void Function()? onTap}) {
  return InkWell(
    splashColor: Colors.transparent,
    hoverColor: Colors.transparent,
    focusColor: Colors.transparent,
    highlightColor: Colors.transparent,
    onTap: onTap,
    child: Text(text, style: hyperlinkStyle()),
  );
}

TextStyle hyperlinkStyle(
    {double? fontSize = 12,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.normal}) {
  return TextStyle(
    color: Colors.transparent,
    shadows: [Shadow(color: color, offset: const Offset(0, -1))],
    decoration: TextDecoration.underline,
    decorationColor: color,
    fontSize: fontSize,
  );
}
