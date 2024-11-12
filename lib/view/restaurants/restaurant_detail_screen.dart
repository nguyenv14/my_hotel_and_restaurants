import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/configs/routes/routes_name.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/data/response/status.dart';
import 'package:my_hotel_and_restaurants/main.dart';
import 'package:my_hotel_and_restaurants/model/date_model.dart';
import 'package:my_hotel_and_restaurants/model/menu_restaurant_model.dart';
import 'package:my_hotel_and_restaurants/utils/app_functions.dart';
import 'package:my_hotel_and_restaurants/view/components/button_leading_component.dart';
import 'package:my_hotel_and_restaurants/view/components/list_image_restaurant_component.dart';
import 'package:my_hotel_and_restaurants/view/components/restaurant_info_component.dart';
import 'package:my_hotel_and_restaurants/view/product/mapScreen.dart';
import 'package:my_hotel_and_restaurants/view_model/restaurant_view_model.dart';
import 'package:provider/provider.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final restaurantId;
  const RestaurantDetailScreen({super.key, this.restaurantId});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  var textController = BoardDateTimeTextController();
  int countQuantity = 1;
  var quantityController = TextEditingController();
  @override
  void initState() {
    quantityController.text = countQuantity.toString();
    textController.setText(MyDate.getNow().toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<RestaurantViewModel>(
        create: (context) => RestaurantViewModel(restaurantRepository: getIt())
          ..fetchRestaurantDetailByID(widget.restaurantId),
        child: Consumer<RestaurantViewModel>(
          builder: (context, restaurantViewModel, child) {
            switch (restaurantViewModel.restaurantDetail.status) {
              case Status.loading:
                return Container(
                  color: Colors.white,
                  child: Center(
                    child: Lottie.asset("assets/raw/waiting.json",
                        width: context.mediaQueryWidth, fit: BoxFit.cover),
                  ),
                );
              case Status.error:
                return Center(
                  child: Text(
                      restaurantViewModel.restaurantDetail.message.toString()),
                );
              case Status.completed:
                List<double> listLatLong = AppFunctions.searchLatAndLongMap(
                    restaurantViewModel
                        .restaurantDetail.data!.restaurantLinkPlace);
                List<MenuModel> menus =
                    restaurantViewModel.restaurantDetail.data!.menuList;
                return Scaffold(
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
                          "Restaurant Detail",
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
                  body: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListImageComponent(
                          restaurantModel:
                              restaurantViewModel.restaurantDetail.data!,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 17),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RestaurantInfoComponent(
                                restaurantModel:
                                    restaurantViewModel.restaurantDetail.data!,
                                isRestaurant: true,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Location',
                                    style: MyTextStyle.textStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: ColorData.myColor),
                                  ),
                                  const SizedBox(height: 5),
                                  Container(
                                    width: context.mediaQueryWidth,
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: ColorData.greyBorderColor)),
                                    child: Column(
                                      children: [
                                        MapScreen(listLatLong),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              FontAwesomeIcons.locationDot,
                                              color: ColorData.myColor,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                            SizedBox(
                                              width: 300,
                                              child: Text(
                                                restaurantViewModel
                                                    .restaurantDetail
                                                    .data!
                                                    .restaurantPlaceDetails,
                                                style: MyTextStyle.textStyle(
                                                        fontSize: 12,
                                                        color: Colors.black)
                                                    .copyWith(
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Menu of Restaurant',
                                        style: MyTextStyle.textStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: ColorData.myColor),
                                      ),
                                      Text(
                                        "See All",
                                        style: MyTextStyle.textStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: ColorData.blueColor),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  ListView.builder(
                                    itemCount: 3,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      return WidgetMenuRestaurant(menus[index]);
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  extendBody: true,
                  bottomNavigationBar: GestureDetector(
                    onTap: () {
                      DateTime day1 = DateTime.now();
                      DateTime day2 = DateTime.now();
                      int quantity = 1;
                      showModalBottomSheet(
                        context: context,
                        elevation: 10,
                        builder: (context) {
                          return StatefulBuilder(
                              builder: (context, setModalState) {
                            return Container(
                              height: context.mediaQueryHeight * 0.3,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: ColorData.backgroundColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    Text(
                                      "Welcome to your next Adventure",
                                      style: MyTextStyle.textStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: ColorData.myColor,
                                      ),
                                    ),
                                    Text(
                                      'Discover the Perfect Stay with WanderStay',
                                      style: MyTextStyle.textStyle(
                                        fontSize: 14,
                                        color: ColorData.greyTextColor,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "🗓 Check in",
                                          style: MyTextStyle.textStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "👨‍👨‍👦‍👦 Time",
                                          style: MyTextStyle.textStyle(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: TimePickerSpinnerPopUp(
                                            mode: CupertinoDatePickerMode.date,
                                            initTime: DateTime.now(),
                                            maxTime: DateTime.now()
                                                .add(const Duration(days: 3)),
                                            onChange: (date) {
                                              setState(() {
                                                day1 = date;
                                              });
                                            },
                                          ),
                                        ),
                                        TimePickerSpinnerPopUp(
                                          mode: CupertinoDatePickerMode.time,
                                          minuteInterval: 15,
                                          minTime: AppFunctions.minTime(),
                                          maxTime: AppFunctions.maxTime(),
                                          initTime:
                                              AppFunctions.roundToNearest15(
                                                  DateTime.now()),
                                          onChange: (time) {
                                            setState(() {
                                              day2 = time;
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "👨‍👨‍👦 Quantity",
                                              style: MyTextStyle.textStyle(
                                                fontSize: 16,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            SizedBox(
                                              width:
                                                  context.mediaQueryWidth * 0.4,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setModalState(() {
                                                        if (quantity > 1)
                                                          quantity--;
                                                      });
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20,
                                                          vertical: 6),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            ColorData.myColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: const Text(
                                                        "-",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    quantity.toString(),
                                                    style:
                                                        MyTextStyle.textStyle(
                                                            fontSize: 15),
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setModalState(() {
                                                        quantity++;
                                                      });
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20,
                                                          vertical: 6),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            ColorData.myColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: const Text(
                                                        "+",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          width: context.mediaQueryWidth * 0.5,
                                          child: GestureDetector(
                                            onTap: () {
                                              if (validateTimeOrder(
                                                  AppFunctions
                                                      .getDayOrderRestaurant(
                                                          day1, day2),
                                                  countQuantity)) {
                                                Map<String, dynamic> list = {
                                                  "restaurant":
                                                      restaurantViewModel
                                                          .restaurantDetail
                                                          .data,
                                                  "menus": restaurantViewModel
                                                      .restaurantDetail
                                                      .data!
                                                      .menuList,
                                                  "date": AppFunctions
                                                      .getDayOrderRestaurant(
                                                          day1, day2),
                                                  "person": quantity
                                                };
                                                Navigator.pushNamed(context,
                                                    RoutesName.orderRestaurant,
                                                    arguments: list);
                                              }
                                            },
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 10),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 10),
                                                decoration: BoxDecoration(
                                                    color: ColorData.myColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40)),
                                                height: 50,
                                                child: Center(
                                                    child: Text(
                                                  "Countinue",
                                                  style: MyTextStyle.textStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ))),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                        },
                      );
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            color: ColorData.myColor,
                            borderRadius: BorderRadius.circular(40)),
                        height: 50,
                        child: Center(
                            child: Text(
                          "Booking Now",
                          style: MyTextStyle.textStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ))),
                  ),
                );
              default:
                return Center(
                  child: Lottie.asset("assets/raw/waiting.json",
                      width: context.mediaQueryWidth, fit: BoxFit.cover),
                );
            }
          },
        ),
      ),
    );
  }

  bool validateTimeOrder(DateTime date, int countQuantity) {
    if (date.isBefore(DateTime.now().add(const Duration(hours: 5)))) {
      CherryToast.error(title: const Text("Vui lòng đặt trước 5 tiếng!"))
          .show(context);
      return false;
    }
    if (date.isAfter(DateTime.now().add(const Duration(days: 3)))) {
      CherryToast.error(title: const Text("Vui lòng đặt không quá 3 ngày!"))
          .show(context);
      return false;
    }
    if (date.hour < 8 || date.hour > 20) {
      CherryToast.error(
              title: const Text("Vui lòng đặt trong khung giờ quy định!"))
          .show(context);
      return false;
    }
    if (countQuantity <= 0) {
      CherryToast.error(
              title: const Text("Vui lòng chỉ định số lượng người > 0!"))
          .show(context);
      return false;
    }
    return true;
  }
}

Widget WidgetMenuRestaurant(MenuModel menuModel) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 6),
          ),
        ],
        color: Colors.white),
    child: Row(
      children: [
        Container(
          width: 100,
          height: 80,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.hardEdge,
          child: Image(
            image: NetworkImage(menuModel.menuItemImage),
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              menuModel.menuItemName,
              style: MyTextStyle.textStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: AppFunctions.formatNumber(
                        menuModel.menuItemPrice.toDouble()),
                    style: MyTextStyle.textStyle(
                        color: ColorData.myColor,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '/món',
                    style: MyTextStyle.textStyle(
                      color: ColorData.greyTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    ),
  );
}
