import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/data/response/status.dart';
import 'package:my_hotel_and_restaurants/main.dart';
import 'package:my_hotel_and_restaurants/model/date_model.dart';
import 'package:my_hotel_and_restaurants/model/menu_restaurant_model.dart';
import 'package:my_hotel_and_restaurants/utils/app_functions.dart';
import 'package:my_hotel_and_restaurants/view/components/button_leading_component.dart';
import 'package:my_hotel_and_restaurants/view/components/list_image_component.dart';
import 'package:my_hotel_and_restaurants/view/components/restaurant_info_component.dart';
import 'package:my_hotel_and_restaurants/view/product/mapScreen.dart';
import 'package:my_hotel_and_restaurants/view_model/restaurant_view_model.dart';
import 'package:provider/provider.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final restaurantId;
  const RestaurantDetailScreen({super.key, this.restaurantId});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  var textController = BoardDateTimeTextController();
  int countQuantity = 0;
  var quantityController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
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
                        SizedBox(
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
                              SizedBox(
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
                                    padding: EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: ColorData.greyBorderColor)),
                                    child: Column(
                                      children: [
                                        MapScreen(listLatLong),
                                        SizedBox(
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
                                  SizedBox(
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
                      int quantity = 0;
                      showModalBottomSheet(
                        context: context,
                        elevation: 10,
                        builder: (context) {
                          return StatefulBuilder(
                              builder: (context, setModalState) {
                            return Container(
                              height: context.mediaQueryHeight * 0.4,
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
                                          "👨‍👨‍👦‍👦 Quantity",
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
                                              0.4,
                                          child: BoardDateTimeInputField(
                                            initialDate: MyDate.getNow(),
                                            controller: textController,
                                            pickerType:
                                                DateTimePickerType.datetime,
                                            options: const BoardDateTimeOptions(
                                              languages:
                                                  BoardPickerLanguages.en(),
                                            ),
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                            onChanged: (date) {},
                                            onFocusChange: (val, date, text) {},
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.5,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setModalState(() {
                                                    if (quantity > 0)
                                                      quantity--;
                                                  });
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20,
                                                      vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: ColorData.myColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
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
                                                style: MyTextStyle.textStyle(
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
                                                    color: ColorData.myColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
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
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        print(quantity);
                                        print(textController.selectedDate);
                                        print(restaurantViewModel
                                            .restaurantDetail
                                            .data!
                                            .restaurantId);
                                      },
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          decoration: BoxDecoration(
                                              color: ColorData.myColor,
                                              borderRadius:
                                                  BorderRadius.circular(40)),
                                          height: 50,
                                          child: Center(
                                              child: Text(
                                            "Countinue",
                                            style: MyTextStyle.textStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ))),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
}

Widget WidgetMenuRestaurant(MenuModel menuModel) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10),
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
