import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/view/login/components/InputFieldComponet.dart';
import 'package:my_hotel_and_restaurants/view_model/login/login_view_model.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameEdit = TextEditingController();
  TextEditingController phoneEdit = TextEditingController();
  TextEditingController emailEdit = TextEditingController();
  TextEditingController passEdit = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        body: Consumer<LoginViewModel>(
      builder: (context, value, child) {
        return SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: SizedBox(
                      width: context.mediaQueryWidth * 0.5,
                      child: Lottie.asset("assets/raw/register.json")),
                ),
                Text(
                  "Register",
                  style: MyTextStyle.textStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      InputFieldComponent(
                        titleText: "Username",
                        iconData: FontAwesomeIcons.solidUser,
                        hintText: "Enter Username...",
                        textEditingController: nameEdit,
                        color: Colors.pinkAccent[100]!,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InputFieldComponent(
                        titleText: "Email",
                        iconData: FontAwesomeIcons.solidEnvelope,
                        hintText: "Enter your email...",
                        textEditingController: emailEdit,
                        color: Colors.pinkAccent[100]!,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InputFieldComponent(
                        titleText: "Phone number",
                        iconData: FontAwesomeIcons.phone,
                        hintText: "Enter Username...",
                        textEditingController: phoneEdit,
                        color: Colors.pinkAccent[100]!,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      InputFieldComponent(
                        isPassword: true,
                        titleText: "Password",
                        iconData: FontAwesomeIcons.lock,
                        hintText: "Enter Password",
                        textEditingController: passEdit,
                        color: Colors.pinkAccent[100]!,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                value.sinUpLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: ColorData.myColor,
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          if (nameEdit.text.isEmpty ||
                              emailEdit.text.isEmpty ||
                              phoneEdit.text.isEmpty ||
                              passEdit.text.isEmpty) {
                            CherryToast.warning(
                              title: const Text("Điền đủ thông tin!"),
                            ).show(context);
                          } else {
                            value
                                .signUp(emailEdit.text, passEdit.text,
                                    phoneEdit.text, nameEdit.text)
                                .then((value) {
                              if (value.statusCode! == 200) {
                                Navigator.pop(context);
                                CherryToast.success(
                                  title: const Text("Đăng ký thành công!"),
                                ).show(context);
                              } else {
                                CherryToast.error(
                                  title: const Text("Email đã được tồn tại!"),
                                ).show(context);
                              }
                            });
                          }
                        },
                        child: Container(
                          width: context.mediaQueryWidth * 0.9,
                          decoration: BoxDecoration(
                              color: ColorData.myColor,
                              borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 14),
                          child: Center(
                              child: Text(
                            "Sign up",
                            style: GoogleFonts.openSans(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
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
                            text: "Sign In",
                            style: GoogleFonts.openSans(
                                color: ColorData.myColor,
                                fontWeight: FontWeight.bold))
                      ]))),
                ),
              ],
            ),
          ),
        );
      },
    ));
  }
}
