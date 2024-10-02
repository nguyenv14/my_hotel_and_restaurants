import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/configs/routes/routes_name.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/data/response/app_url.dart';
import 'package:my_hotel_and_restaurants/data/response/status.dart';
import 'package:my_hotel_and_restaurants/main.dart';
import 'package:my_hotel_and_restaurants/model/gallery_hotel_model.dart';
import 'package:my_hotel_and_restaurants/model/hotel_model.dart';
import 'package:my_hotel_and_restaurants/utils/app_functions.dart';
import 'package:my_hotel_and_restaurants/view/product/components/info_hotel_component.dart';
import 'package:my_hotel_and_restaurants/view/product/components/list_image_hotel.dart';
import 'package:my_hotel_and_restaurants/view/product/components/reviews_component.dart';
import 'package:my_hotel_and_restaurants/view/product/components/video_component.dart';
import 'package:my_hotel_and_restaurants/view/product/mapScreen.dart';
import 'package:my_hotel_and_restaurants/view_model/hotel_view_model.dart';
import 'package:provider/provider.dart';

class DetailProductScreen extends StatefulWidget {
  int hotel_id;
  DetailProductScreen({required this.hotel_id});

  @override
  State<DetailProductScreen> createState() => _DetailProductScreenState();
}

class _DetailProductScreenState extends State<DetailProductScreen> {
  static final LatLng _kMapCenter =
      LatLng(19.018255973653343, 72.84793849278007);

  static final CameraPosition _kInitialPosition =
      CameraPosition(target: _kMapCenter, zoom: 11.0, tilt: 0, bearing: 0);
  int indexCurrentGallery = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: ChangeNotifierProvider<HotelViewModel>(
        create: (context) => HotelViewModel(hotelRepository: getIt())
          ..fetchHotelById(widget.hotel_id),
        child: Consumer<HotelViewModel>(
          builder: (context, hotelViewModel, child) {
            switch (hotelViewModel.hotelModelDetail.status) {
              case Status.completed:
                HotelModel hotelModel = hotelViewModel.hotelModelDetail.data!;
                List<GalleryHotelModel> galleryHotelModel = hotelModel
                    .galleryHotel
                    .where((item) => item.galleryHotelType != 2)
                    .toList();
                GalleryHotelModel galleryVideo = hotelModel.galleryHotel
                    .where((element) => element.galleryHotelType == 2)
                    .first;
                List<double> listLatLong =
                    AppFunctions.searchLatAndLongMap(hotelModel.hotelLinkPlace);
                return Scaffold(
                  body: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: context.mediaQueryWidth,
                              height: context.mediaQueryHeight * 0.5,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(AppUrl.hotelGallery +
                                          AppFunctions.deleteSpaceWhite(
                                              hotelModel.hotelName) +
                                          "/" +
                                          galleryHotelModel[indexCurrentGallery]
                                              .galleryHotelImage))),
                            ),
                            Positioned(
                                top: context.mediaQueryHeight * 0.1,
                                left: 20,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context, 1);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.4),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Icon(
                                      FontAwesomeIcons.chevronLeft,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                )),
                            Positioned(
                                top: context.mediaQueryHeight * 0.1,
                                right: 20,
                                child: GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.4),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Icon(
                                      FontAwesomeIcons.shareNodes,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                )),
                            Positioned(
                              right: 5,
                              bottom: 10,
                              left: 5,
                              child: SizedBox(
                                height: 80,
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            indexCurrentGallery = index;
                                          });
                                        },
                                        child: ListImageSlider(
                                          imagePath: AppUrl.hotelGallery +
                                              AppFunctions.deleteSpaceWhite(
                                                  hotelModel.hotelName) +
                                              "/" +
                                              galleryHotelModel[index]
                                                  .galleryHotelImage,
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                          width: 12,
                                        ),
                                    itemCount: galleryHotelModel.length),
                              ),
                            ),
                          ],
                        ),
                        InfoHotelComponent(
                          hotelModel: hotelModel,
                        ),
                        VideoComponent(
                          videoPath: AppUrl.hotelGallery +
                              AppFunctions.deleteSpaceWhite(
                                  hotelModel.hotelName) +
                              "/" +
                              galleryVideo.galleryHotelImage,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            "Facility",
                            style: MyTextStyle.textStyle(
                                fontSize: 15,
                                color: ColorData.myColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: context.mediaQueryWidth,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding: EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 1)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              itemFaciliti(
                                  FontAwesomeIcons.squareParking, "Parking"),
                              itemFaciliti(FontAwesomeIcons.wifi, "Wifi"),
                              itemFaciliti(
                                  FontAwesomeIcons.personSwimming, "Pool"),
                              itemFaciliti(FontAwesomeIcons.dumbbell, "GYM"),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            "Position",
                            style: MyTextStyle.textStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: ColorData.myColor),
                          ),
                        ),
                        MapScreen(listLatLong),
                        SizedBox(
                          height: 15,
                        ),
                        ReviewComponent(hotelModel: hotelModel),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
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
                                  return Container(
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
                                  return Container(
                                    width: context.mediaQueryWidth,
                                    height: 100,
                                    child: Center(
                                      child: Lottie.asset(
                                          "assets/raw/waiting.json"),
                                    ),
                                  );
                                case Status.error:
                                  return Container(
                                    child: Center(
                                      child: Text("Lỗi!"),
                                    ),
                                  );
                                default:
                                  return Container();
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 90,
                        ),
                      ],
                    ),
                  ),
                  extendBody: true,
                  bottomNavigationBar: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                        color: ColorData.myColor,
                        borderRadius: BorderRadius.circular(20)),
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppFunctions.calculatePrice(
                                  hotelModel.rooms.first.roomTypes.first) +
                              "đ/night",
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
                              padding: EdgeInsets.symmetric(
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
      padding: EdgeInsets.symmetric(
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
          SizedBox(
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
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
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
                        image: NetworkImage(
                            AppUrl.hotelImage + hotelModel.hotelImage),
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
                          child: Icon(
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
