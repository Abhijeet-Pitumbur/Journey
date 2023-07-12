import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:get/get.dart";
import "package:journey/helpers/colors.dart";
import "package:journey/routers/router.dart";
import "package:journey/widgets/buttons.dart";
import "package:journey/widgets/form-field.dart";
import "package:journey/widgets/hyperlink.dart";
import "package:journey/widgets/input-decoration.dart";

import "controllers/user-controller.dart";
import "helpers/authentication-handler.dart";
import "helpers/helper.dart";
import "helpers/navigators.dart";

final authentication = FirebaseAuth.instance;
GlobalKey<FormState> formKey = GlobalKey<FormState>();
GlobalKey<FormState> forgotFormKey = GlobalKey<FormState>();
bool isLoading = false;
bool showPassword = false;
bool showConfirmPassword = false;
final emailController = TextEditingController();
final nameController = TextEditingController();
final forgotEmailController = TextEditingController();
final passwordController = TextEditingController();
final confirmPasswordController = TextEditingController();

authenticationPopup(bool state) {
  showDialog(
      context: Navigate.navigatorKey.currentContext!,
      builder: (_) {
        return Authentication(state: state);
      },
      useRootNavigator: false);
}

void unfocusForm() {
  Get.focusScope!.unfocus();
}

class Authentication extends StatefulWidget {

  final bool state;

  const Authentication({Key? key, required this.state}) : super(key: key);

  @override
  State<Authentication> createState() => AuthenticationState();

}

class AuthenticationState extends State<Authentication> {

