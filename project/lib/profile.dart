import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:get/get.dart";
import "package:journey/controllers/user-controller.dart";

import "helpers/colors.dart";

class User {

  final String imagePath;
  final String name;
  final String email;
  final String about;
  final bool isDarkMode;

  const User({
    required this.imagePath,
    required this.name,
    required this.email,
    required this.about,
    required this.isDarkMode,
  });

}

class Profile extends StatefulWidget {

  const Profile({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  ProfileState createState() => ProfileState();

}

class ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    const user = UserPreferences.myUser;
    return Scaffold(
      backgroundColor: primaryMedium,
      appBar: buildAppBar(context),
      body: Column(
        children: [
          Flexible(
              child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    ProfileWidget(
                      imagePath: user.imagePath,
                      onTap: () async {},
                    ),
                    buildName(user),
                    const SizedBox(height: 24),
                    Center(child: buildUpgradeButton()),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
            ],
          )),
          Flexible(
            child: Stack(
              children: [
                Container(
                  color: Colors.white,
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: primaryLight,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      buildAbout(user),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildName(User user) => Column(
        children: [
          const SizedBox(height: 10),
          Text(
            Get.find<UserController>().name.value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
          ),
          const SizedBox(height: 4),
          Text(
            Get.find<UserController>().email.value,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 17),
          )
        ],
      );

  Widget buildUpgradeButton() => MaterialButton(
        textColor: Colors.white,
        minWidth: 250,
        height: 60,
        onPressed: () {},
        color: primaryMedium,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const Text(
          "Upgrade to VIP",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
      );

  Widget buildAbout(User user) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "About",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryDark),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.about,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );

}

class UserPreferences {
  static const myUser = User(
    imagePath: "images/profile.png",
    name: "Test User",
    email: "test@user.com",
    about:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
    isDarkMode: false,
  );
}

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    toolbarHeight: 90,
    backgroundColor: primaryMedium,
    title: const Text(
      "Profile",
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
    ),
    elevation: 0,
    actions: [
      IconButton(
        padding:
            const EdgeInsets.only(left: 10, top: 10, right: 20, bottom: 10),
        icon: const Icon(
          FontAwesomeIcons.arrowRightFromBracket,
          color: Colors.white,
        ),
        onPressed: () {
          Get.find<UserController>().signOut();
        },
      ),
    ],
  );
}

class ProfileWidget extends StatelessWidget {

  final String imagePath;
  final VoidCallback onTap;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    final image = AssetImage(imagePath);
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 120,
          height: 120,
          child: InkWell(onTap: onTap),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: const Icon(
            FontAwesomeIcons.pen,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );

}
