import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/configs/routes/routes_name.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/data/response/status.dart';
import 'package:my_hotel_and_restaurants/main.dart';
import 'package:my_hotel_and_restaurants/model/hotel_model.dart';
import 'package:my_hotel_and_restaurants/utils/app_functions.dart';
import 'package:my_hotel_and_restaurants/view/components/button_leading_component.dart';
import 'package:my_hotel_and_restaurants/view/components/list_image_hotel_component.dart';
import 'package:my_hotel_and_restaurants/view/product/components/info_hotel_component.dart';
import 'package:my_hotel_and_restaurants/view/product/components/reviews_component.dart';
import 'package:my_hotel_and_restaurants/view/product/mapScreen.dart';
import 'package:my_hotel_and_restaurants/view_model/hotel_view_model.dart';
import 'package:provider/provider.dart';

class DetailProductScreen extends StatefulWidget {
  int hotel_id;
  DetailProductScreen({super.key, required this.hotel_id});

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  // static final LatLng _kMapCenter =
  //     LatLng(19.018255973653343, 72.84793849278007);

  // static final CameraPosition _kInitialPosition =
  //     CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);
  int indexCurrentGallery = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorData.backgroundColor,
      body: ChangeNotifierProvider<HotelViewModel>(
        create: (context) => HotelViewModel(hotelRepository: getIt())
          ..fetchHotelById(widget.hotel_id),
        child: Consumer<HotelViewModel>(
          builder: (context, hotelViewModel, child) {
            switch (hotelViewModel.hotelModelDetail.status) {
              case Status.completed:
                HotelModel hotelModel = hotelViewModel.hotelModelDetail.data!;
                List<double> listLatLong =
                    AppFunctions.searchLatAndLongMap(hotelModel.hotelLinkPlace);
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
                          "Hotel Detail",
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
                        ListImageHotelComponent(
                          hotelModel: hotelModel,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InfoHotelComponent(
                                hotelModel: hotelModel,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
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
                                            hotelModel.hotelPlaceDetails,
                                            style: MyTextStyle.textStyle(
                                                    fontSize: 12,
                                                    color: Colors.black)
                                                .copyWith(
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        ReviewComponent(hotelModel: hotelModel),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Text(
                            "Theo địa điểm",
                            style: MyTextStyle.textStyle(
                                fontSize: 15,
                                color: ColorData.myColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        ChangeNotifierProvider(
                          create: (context) =>
                              HotelViewModel(hotelRepository: getIt())
                                ..fetchHotelListByLocation(
                                    hotelModel.areaModel.areaId),
                          child: Consumer<HotelViewModel>(
                            builder: (context, hotelViewModel, child) {
                              switch (
                                  hotelViewModel.hotelListByLocation.status) {
                                case Status.completed:
                                  final List<HotelModel> hotelList =
                                      hotelViewModel.hotelListByLocation.data!;
                                  return SizedBox(
                                    width: context.mediaQueryWidth,
                                    height: context.mediaQueryHeight * 0.34,
                                    child: ListView.builder(
                                      itemCount: hotelList.length,
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return WidgetHotelByTypeView(
                                            hotelList[index], context);
                                      },
                                    ),
                                  );
                                case Status.loading:
                                  return SizedBox(
                                    width: context.mediaQueryWidth,
                                    height: 100,
                                    child: Center(
                                      child: Lottie.asset(
                                          "assets/raw/waiting.json"),
                                    ),
                                  );
                                case Status.error:
                                  return const Center(
                                    child: Text("Lỗi!"),
                                  );
                                default:
                                  return Container();
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 90,
                        ),
                      ],
                    ),
                  ),
                  extendBody: true,
                  bottomNavigationBar: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: ColorData.myColor,
                        borderRadius: BorderRadius.circular(20)),
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${AppFunctions.calculatePrice(hotelModel.rooms.first.roomTypes.first)}đ/night",
                          style: MyTextStyle.textStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, RoutesName.selectRoom,
                                arguments: hotelModel);
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "Select the room",
                                style: MyTextStyle.textStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: ColorData.myColor,
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                );
              case Status.loading:
                return Center(
                  child: Lottie.asset("assets/raw/waiting.json",
                      width: context.mediaQueryWidth, fit: BoxFit.cover),
                );
              case Status.error:
                return Center(
                  child:
                      Text(hotelViewModel.hotelModelDetail.message.toString()),
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
      extendBody: true,
    );
  }

  Widget itemFaciliti(IconData iconData, String text) {
    return Container(
      width: context.mediaQueryWidth * 0.17,
      padding: const EdgeInsets.symmetric(
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: ColorData.myColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            iconData,
            color: ColorData.myColor,
          ),
          const SizedBox(
            height: 6,
          ),
          Text(
            text,
            style: MyTextStyle.textStyle(
                fontSize: 14,
                color: ColorData.myColor,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }

  Widget WidgetHotelByTypeView(HotelModel hotelModel, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RoutesName.detailHotel,
            arguments: hotelModel.hotelId);
      },
      child: GestureDetector(
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: <Widget>[
                  Container(
                    width: context.mediaQueryWidth * 0.5,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(
                              10)), // Bo tròn ảnh với bán kính 10
                      image: DecorationImage(
                        image: NetworkImage(hotelModel.hotelImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.solidStar,
                              size: 15,
                              color: Colors.amber,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(
                              "4.6",
                              style: MyTextStyle.textStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        )),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: context.mediaQueryWidth * 0.39,
                      child: Text(
                        hotelModel.hotelName,
                        style: MyTextStyle.textStyle(
                                fontSize: 15,
                                color: ColorData.textHotelMain,
                                fontWeight: FontWeight.bold)
                            .copyWith(
                          overflow: TextOverflow.ellipsis,
                        ),
                        softWrap: true,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.locationDot,
                          size: 15,
                          color: Colors.amber,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          hotelModel.areaModel.areaName.toString(),
                          style: MyTextStyle.textStyle(
                              fontSize: 13,
                              color: Colors.black.withOpacity(0.5)),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: context.mediaQueryWidth * 0.43,
                      height: 1,
                      margin: const EdgeInsets.symmetric(horizontal: 7),
                      color: Colors.black.withOpacity(0.1),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Start from",
                                style: MyTextStyle.textStyle(
                                    fontSize: 12,
                                    color: Colors.black.withOpacity(0.3))),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        "\$${AppFunctions.calculatePrice(hotelModel.rooms[0].roomTypes[0])}",
                                    style: MyTextStyle.textStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: ColorData.myColor),
                                  ),
                                  TextSpan(
                                      text: "/night",
                                      style: MyTextStyle.textStyle(
                                          fontSize: 12,
                                          color: Colors.black.withOpacity(0.3)))
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.pinkAccent.withOpacity(0.2)),
                          child: const Icon(
                            FontAwesomeIcons.heart,
                            size: 20,
                            color: Colors.pinkAccent,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
