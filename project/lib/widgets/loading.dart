import "package:flutter/material.dart";

class Loading extends StatelessWidget {

  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        width: 38,
        height: 38,
        child: CircularProgressIndicator(
            strokeWidth: 5.0,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
      ),
    );
  }

}
