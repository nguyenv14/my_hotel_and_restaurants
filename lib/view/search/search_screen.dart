import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/configs/routes/routes_name.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/data/response/app_url.dart';
import 'package:my_hotel_and_restaurants/data/response/status.dart';
import 'package:my_hotel_and_restaurants/main.dart';
import 'package:my_hotel_and_restaurants/model/hotel_model.dart';
import 'package:my_hotel_and_restaurants/utils/app_functions.dart';
import 'package:my_hotel_and_restaurants/view_model/area_view_model.dart';
import 'package:my_hotel_and_restaurants/view_model/brand_view_model.dart';
import 'package:my_hotel_and_restaurants/view_model/favourite_view_model.dart';
import 'package:my_hotel_and_restaurants/view_model/hotel_view_model.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController textAreaController = TextEditingController();
  TextEditingController textCategory = TextEditingController();
  TextEditingController textFilter = TextEditingController();
  TextEditingController textMain = TextEditingController();
  late HotelViewModel hotelView;
  int categoryIndex = 0;
  int brandIndex = 0;
  int locationIndex = 0;
  @override
  Widget build(BuildContext context) {
    final favouriteViewModel =
        Provider.of<FavouriteViewModel>(context, listen: true);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: ColorData.backGroundColorTextField,
      appBar: AppBar(
        backgroundColor: ColorData.backGroundColorTextField,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(FontAwesomeIcons.chevronLeft),
            Container(
              width: context.mediaQueryWidth * 0.8,
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border:
                      Border.all(color: ColorData.borderColorMain, width: 1)),
              child: TextField(
                onChanged: (value) {
                  print(value);
                  hotelView.searchHotel(
                      locationIndex, brandIndex, categoryIndex, textMain.text);
                },
                controller: textMain,
                decoration: InputDecoration(
                    hintText: "Explore something",
                    hintStyle:
                        MyTextStyle.textStyle(fontSize: 16, color: Colors.grey),
                    border: InputBorder.none,
                    prefixIcon: Icon(FontAwesomeIcons.search),
                    suffixIcon: Icon(FontAwesomeIcons.microphone)),
              ),
            ),
          ],
        ),
      ),
      body: Consumer<HotelViewModel>(builder: (context, hotelViewModel, child) {
        hotelView = hotelViewModel;
        return Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              width: context.mediaQueryWidth,
              height: 60,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    width: 170,
                    child: CustomDropdown(
                        onChanged: (p0) {
                          if (p0 == "Tất cả") {
                            categoryIndex = 0;
                          } else if (p0 == "Khách sạn") {
                            categoryIndex = 1;
                          } else if (p0 == "Khách sạn căn hộ") {
                            categoryIndex = 2;
                          } else {
                            categoryIndex = 3;
                          }

                          hotelViewModel.searchHotel(locationIndex, brandIndex,
                              categoryIndex, textMain.text);
                        },
                        hintText: "Category",
                        items: [
                          "Tất cả",
                          "Khách sạn",
                          "Khách sạn căn hộ",
                          "Khu nghỉ dưỡng"
                        ],
                        controller: textCategory),
                  ),
                  ChangeNotifierProvider<BrandViewModel>(
                    create: (context) =>
                        BrandViewModel(brandRepository: getIt())
                          ..fetchBrandList(),
                    child: Consumer<BrandViewModel>(
                      builder: (context, value, child) {
                        if (value.brandListResponse.status ==
                            Status.completed) {
                          List<String> map = value.brandListResponse.data!
                              .map((e) => e.brandName)
                              .toList();
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            width: 170,
                            child: CustomDropdown(
                                onChanged: (p0) {
                                  if (p0.compareTo("Tất cả") == 0) {
                                    brandIndex = 0;
                                  } else {
                                    brandIndex = value.brandListResponse.data!
                                        .singleWhere((element) =>
                                            element.brandName == p0)
                                        .brandId;
                                  }
                                  hotelViewModel.searchHotel(locationIndex,
                                      brandIndex, categoryIndex, textMain.text);
                                },
                                hintText: "Brand",
                                items: ["Tất cả", ...map],
                                controller: textFilter),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                  ChangeNotifierProvider<AreaViewModel>(
                    create: (context) =>
                        AreaViewModel(areaRepository: getIt())..fetchAreaList(),
                    child: Consumer<AreaViewModel>(
                      builder: (context, value, child) {
                        if (value.areaListResponse.status == Status.completed) {
                          List<String> map = value.areaListResponse.data!
                              .map((e) => e.areaName)
                              .toList();
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            width: 170,
                            child: CustomDropdown(
                                onChanged: (p0) {
                                  if (p0.compareTo("Tất cả") == 0) {
                                    locationIndex = 0;
                                  } else {
                                    locationIndex = value.areaListResponse.data!
                                        .singleWhere(
                                            (element) => element.areaName == p0)
                                        .areaId;
                                  }
                                  hotelViewModel.searchHotel(locationIndex,
                                      brandIndex, categoryIndex, textMain.text);
                                },
                                hintText: "Location",
                                items: ["Tất cả", ...map],
                                controller: textAreaController),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            hotelViewModel.hotelListSearchResponse.status == Status.completed
                ? Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          hotelViewModel.hotelListSearchResponse.data!.length,
                      itemBuilder: (context, index) {
                        return WidgetHotelByArea(
                            hotelViewModel.hotelListSearchResponse.data![index],
                            context,
                            favouriteViewModel);
                      },
                    ),
                  )
                : hotelViewModel.hotelListSearchResponse.status ==
                        Status.loading
                    ? Container(
                        child: Center(
                          child: Lottie.asset("assets/raw/waiting_1.json"),
                        ),
                      )
                    : Container(
                        child: Column(
                          children: [
                            Center(
                              child: Lottie.asset("assets/raw/empty.json"),
                            ),
                            Text("Không có khách sạn đó!")
                          ],
                        ),
                      ),
          ],
        );
      }),
    );
  }

  Widget WidgetHotelByArea(HotelModel hotelModel, BuildContext context,
      FavouriteViewModel favouriteViewModel) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 20.0, top: 10, right: 20, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border.all(color: Color.fromRGBO(232, 234, 241, 1), width: 1),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RoutesName.detailHotel,
                    arguments: hotelModel.hotelId);
              },
              child: Stack(
                children: <Widget>[
                  Container(
                    width: context.mediaQueryWidth * 0.35,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(
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
                    left: 10,
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
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
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
                    height: 10,
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
                        hotelModel.areaModel.areaName,
                        style: MyTextStyle.textStyle(
                            fontSize: 13, color: Colors.black.withOpacity(0.5)),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    width: context.mediaQueryWidth * 0.43,
                    height: 1,
                    margin: const EdgeInsets.symmetric(horizontal: 7),
                    color: Colors.black.withOpacity(0.1),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: context.mediaQueryWidth * 0.31,
                        child: Column(
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
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (favouriteViewModel
                                  .checkFavouriteId(hotelModel.hotelId) ==
                              true) {
                            favouriteViewModel
                                .deleteFavouriteId(hotelModel.hotelId);
                            CherryToast.success(
                              title: Text("Đã xóa ra khỏi mục yêu thích!"),
                            ).show(context);
                          } else {
                            favouriteViewModel
                                .addFavouriteId(hotelModel.hotelId);
                            CherryToast.success(
                              title: Text("Đã thêm vào mục yêu thích!"),
                            ).show(context);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.pink.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10)),
                          child: favouriteViewModel
                                      .checkFavouriteId(hotelModel.hotelId) ==
                                  false
                              ? Icon(
                                  FontAwesomeIcons.heart,
                                  color: Colors.pinkAccent,
                                  size: 17,
                                )
                              : Icon(
                                  FontAwesomeIcons.solidHeart,
                                  color: Colors.pinkAccent,
                                  size: 17,
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
