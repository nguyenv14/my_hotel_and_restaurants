import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_hotel_and_restaurants/configs/routes/routes_name.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/utils/user_db.dart';
import 'package:my_hotel_and_restaurants/view_model/customer_view_model.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    print("haha");
    final customerProvider =
        Provider.of<CustomerViewModel>(context, listen: true);
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 246, 249, 1),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 70,
            ),
            Container(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.blueGrey,
                ),
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              customerProvider.customerModel.customer_name!,
              style: MyTextStyle.textStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey),
            ),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RoutesName.updateUserPage);
              },
              child: ItemProfileWidget(
                  Icons.person, Colors.greenAccent, "Personal Info"),
            ),
            SizedBox(
              height: 20,
            ),
            ItemProfileWidget(Icons.checklist, Colors.amberAccent, "Evaluated"),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
                onTap: () {
                  // print("hihi");
                  // userPagePresenter.Logout();
                  Navigator.pushNamedAndRemoveUntil(
                      context, RoutesName.login, (route) => false);
                  CherryToast.success(title: Text("Đăng xuất thành công!"))
                      .show(context);
                  CustomerDB.deleteCustomer();
                },
                child: ItemProfileWidget(
                  Icons.logout,
                  Colors.redAccent,
                  "Log out",
                )),
          ],
        ),
      ),
    );
  }

  Widget ItemProfileWidget(IconData iconData, Color iconColor, String title) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color.fromRGBO(232, 234, 241, 1), width: 2),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.white10, offset: Offset(1, 1), blurRadius: 3)
          ]),
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              Container(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: iconColor,
                  ),
                  child: Icon(
                    iconData,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                title,
                style: MyTextStyle.textStyle(
                    fontSize: 14, fontWeight: FontWeight.bold),
              )
            ],
          ),
          Icon(
            FontAwesomeIcons.chevronRight,
            size: 16,
          )
        ]),
      ),
    );
  }
}
