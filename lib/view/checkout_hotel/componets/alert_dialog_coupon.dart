import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobkit_dashed_border/mobkit_dashed_border.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/data/response/status.dart';
import 'package:my_hotel_and_restaurants/main.dart';
import 'package:my_hotel_and_restaurants/model/coupon_model.dart';
import 'package:my_hotel_and_restaurants/view_model/coupon_view_model.dart';
import 'package:provider/provider.dart';

class AlertSelectCoupon extends StatefulWidget {
  final CouponViewModel couponViewModel;
  const AlertSelectCoupon({super.key, required this.couponViewModel});

  @override
  State<AlertSelectCoupon> createState() => _AlertSelectCouponState();
}

class _AlertSelectCouponState extends State<AlertSelectCoupon> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Color.fromRGBO(246, 248, 251, 1),
      title: Text(
        "Chọn coupon",
        style: MyTextStyle.textStyle(
            fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
      ),
      content: ChangeNotifierProvider<CouponViewModel>(
        create: (context) =>
            CouponViewModel(couponRepository: getIt())..fetchCouponList(),
        child: Container(
          width: context.mediaQueryWidth * 0.9,
          height: context.mediaQueryHeight * 0.3,
          child: Consumer<CouponViewModel>(
            builder: (context, value1, child) {
              if (value1.couponListResponse.status == Status.completed) {
                List<CouponModel> list = value1.couponListResponse.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: value1.couponListResponse.data!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        widget.couponViewModel.chooseCoupon(list[index]);
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: DashedBorder.all(
                                  dashLength: 5, color: Colors.redAccent),
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.ticket,
                                    size: 16,
                                    color: Colors.green,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        list[index].couponNameCode,
                                        style: MyTextStyle.textStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Text(
                                "Giảm " +
                                    list[index].couponPriceSale.toString() +
                                    "%",
                                style: MyTextStyle.textStyle(
                                    fontSize: 14,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
