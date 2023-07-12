import "package:flutter/material.dart";
import "package:journey/helpers/colors.dart";

class CustomButton extends StatelessWidget {

  final VoidCallback? onPressed;
  final String text;
  final Color color;

  const CustomButton(
      {Key? key,
        required this.onPressed,
        required this.text,
        this.color = primaryMedium})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          primary: color,
          shadowColor: color,
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

}

class CustomIconButton extends StatelessWidget {

  final void Function()? onPressed;
  final IconData icon;
  final Color color;

  const CustomIconButton(
      {Key? key,
      this.onPressed,
      required this.icon,
      this.color = const Color(0xff4d4d4d)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: color,
      ),
      splashRadius: 20,
    );
  }

}

class CustomOutlineButton extends StatelessWidget {

  final VoidCallback? onPressed;
  final String text;
  final Color color;

  const CustomOutlineButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      this.color = primaryMedium})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: OutlinedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          shadowColor: color,
        ),
        child: Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

}
