import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";

import "buttons.dart";

InputDecoration inputDecoration(
    {bool password = false, bool? showPassword, void Function()? onPressed}) {
  return InputDecoration(
    suffixIcon: password
        ? CustomIconButton(
            onPressed: onPressed,
            icon: showPassword!
                ? FontAwesomeIcons.eye
                : FontAwesomeIcons.eyeSlash,
          )
        : null,
    isDense: true,
    hoverColor: Colors.transparent,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: Colors.black87.withOpacity(0.3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(color: Colors.blue.shade900, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(color: Colors.red, width: 2),
    ),
    disabledBorder: InputBorder.none,
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: const BorderSide(color: Colors.red, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
  );
}
