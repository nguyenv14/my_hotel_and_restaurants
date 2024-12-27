import 'package:cached_network_image/cached_network_image.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/configs/routes/routes_name.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/data/response/status.dart';
import 'package:my_hotel_and_restaurants/main.dart';
import 'package:my_hotel_and_restaurants/model/coupon_model.dart';
import 'package:my_hotel_and_restaurants/model/date_model.dart';
import 'package:my_hotel_and_restaurants/model/hotel_model.dart';
import 'package:my_hotel_and_restaurants/model/order_model.dart';
import 'package:my_hotel_and_restaurants/model/room_model.dart';
import 'package:my_hotel_and_restaurants/model/type_room_model.dart';
import 'package:my_hotel_and_restaurants/repository/stripe_service.dart';
import 'package:my_hotel_and_restaurants/utils/app_functions.dart';
import 'package:my_hotel_and_restaurants/utils/user_db.dart';
import 'package:my_hotel_and_restaurants/view/checkout_hotel/components/alert_dialog_coupon.dart';
import 'package:my_hotel_and_restaurants/view/components/button_leading_component.dart';
import 'package:my_hotel_and_restaurants/view_model/coupon_view_model.dart';
import 'package:my_hotel_and_restaurants/view_model/order_view_model.dart';
import 'package:provider/provider.dart';

import '../product/components/line_component.dart';

class CheckoutPage extends StatefulWidget {
  final HotelModel hotelModel;
  final RoomModel roomModel;
  final RoomTypeModel roomTypeModel;
  const CheckoutPage(
      {super.key,
      required this.hotelModel,
      required this.roomModel,
      required this.roomTypeModel});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  TextEditingController nameEditingController =
      TextEditingController(text: CustomerDB.getCustomer()!.customer_name!);
  TextEditingController emailEditingController =
      TextEditingController(text: CustomerDB.getCustomer()!.customer_email!);
  TextEditingController phoneEdittingController = TextEditingController(
      text: "0${CustomerDB.getCustomer()!.customer_phone}");
  TextEditingController requestSpecial = TextEditingController();
  bool valuefirst = false;
  bool valuesecond = false;
  DateTime now = MyDate.getNow();
  DateTime dayAfterTomorrow = MyDate.getDayAfterTomorrow();
  DateTimeRange dataTimeRange =
      DateTimeRange(start: MyDate.getNow(), end: MyDate.getDayAfterTomorrow());
  double price = 0;
  double feeService = 0;
  double priceCouponSale = 0;
  double priceTotal = 0;
  var _result;
  int currentStep = 0;
  OrderViewModel orderViewModel = OrderViewModel(orderRepository: getIt());
  CouponModel couponModel = CouponModel.empty();

  continueStep() {
    if (currentStep < 1) {
      setState(() {
        currentStep = currentStep + 1; //currentStep+=1;
      });
    }
  }

  cancelStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep = currentStep - 1; //currentStep-=1;
      });
    }
  }

  onStepTapped(int value) {
    setState(() {
      currentStep = value;
    });
  }

  Widget controlBuilders(BuildContext context, details) {
    return currentStep == 0
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "Sub total",
                    style: MyTextStyle.textStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    "${AppFunctions.calculatePrice(widget.roomTypeModel)}đ",
                    style: MyTextStyle.textStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorData.myColor),
                  ),
                ],
              ),
              GestureDetector(
                onTap: details.onStepContinue,
                child: Container(
                  width: context.mediaQueryWidth * 0.4,
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorData.myColor),
                  // color: Colors.amber,
                  child: Center(
                    child: Text(
                      "Booking",
                      style: MyTextStyle.textStyle(
                          fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: details.onStepCancel,
                child: Container(
                  width: context.mediaQueryWidth * 0.4,
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // color: Colors.redAccent,
                      border: Border.all(color: Colors.redAccent, width: 2)),
                  // color: Colors.amber,
                  child: Center(
                    child: Text(
                      "Cancel",
                      style: MyTextStyle.textStyle(
                          fontSize: 16,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (_result == 4) {
                    orderViewModel
                        .checkOut(
                            CustomerDB.getCustomer()!.customer_id!,
                            widget.roomTypeModel.typeRoomId,
                            AppFunctions.formatDate(dataTimeRange.start),
                            AppFunctions.formatDate(dataTimeRange.end),
                            AppFunctions.generateOrderCode(),
                            requestSpecial.text != ""
                                ? requestSpecial.text
                                : "Không có",
                            valuefirst == 1
                                ? 1
                                : valuesecond == 2
                                    ? 2
                                    : 0,
                            couponModel.couponId,
                            dataTimeRange.duration.inDays)
                        .onError(
                      (error, stackTrace) {
                        CherryToast.error(
                                title:
                                    const Text("Thanh toán không thành công!"))
                            .show(context);
                      },
                    );
                  } else if (_result == 1) {
                    StripeService.instance
                        .makePayment(priceTotal)
                        .then((value) {
                      // Payment successful, proceed with checkout
                      print(value);
                      if (value == true) {
                        orderViewModel.checkOut(
                          CustomerDB.getCustomer()!.customer_id!,
                          widget.roomTypeModel.typeRoomId,
                          AppFunctions.formatDate(dataTimeRange.start),
                          AppFunctions.formatDate(dataTimeRange.end),
                          AppFunctions.generateOrderCode(),
                          requestSpecial.text != ""
                              ? requestSpecial.text
                              : "Không có",
                          valuefirst == 1
                              ? 1
                              : valuesecond == 2
                                  ? 2
                                  : 0,
                          couponModel.couponId,
                          dataTimeRange.duration.inDays,
                        );
                      } else {
                        CherryToast.error(
                                title: const Text(
                                    "Thanh toán online đang gặp lỗi!"))
                            .show(context);
                      }
                    }).catchError((error) {
                      CherryToast.error(
                              title:
                                  const Text("Thanh toán online đang gặp lỗi!"))
                          .show(context);
                    });
                  }
                },
                child: Container(
                  width: context.mediaQueryWidth * 0.4,
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorData.myColor,
                  ),
                  // color: Colors.amber,
                  child: Center(
                    child: Text(
                      "Payment",
                      style: MyTextStyle.textStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(dayAfterTomorrow);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final start = dataTimeRange.start;
    final end = dataTimeRange.end;
    final differenceDay = dataTimeRange.duration;
    price = AppFunctions.calculatePriceRoom(widget.roomTypeModel) *
        differenceDay.inDays;
    if (widget.hotelModel.serviceChanges != null) {
      feeService = AppFunctions.calculatePriceForService(
          price, widget.hotelModel.serviceChanges!);
    } else {
      feeService = 0;
    }

    return Consumer<OrderViewModel>(
      builder: (context, value, child) {
        orderViewModel = value;
        if (value.orderModelResponse.status == Status.completed) {
          OrderModel order = orderViewModel.orderModelResponse.data!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushNamed(context, RoutesName.receiptPage, arguments: {
              "orderModel": order,
              "days": dataTimeRange.duration.inDays
            });
          });
          value.orderModelResponse.status = Status.loading;
          value.isCheckOut = false;
        }
        return orderViewModel.isCheckOut == true
            ? Scaffold(
                body: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset("assets/raw/waiting.json"),
                      Center(
                        child: Text(
                          "Vui lòng chờ đơn đặt đang được xử lý!",
                          style: MyTextStyle.textStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Scaffold(
                backgroundColor: ColorData.backgroundColor,
                appBar: AppBar(
                  backgroundColor: ColorData.backgroundColor,
                  shadowColor: ColorData.backgroundColor,
                  surfaceTintColor: ColorData.backgroundColor,
                  scrolledUnderElevation: 0,
                  automaticallyImplyLeading: false,
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const ButtonLeadingComponent(
                        iconData: Icons.arrow_back_ios_new_rounded,
                      ),
                      Text(
                        "Booking room",
                        style: MyTextStyle.textStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      ButtonLeadingComponent(
                        iconData: Icons.menu,
                        onPress: () {},
                      )
                    ],
                  ),
                ),
                body: Stepper(
                  elevation: 3, //Horizontal Impact
                  // margin: const EdgeInsets.all(20), //vertical impact
                  connectorColor: WidgetStateProperty.resolveWith((states) {
                    return ColorData.myColor;
                  }),

                  controlsBuilder: controlBuilders,
                  type: StepperType.horizontal,
                  physics: const ScrollPhysics(),
                  // onStepTapped: onStepTapped,
                  onStepContinue: continueStep,
                  onStepCancel: cancelStep,
                  margin: EdgeInsets.zero,
                  currentStep: currentStep, //0, 1, 2
                  steps: [
                    Step(
                        title: Container(),
                        label: Text(
                          "Booking",
                          style: MyTextStyle.textStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Booking Details",
                              style: MyTextStyle.textStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.grey, width: 0.5)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Row(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl:
                                              widget.hotelModel.hotelImage,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width:
                                                context.mediaQueryWidth * 0.26,
                                            height:
                                                context.mediaQueryHeight * 0.10,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          height:
                                              context.mediaQueryHeight * 0.12,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.hotelModel.hotelName,
                                                style: MyTextStyle.textStyle(
                                                    fontSize: 14,
                                                    color: Colors.blueGrey,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                width: context.mediaQueryWidth *
                                                    0.5,
                                                child: Text(
                                                  widget.roomModel.roomName,
                                                  style: MyTextStyle.textStyle(
                                                      fontSize: 12,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      itemOptionOrderHotel(
                                                          FontAwesomeIcons
                                                              .addressBook,
                                                          "${widget.roomModel.roomAmountOfPeople} guest"),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      itemOptionOrderHotel(
                                                          FontAwesomeIcons.bed,
                                                          widget.roomTypeModel
                                                                      .typeRoomBed ==
                                                                  1
                                                              ? "Giường đơn"
                                                              : widget.roomTypeModel
                                                                          .typeRoomBed ==
                                                                      2
                                                                  ? "Giường đôi"
                                                                  : "Đơn hoặc đôi")
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: context
                                                            .mediaQueryWidth *
                                                        0.05,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      itemOptionOrderHotel(
                                                          FontAwesomeIcons
                                                              .layerGroup,
                                                          "${widget.roomModel.roomAcreage}m2"),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      itemOptionOrderHotel(
                                                          FontAwesomeIcons.eye,
                                                          widget.roomModel
                                                              .roomView)
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    // width: ,
                                    height: 0.5,
                                    color: Colors.grey.shade400,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Check in",
                                              style: MyTextStyle.textStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey),
                                            ),
                                            GestureDetector(
                                              onTap: pickDateRange,
                                              child: Text(
                                                "${start.day}/${start.month}/${start.year}",
                                                style: MyTextStyle.textStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                  color: Colors.grey,
                                                  width: 0.5)),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                FontAwesomeIcons.solidMoon,
                                                color: Colors.blueAccent,
                                              ),
                                              Text(
                                                differenceDay.inDays.toString(),
                                                style: MyTextStyle.textStyle(
                                                    fontSize: 16,
                                                    color: Colors.blueAccent,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "Check out",
                                              style: MyTextStyle.textStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey),
                                            ),
                                            Text(
                                              "${end.day}/${end.month}/${end.year}",
                                              style: MyTextStyle.textStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              "Contact Details",
                              style: MyTextStyle.textStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 35,
                                    child: TextField(
                                      controller: nameEditingController,
                                      decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.zero,
                                          border: InputBorder.none,
                                          prefixIcon: Icon(
                                            FontAwesomeIcons.solidUser,
                                            size: 12,
                                            color: Colors.amber,
                                          )),
                                      style: MyTextStyle.textStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 35,
                                    child: TextField(
                                      controller: emailEditingController,
                                      decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.zero,
                                          border: InputBorder.none,
                                          prefixIcon: Icon(
                                            FontAwesomeIcons.solidEnvelope,
                                            size: 12,
                                            color: Colors.amber,
                                          )),
                                      style: MyTextStyle.textStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 35,
                                    child: TextField(
                                      controller: phoneEdittingController,
                                      decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.zero,
                                          border: InputBorder.none,
                                          prefixIcon: Icon(
                                            FontAwesomeIcons.phone,
                                            size: 12,
                                            color: Colors.amber,
                                          )),
                                      style: MyTextStyle.textStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Requests",
                              style: MyTextStyle.textStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 0.5),
                                  borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        checkColor: Colors.white,
                                        activeColor: Colors.blueGrey,
                                        value: valuefirst,
                                        onChanged: (value) {
                                          setState(() {
                                            valuefirst = value!;
                                          });
                                        },
                                      ),
                                      Text(
                                        'High floor',
                                        style: MyTextStyle.textStyle(
                                            fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                        checkColor: Colors.white,
                                        activeColor: Colors.blueGrey,
                                        value: valuesecond,
                                        onChanged: (value) {
                                          setState(() {
                                            valuesecond = value!;
                                          });
                                        },
                                      ),
                                      Text(
                                        'Smoking space',
                                        style: MyTextStyle.textStyle(
                                            fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 1,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Special requests",
                                    style: MyTextStyle.textStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent),
                                  ),
                                  SizedBox(
                                    height: 35,
                                    child: TextField(
                                      controller: requestSpecial,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.zero,
                                          border: InputBorder.none,
                                          hintText: "Yêu cầu đặc biệt",
                                          hintStyle: MyTextStyle.textStyle(
                                              fontSize: 14, color: Colors.grey),
                                          prefixIcon: const Icon(
                                            FontAwesomeIcons.tags,
                                            size: 12,
                                            color: Colors.amber,
                                          )),
                                      style: MyTextStyle.textStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            )
                          ],
                        ),
                        isActive: currentStep >= 0,
                        state: currentStep >= 0
                            ? StepState.complete
                            : StepState.disabled),
                    Step(
                      title: Container(),
                      label: Text(
                        "Payment",
                        style: MyTextStyle.textStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                      content: Consumer<CouponViewModel>(
                        builder: (context, value, child) {
                          if (value.coupon.status == Status.completed) {
                            couponModel = value.coupon.data!;
                            priceCouponSale =
                                AppFunctions.calculatePriceForSale(
                                    price, value.coupon.data!);
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Booking Details",
                                style: MyTextStyle.textStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Colors.grey, width: 0.5)),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Row(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl:
                                                widget.hotelModel.hotelImage,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              width: context.mediaQueryWidth *
                                                  0.26,
                                              height: context.mediaQueryHeight *
                                                  0.10,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            height:
                                                context.mediaQueryHeight * 0.12,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  widget.hotelModel.hotelName,
                                                  style: MyTextStyle.textStyle(
                                                      fontSize: 14,
                                                      color: Colors.blueGrey,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width:
                                                      context.mediaQueryWidth *
                                                          0.4,
                                                  child: Text(
                                                    widget.roomModel.roomName,
                                                    style:
                                                        MyTextStyle.textStyle(
                                                            fontSize: 12,
                                                            color:
                                                                Colors.black),
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        itemOptionOrderHotel(
                                                            FontAwesomeIcons
                                                                .addressBook,
                                                            "${widget.roomModel.roomAmountOfPeople} guest"),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        itemOptionOrderHotel(
                                                            FontAwesomeIcons
                                                                .bed,
                                                            widget.roomTypeModel
                                                                        .typeRoomBed ==
                                                                    1
                                                                ? "Giường đơn"
                                                                : widget.roomTypeModel
                                                                            .typeRoomBed ==
                                                                        2
                                                                    ? "Giường đôi"
                                                                    : "Đơn hoặc đôi")
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: context
                                                              .mediaQueryWidth *
                                                          0.05,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        itemOptionOrderHotel(
                                                            FontAwesomeIcons
                                                                .layerGroup,
                                                            "${widget.roomModel.roomAcreage}m2"),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        itemOptionOrderHotel(
                                                            FontAwesomeIcons
                                                                .eye,
                                                            widget.roomModel
                                                                .roomView)
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      // width: ,
                                      height: 0.5,
                                      color: Colors.grey.shade400,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Check in",
                                                style: MyTextStyle.textStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey),
                                              ),
                                              Text(
                                                "${start.day}/${start.month}/${start.year}",
                                                style: MyTextStyle.textStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 0.5)),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  FontAwesomeIcons.solidMoon,
                                                  color: Colors.blueAccent,
                                                ),
                                                Text(
                                                  differenceDay.inDays
                                                      .toString(),
                                                  style: MyTextStyle.textStyle(
                                                      fontSize: 16,
                                                      color: Colors.blueAccent,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "Check out",
                                                style: MyTextStyle.textStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey),
                                              ),
                                              Text(
                                                "${end.day}/${end.month}/${end.year}",
                                                style: MyTextStyle.textStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Coupon",
                                style: MyTextStyle.textStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              value.couponHide == false
                                  ? GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertSelectCoupon(
                                                couponViewModel: value);
                                          },
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                color: Colors.grey,
                                                width: 0.5)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(
                                                  FontAwesomeIcons
                                                      .solidClipboard,
                                                  size: 15,
                                                  color: Colors.amber,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "Thêm coupon đi nào!!!",
                                                  style: MyTextStyle.textStyle(
                                                      fontSize: 14,
                                                      color: ColorData.myColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            const Icon(
                                              FontAwesomeIcons.plus,
                                              size: 18,
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : Row(
                                      children: [
                                        Container(
                                          width: context.mediaQueryWidth * 0.77,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    FontAwesomeIcons.ticket,
                                                    size: 16,
                                                    color: Colors.green,
                                                  ),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        value.coupon.data!
                                                            .couponNameCode,
                                                        style: MyTextStyle
                                                            .textStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      ),
                                                      SizedBox(
                                                        width: context
                                                                .mediaQueryWidth *
                                                            0.4,
                                                        child: Text(
                                                          value.coupon.data!
                                                              .couponDesc,
                                                          style: MyTextStyle
                                                              .textStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Text(
                                                "Giảm ${value.coupon.data!.couponPriceSale}%",
                                                style: MyTextStyle.textStyle(
                                                    fontSize: 14,
                                                    color: Colors.redAccent,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertSelectCoupon(
                                                    couponViewModel: value);
                                              },
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 15),
                                            decoration: const BoxDecoration(
                                                color: Colors.redAccent,
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    bottomRight:
                                                        Radius.circular(10))),
                                            child: const Icon(
                                              FontAwesomeIcons.plus,
                                              size: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text("Check payment",
                                  style: MyTextStyle.textStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 0.5),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    itemPriceOrder(
                                        "1 phòng x ${differenceDay.inDays} ngày",
                                        price),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    itemPriceOrder("Phí khách sạn", feeService),
                                    const LineComponent(),
                                    itemPriceOrder(
                                        "Tổng giá phòng", price + feeService),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    value.coupon.status == Status.completed
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Mã giảm giá",
                                                    style:
                                                        MyTextStyle.textStyle(
                                                            fontSize: 12),
                                                  ),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 5,
                                                          vertical: 2),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.red)),
                                                      child: Text(
                                                        value.coupon.data!
                                                            .couponNameCode,
                                                        style: MyTextStyle
                                                            .textStyle(
                                                                fontSize: 12,
                                                                color:
                                                                    Colors.red),
                                                      )),
                                                ],
                                              ),
                                              Text(
                                                "-${AppFunctions.formatNumber(priceCouponSale)}đ",
                                                style: MyTextStyle.textStyle(
                                                    fontSize: 12,
                                                    color: Colors.green),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 0.5,
                                              color: Colors.black
                                                  .withOpacity(0.2))),
                                    ),
                                    itemPriceOrder("Tổng tiền thanh toán",
                                        price + feeService - priceCouponSale,
                                        fontWeight: FontWeight.bold),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.grey, width: 0.5),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Payment method",
                                      style: MyTextStyle.textStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    RadioListTile(
                                        activeColor: Colors.green,
                                        title: Row(
                                          children: [
                                            const Icon(
                                              FontAwesomeIcons.moneyBillWave,
                                              color: Colors.green,
                                              size: 16,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Thanh toán trực tiếp",
                                              style: MyTextStyle.textStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blueGrey),
                                            ),
                                          ],
                                        ),
                                        value: 4,
                                        groupValue: _result,
                                        onChanged: (value) {
                                          setState(() {
                                            _result = value;
                                          });
                                        }),
                                    RadioListTile(
                                        activeColor: Colors.green,
                                        title: Row(
                                          children: [
                                            const Icon(
                                              FontAwesomeIcons.creditCard,
                                              color: Colors.red,
                                              size: 16,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Thanh toán qua Stripe",
                                              style: MyTextStyle.textStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blueGrey),
                                            ),
                                          ],
                                        ),
                                        value: 1,
                                        groupValue: _result,
                                        onChanged: (value) {
                                          setState(() {
                                            _result = value;
                                          });
                                        }),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        },
                      ),
                      isActive: currentStep >= 0,
                      state: currentStep >= 1
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                  ],
                ),
              );
      },
    );
  }

  Widget itemOptionOrderHotel(
    IconData iconData,
    String text,
  ) {
    return Row(
      children: [
        Icon(
          iconData,
          size: 12,
          color: Colors.amber,
        ),
        const SizedBox(
          width: 5,
        ),
        SizedBox(
          width: context.mediaQueryWidth * 0.2,
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: MyTextStyle.textStyle(fontSize: 12, color: Colors.grey),
          ),
        )
      ],
    );
  }

  Widget itemRequestOrder(bool valueCheck, String text) {
    return Row(
      children: [
        Checkbox(
          checkColor: Colors.white,
          activeColor: Colors.blueGrey,
          value: valueCheck,
          onChanged: (value) {
            setState(() {
              valueCheck = value!;
            });
          },
        ),
        Text(
          text,
          style: MyTextStyle.textStyle(fontSize: 14.0),
        ),
      ],
    );
  }

  Widget itemPriceOrder(String text, double price,
      {FontWeight fontWeight = FontWeight.normal}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: MyTextStyle.textStyle(fontSize: 12, fontWeight: fontWeight),
        ),
        Text(
          "${AppFunctions.formatNumber(price)}đ",
          style: MyTextStyle.textStyle(fontSize: 12, fontWeight: fontWeight),
        )
      ],
    );
  }

  // Future pickDateRange() async {
  //   DateTimeRange? newDateRange = await showDateRangePicker(
  //       builder: (context, child) {
  //         return Theme(
  //           data: Theme.of(context).copyWith(
  //             colorScheme: ColorScheme.light(
  //               primary: Colors.blueGrey, // header background color
  //               onPrimary: Colors.black, // header text color
  //               onSurface: Colors.blueGrey, // body text color
  //             ),
  //             textButtonTheme: TextButtonThemeData(
  //               style: TextButton.styleFrom(
  //                 foregroundColor: Colors.red, // button text color
  //               ),
  //             ),
  //           ),
  //           child: child!,
  //         );
  //       },
  //       context: context,
  //       initialDateRange: dataTimeRange,
  //       firstDate: DateTime(1900),
  //       lastDate: DateTime(2100));
  //   if (newDateRange == null) return;
  //   setState(() {
  //     dataTimeRange = newDateRange;
  //   });
  // }

  Future pickDateRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
        context: context,
        initialDateRange: dataTimeRange,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
              primary: Colors.blueGrey, // header background color
              onPrimary: Colors.black, // header text color
              onSurface: Colors.blueGrey, // body text color
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: 300, maxHeight: 600),
                  child: child,
                ),
                const SizedBox(
                  height: 12,
                )
              ],
            ),
          );
        });
    if (newDateRange == null) return;
    setState(() {
      dataTimeRange = newDateRange;
    });
  }

  void navigateToReceiptPage(BuildContext context) {
    Navigator.pushNamed(context, RoutesName.receiptPage);
  }
}