  bool state = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      state = widget.state;
    });
  }

  Future signIn() async {
    try {
      if (formKey.currentState!.validate()) {
        unfocusForm();
        setState(() {
          isLoading = true;
        });
        UserCredential credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text);
        String username = "";
        if (credential.user!.displayName != null) {
          username = credential.user!.displayName!;
        }
        Get.find<UserController>().setUser(
            credential.user!.uid, credential.user!.email!, username);
        Get.find<UserController>().checkUser();
        customPushAndRemoveUntil(Routes.navigation);
      }
    } on FirebaseAuthException catch (error) {
      setState(() {
        isLoading = false;
      });
      NotificationService.showSnackBar(firebaseAuthenticationHandler(error.code));
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      NotificationService.showSnackBar(firebaseAuthenticationHandler("Error $error"));
    }
  }

  signUp() async {
    try {
      if (formKey.currentState!.validate()) {
        if (passwordController.text == confirmPasswordController.text) {
          unfocusForm();
          setState(() {
            isLoading = true;
          });
          String email = emailController.text.trim();
          UserCredential credential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: email, password: passwordController.text);
          User user = credential.user!;
          await user.updateDisplayName(nameController.text.trim());
          await setData(credential.user!.uid, credential.user!.email!);
          Get.find<UserController>().setUser(credential.user!.uid,
              credential.user!.email!, nameController.text.trim());
          Get.find<UserController>().checkUser();
          customPushAndRemoveUntil(Routes.navigation);
        } else {
          NotificationService.showSnackBar(
              firebaseAuthenticationHandler("Invalid password"));
        }
      }
      setState(() {
        isLoading = false;
      });
    } on FirebaseAuthException catch (error) {
      setState(() {
        isLoading = false;
      });
      NotificationService.showSnackBar(firebaseAuthenticationHandler(error.code));
    } catch (error) {
      NotificationService.showSnackBar(firebaseAuthenticationHandler("Error $error"));
      setState(() {
        isLoading = false;
      });
    }
  }

  setData(String userId, String email) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .get();
      if (!snapshot.exists) {
        FirebaseFirestore.instance.collection("users").doc(userId).set({
          "userid": userId,
          "name": nameController.text.trim(),
          "email": email,
          "joindate": DateTime.now(),
        });
      }
    } catch (error) {
      NotificationService.showSnackBar(firebaseAuthenticationHandler("Error $error"));
    }
  }

  void forgotPassword() async {
    try {
      if (forgotFormKey.currentState!.validate()) {
        unfocusForm();
        await authentication.sendPasswordResetEmail(
            email: forgotEmailController.text.trim());
        Get.back(closeOverlays: true);
        NotificationService.showSnackBar(
            "Password reset link sent to your email");
        forgotFormKey.currentState!.reset();
      }
    } on FirebaseAuthException catch (error) {
      NotificationService.showSnackBar(firebaseAuthenticationHandler(error.code));
    } catch (error) {
      NotificationService.showSnackBar(firebaseAuthenticationHandler("Error $error"));
    }
  }

  Widget signInForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Sign in to your account",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: primaryDark),
          ),
          const SizedBox(height: 10),
          richTextHyperlink(
              firstText: "Don't have an account yet? ",
              secondText: "Sign up",
              fontSize: 16,
              onTap: () {
                setState(() {
                  state = false;
                });
              }),
          const SizedBox(height: 34),
          formField(
              text: "Email Address",
              widget: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: inputDecoration(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required";
                  } else if (!GetUtils.isEmail(value)) {
                    return "Invalid email address";
                  }
                  return null;
                },
              )),
          const SizedBox(height: 20),
          formField(
              text: "Password",
              widget: TextFormField(
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: !showPassword,
                decoration: inputDecoration(
                    password: true,
                    showPassword: showPassword,
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    }),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required";
                  }
                  return null;
                },
              )),
          const SizedBox(height: 30),
          SizedBox(
              width: double.infinity,
              child: CustomButton(
                  onPressed: isLoading == true
                      ? null
                      : () {
                          signIn();
                        },
                  text: "Sign In")),
          const SizedBox(height: 18),
          hyperlink(text: "Forgot your password?", onTap: () {})
        ],
      ),
    );
  }

  Widget signUpForm() {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Sign up to get started",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: primaryDark),
          ),
          const SizedBox(height: 10),
          richTextHyperlink(
              firstText: "Already have an account? ",
              secondText: "Sign in",
              fontSize: 16,
              onTap: () {
                setState(() {
                  state = true;
                });
              }),
          const SizedBox(height: 20),
          formField(
              text: "Full Name",
              widget: TextFormField(
                controller: nameController,
                keyboardType: TextInputType.name,
                decoration: inputDecoration(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required";
                  }
                  return null;
                },
              )),
          const SizedBox(height: 15),
          formField(
              text: "Email Address",
              widget: TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: inputDecoration(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required";
                  } else if (!GetUtils.isEmail(value)) {
                    return "Invalid email address";
                  }
                  return null;
                },
              )),
          const SizedBox(height: 15),
          formField(
              text: "Password",
              widget: TextFormField(
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: !showPassword,
                decoration: inputDecoration(
                    password: true,
                    showPassword: showPassword,
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    }),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required";
                  }
                  return null;
                },
              )),
          const SizedBox(height: 15),
          formField(
              text: "Confirm Password",
              widget: TextFormField(
                controller: confirmPasswordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: !showConfirmPassword,
                decoration: inputDecoration(
                    password: true,
                    showPassword: showConfirmPassword,
                    onPressed: () {
                      setState(() {
                        showConfirmPassword = !showConfirmPassword;
                      });
                    }),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Required";
                  }
                  return null;
                },
              )),
          const SizedBox(height: 20),
          SizedBox(
              width: double.infinity,
              child: CustomButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          signUp();
                        },
                  text: "Sign Up")),
          const SizedBox(height: 25),
          const Text(
            "By creating an account, you accept Journey's Terms of Services",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: primaryLight,
      insetPadding: const EdgeInsets.all(15),
      contentPadding: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      content: Stack(
        children: [
          SizedBox(
            width: 350,
            child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: state ? signInForm() : signUpForm()),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: CustomIconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: FontAwesomeIcons.xmark),
          ),
        ],
      ),
    );
  }

}
