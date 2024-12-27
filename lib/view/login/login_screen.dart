import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/configs/routes/routes_name.dart';
import 'package:my_hotel_and_restaurants/view/login/components/InputFieldComponet.dart';
import 'package:my_hotel_and_restaurants/view_model/login/login_view_model.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController textControllerMail = TextEditingController();
  TextEditingController textControllerPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            Consumer<LoginViewModel>(
              builder: (context, loginViewModel, child) {
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome!",
                        style: GoogleFonts.openSans(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.w800),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                        child: Text(
                          "Unlock a world of flavors with your culinary passport.",
                          style: GoogleFonts.openSans(
                              color: Colors.black38,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      InputFieldComponent(
                        titleText: "Email",
                        hintText: "Enter your email",
                        iconData: FontAwesomeIcons.userTie,
                        textEditingController: textControllerMail,
                        color: Colors.pinkAccent[100]!,
                        // isPassword: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // InputPasswordComponent()
                      InputFieldComponent(
                        titleText: "Password",
                        hintText: "Enter your password",
                        iconData: FontAwesomeIcons.lock,
                        textEditingController: textControllerPass,
                        color: Colors.pinkAccent[100]!,
                        isPassword: true,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            child: Text(
                              "Forgott Password?",
                              style: GoogleFonts.openSans(
                                  color: ColorData.myColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      loginViewModel.loginLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: ColorData.myColor,
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                loginViewModel
                                    .loginApi(textControllerMail.text,
                                        textControllerPass.text)
                                    .then((value) {
                                  // print(value.message);
                                  if (value.statusCode == 200) {
                                    CherryToast.success(
                                      title:
                                          const Text("Đăng nhập thành công!"),
                                    ).show(context);
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        RoutesName.home, (route) => false);
                                  } else {
                                    CherryToast.error(
                                            title: const Text(
                                                "Sai mật khẩu hoặc email!"))
                                        .show(context);
                                  }
                                });
                              },
                              child: Center(
                                child: Container(
                                  width: context.mediaQueryWidth * 0.8,
                                  decoration: BoxDecoration(
                                      color: ColorData.myColor,
                                      borderRadius: BorderRadius.circular(30)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 14),
                                  child: Center(
                                      child: Text(
                                    "Sign in",
                                    style: GoogleFonts.openSans(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 20,
                      ),

                      Center(
                        child: Text(
                          "Or Continue with",
                          style:
                              GoogleFonts.openSans(fontWeight: FontWeight.bold),
                        ),
                      ),

                      const SizedBox(
                        height: 30,
                      ),
                      loginViewModel.ggLoading == true
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: ColorData.myColor,
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                loginViewModel.signInWithGoogle().then((value) {
                                  // print(value.message);
                                  if (value.statusCode == 200) {
                                    CherryToast.success(
                                      title: const Text(
                                          "Đăng nhập bằng GG thành công!"),
                                    ).show(context);
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        RoutesName.home, (route) => false);
                                  } else {
                                    CherryToast.error(
                                            title: const Text(
                                                "Email đã được đăng nhập!!!"))
                                        .show(context);
                                  }
                                });
                              },
                              child: Center(
                                child: Container(
                                  width: context.mediaQueryWidth * 0.8,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.black12,
                                            offset: Offset(1, 1),
                                            blurRadius: 10)
                                      ],
                                      borderRadius: BorderRadius.circular(30)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 14),
                                  child: Center(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Image(
                                        image: AssetImage(
                                            "assets/images/search.png"),
                                        width: 20,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Signin with Google",
                                        style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                            ),
                      SizedBox(
                        height: context.mediaQueryHeight * 0.15,
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RoutesName.registerPage);
                        },
                        child: Center(
                            child: RichText(
                                text: TextSpan(
                                    text: "Don't have an account? ",
                                    style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                    children: [
                              TextSpan(
                                  text: "Sign up",
                                  style: GoogleFonts.openSans(
                                      color: ColorData.myColor,
                                      fontWeight: FontWeight.bold))
                            ]))),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
