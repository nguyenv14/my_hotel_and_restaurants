import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/model/customer_model.dart';
import 'package:my_hotel_and_restaurants/utils/user_db.dart';
import 'package:my_hotel_and_restaurants/view_model/customer_view_model.dart';
import 'package:provider/provider.dart';

class UpdateUserPage extends StatefulWidget {
  const UpdateUserPage({super.key});

  @override
  State<UpdateUserPage> createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  TextEditingController nameEdit =
      TextEditingController(text: CustomerDB.getCustomer()!.customer_name!);

  TextEditingController emailEdit =
      TextEditingController(text: CustomerDB.getCustomer()!.customer_email!);

  TextEditingController phoneEdit = TextEditingController(
      text: "0${CustomerDB.getCustomer()!.customer_phone}");
  bool isChange = false;

  @override
  Widget build(BuildContext context) {
    nameEdit.addListener(() {
      if (nameEdit.text != CustomerDB.getCustomer()!.customer_name!) {
        setState(() {
          isChange = true;
        });
      } else {
        setState(() {
          isChange = false;
        });
      }
    });

    emailEdit.addListener(() {
      if (emailEdit.text != CustomerDB.getCustomer()!.customer_email!) {
        setState(() {
          isChange = true;
        });
      } else {
        setState(() {
          isChange = false;
        });
      }
    });

    phoneEdit.addListener(() {
      if (phoneEdit.text !=
          "0${CustomerDB.getCustomer()!.customer_phone.toString()}") {
        setState(() {
          isChange = true;
        });
      } else {
        setState(() {
          isChange = false;
        });
      }
    });
    final customerProvider =
        Provider.of<CustomerViewModel>(context, listen: true);

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Stack(children: [
          Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromRGBO(232, 234, 241, 1),
                                width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(
                          FontAwesomeIcons.arrowLeft,
                          size: 18,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Personal Info",
                      style: MyTextStyle.textStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              itemTextField("Full name", nameEdit),
              itemTextField("Email", emailEdit),
              itemTextField("Phone", phoneEdit),
            ],
          ),
          Positioned(
              bottom: 30,
              child: GestureDetector(
                onTap: () {
                  //
                  if (isChange == true) {
                    CustomerModel customerModel = CustomerDB.getCustomer()!;
                    customerModel.customer_name = nameEdit.text;
                    customerModel.customer_email = emailEdit.text;
                    customerModel.customer_phone = int.parse(phoneEdit.text);
                    customerProvider.updateCustomer(customerModel);
                    CherryToast.success(
                      title: const Text("Cập nhật thành công!"),
                    ).show(context);
                  }
                },
                child: Container(
                  width: context.mediaQueryWidth * 0.9,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      color: isChange == true ? Colors.blueGrey : Colors.grey,
                      borderRadius: BorderRadius.circular(40)),
                  child: Center(
                    child: Text(
                      "Done",
                      style: MyTextStyle.textStyle(
                          fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              ))
        ]),
      ),
    );
  }

  Widget itemTextField(
      String text, TextEditingController textEditingController) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          color: const Color.fromRGBO(245, 246, 249, 1),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: MyTextStyle.textStyle(fontSize: 14, color: Colors.black),
          ),
          SizedBox(
            height: 30,
            child: TextField(
              controller: textEditingController,
              style:
                  MyTextStyle.textStyle(fontSize: 16, color: Colors.blueGrey),
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          )
        ],
      ),
    );
  }
}
