import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/configs/routes/routes_name.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/data/response/app_url.dart';
import 'package:my_hotel_and_restaurants/data/response/status.dart';
import 'package:my_hotel_and_restaurants/main.dart';
import 'package:my_hotel_and_restaurants/model/banner_model.dart';
import 'package:my_hotel_and_restaurants/model/hotel_model.dart';
import 'package:my_hotel_and_restaurants/utils/app_functions.dart';
import 'package:my_hotel_and_restaurants/view_model/area_view_model.dart';
import 'package:my_hotel_and_restaurants/view_model/banner_view_model.dart';
import 'package:my_hotel_and_restaurants/view_model/customer_view_model.dart';
import 'package:my_hotel_and_restaurants/view_model/favourite_view_model.dart';
import 'package:my_hotel_and_restaurants/view_model/hotel_view_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> listHotelType = [
    "Khách sạn",
    "Khách sạn căn hộ",
    "Khu nghỉ dưỡng"
  ];
  int indexHotelType = 0;
  int areaIndex = 0;
  int areaId = 3;
  // List<AreaModel> areaList = AreaViewModel(areaRepository: getIt())..fetchAreaList();
  late HotelViewModel hotelViewModelByType;
  late HotelViewModel hotelViewModelByArea;
  late AreaViewModel areaViewModel;
  String? _currentAddress;
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error.')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Error.')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error.')));
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final favouriteViewModel =
        Provider.of<FavouriteViewModel>(context, listen: true);
    final customerProvider =
        Provider.of<CustomerViewModel>(context, listen: true);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 246, 249, 1),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            children: [
              SizedBox(
                height: context.mediaQueryHeight * 0.09,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentAddress ?? "",
                          style: MyTextStyle.textStyle(
                              fontSize: 15, color: Colors.grey),
                        ),
                        Text(
                            "adasđ${customerProvider.customerModel.customer_name!}",
                            style: MyTextStyle.textStyle(
                                fontSize: 18, color: Colors.blueGrey))
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.blueGrey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(blurRadius: 100, offset: Offset(1, 1))
                          ]),
                      child: const Icon(
                        FontAwesomeIcons.solidEnvelope,
                        color: Colors.blueGrey,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: Colors.blueGrey.withOpacity(0.4), width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "Explore Something Fun á đù",
                      hintStyle: MyTextStyle.textStyle(
                          fontSize: 15, color: Colors.grey),
                      border: InputBorder.none,
                      prefixIcon: const Icon(
                        FontAwesomeIcons.search,
                        color: Colors.blueGrey,
                      ),
                      suffixIcon: Container(
                        // width: 20,
                        decoration: BoxDecoration(
                            color: Colors.blueGrey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 1,
                                color: Colors.blueGrey.withOpacity(0.3))),
                        child: const Icon(
                          FontAwesomeIcons.toolbox,
                          size: 20,
                        ),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Loại khách sạn",
                      style: MyTextStyle.textStyle(fontSize: 15),
                    ),
                    InkWell(
                      child: Row(
                        children: [
                          Text(
                            "See all",
                            style: MyTextStyle.textStyle(fontSize: 15),
                          ),
                          const Icon(
                            FontAwesomeIcons.angleRight,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: context.mediaQueryWidth,
                height: context.mediaQueryWidth * 0.13,
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: listHotelType.length,
                  itemBuilder: (context, index) {
                    return hotelTypeButton(
                        index, listHotelType[index], hotelViewModelByType);
                  },
                ),
              ),
              ChangeNotifierProvider<HotelViewModel>(
                create: (context) => HotelViewModel(hotelRepository: getIt())
                  ..fetchHotelListByType(),
                child: Consumer<HotelViewModel>(
                  builder: (context, value, child) {
                    hotelViewModelByType = value;
                    switch (value.hotelListByTypeResponse.status) {
                      case Status.loading:
                        return SizedBox(
                          height: context.mediaQueryHeight * 0.3,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.blueGrey,
                            ),
                          ),
                        );
                      case Status.error:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      case Status.completed:
                        return Container(
                          width: context.mediaQueryWidth,
                          height: 270,
                          padding: const EdgeInsets.symmetric(
                            vertical: 3,
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                value.hotelListByTypeResponse.data!.length,
                            itemBuilder: (context, index) {
                              HotelModel hotelModel =
                                  value.hotelListByTypeResponse.data![index];
                              return WidgetHotelByTypeView(hotelModel, context,
                                  value, favouriteViewModel);
                            },
                          ),
                        );
                      default:
                        return Container();
                    }
                  },
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            FontAwesomeIcons.locationArrow,
                            color: Colors.amberAccent,
                            size: 24,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            "Top nearby",
                            style: MyTextStyle.textStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Location",
                                style: MyTextStyle.textStyle(
                                    fontSize: 12,
                                    color: Colors.black.withOpacity(0.4)),
                              ),
                              widgetTextForLocation(),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.blueGrey.withOpacity(0.1)),
                            child: const Icon(
                              FontAwesomeIcons.locationCrosshairs,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),

              // Container(child: ,)
              ChangeNotifierProvider<HotelViewModel>(
                create: (context) => HotelViewModel(hotelRepository: getIt())
                  ..fetchHotelListByLocation(areaId),
                child: Consumer<HotelViewModel>(
                  builder: (context, value, child) {
                    hotelViewModelByArea = value;
                    switch (value.hotelListByLocation.status) {
                      case Status.loading:
                        return SizedBox(
                          height: context.mediaQueryHeight * 0.3,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      case Status.completed:
                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            return WidgetHotelByArea(
                                value.hotelListByLocation.data![index],
                                context,
                                favouriteViewModel);
                          },
                          itemCount: value.hotelListByLocation.data!.length,
                          shrinkWrap: true,
                        );
                      default:
                        return Container();
                    }
                  },
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.newspaper,
                      color: Colors.amberAccent,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Insight for You",
                      style: MyTextStyle.textStyle(
                          fontSize: 15,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SizedBox(
                  width: context.mediaQueryWidth,
                  height: context.mediaQueryHeight * 0.35,
                  child: ChangeNotifierProvider<BannerViewModel>(
                    create: (context) =>
                        BannerViewModel(bannerRepository: getIt())
                          ..fetchBannerResponse(),
                    child: Consumer<BannerViewModel>(
                      builder: (context, value, child) {
                        switch (value.bannerListResponse.status) {
                          case Status.loading:
                            return SizedBox(
                              height: context.mediaQueryHeight * 0.2,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          case Status.error:
                            return Center(
                              child: Text(
                                  value.bannerListResponse.message!.toString()),
                            );
                          case Status.completed:
                            return SizedBox(
                              height: context.mediaQueryHeight * 0.6,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    value.bannerListResponse.data!.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return WidgetNewsForHotel(
                                      value.bannerListResponse.data![index]);
                                },
                              ),
                            );
                          default:
                            return Container();
                        }
                      },
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget hotelTypeButton(
      int index, String hotelString, HotelViewModel hotelViewModel) {
    return GestureDetector(
        onTap: () {
          setState(() {
            indexHotelType = index;
          });
          hotelViewModel.fetchHotelListByType(type: index);
        },
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: index == indexHotelType
                  ? Colors.lightBlue.withOpacity(0.4)
                  : Colors.white,
              borderRadius: BorderRadius.circular(60),
              border: Border.all(
                  color: index == indexHotelType
                      ? Colors.blueGrey.withOpacity(0.4)
                      : const Color.fromRGBO(232, 234, 241, 1),
                  width: 1),
            ),
            child: Text(
              hotelString,
              style: MyTextStyle.textStyle(
                  fontSize: 14,
                  // fontWeight: FontWeight.bold,
                  color: index == indexHotelType ? Colors.white : Colors.black),
            )));
  }

  // ignore: non_constant_identifier_names
  Widget WidgetHotelByTypeView(HotelModel hotelModel, BuildContext context,
      HotelViewModel hotelViewModel, FavouriteViewModel favouriteViewModel) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, RoutesName.detailHotel,
        //         arguments: hotelModel.hotelId)
        //     .then((value) {
        //   // print("huhuhuhu");
        //   // hotelViewModelByType.fetchHotelListByType();
        // });
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 10),
        child: GestureDetector(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                    color: const Color.fromRGBO(232, 234, 241, 1), width: 1),
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
                                  color: Colors.blueGrey,
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
                                          color: Colors.blueGrey),
                                    ),
                                    TextSpan(
                                        text: "/night",
                                        style: MyTextStyle.textStyle(
                                            fontSize: 12,
                                            color:
                                                Colors.black.withOpacity(0.3)))
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
                            child: favouriteViewModel
                                        .checkFavouriteId(hotelModel.hotelId) ==
                                    false
                                ? const Icon(
                                    FontAwesomeIcons.heart,
                                    size: 20,
                                    color: Colors.pinkAccent,
                                  )
                                : const Icon(
                                    FontAwesomeIcons.solidHeart,
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
      ),
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
            border: Border.all(
                color: const Color.fromRGBO(232, 234, 241, 1), width: 1),
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
                              color: Colors.blueGrey,
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
                      SizedBox(
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
                                        color: Colors.blueGrey),
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
                              title:
                                  const Text("Đã xóa ra khỏi mục yêu thích!"),
                            ).show(context);
                          } else {
                            favouriteViewModel
                                .addFavouriteId(hotelModel.hotelId);
                            CherryToast.success(
                              title: const Text("Đã thêm vào mục yêu thích!"),
                            ).show(context);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.pink.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10)),
                          child: favouriteViewModel
                                      .checkFavouriteId(hotelModel.hotelId) ==
                                  false
                              ? const Icon(
                                  FontAwesomeIcons.heart,
                                  color: Colors.pinkAccent,
                                  size: 17,
                                )
                              : const Icon(
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

  Widget widgetTextForLocation() {
    return GestureDetector(
        onTap: () {
          setState(() {
            areaIndex++;
            if (areaIndex > 4) {
              areaIndex = 0;
            }
          });
          hotelViewModelByArea.fetchHotelListByLocation(
              areaViewModel.areaListResponse.data![areaIndex].areaId);
        },
        child: ChangeNotifierProvider<AreaViewModel>(
          create: (context) =>
              AreaViewModel(areaRepository: getIt())..fetchAreaList(),
          child: Consumer<AreaViewModel>(
            builder: (context, value, child) {
              areaViewModel = value;
              if (value.areaListResponse.status == Status.completed) {
                areaId = value.areaListResponse.data![areaIndex].areaId;
                return Text(
                  value.areaListResponse.data![areaIndex].areaName.toString(),
                  style: MyTextStyle.textStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey),
                );
              } else {
                return const Text("Loi");
              }
            },
          ),
        ));
  }

  Widget WidgetNewsForHotel(BannerModel bannerModel) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 10),
      child: GestureDetector(
          child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: context.mediaQueryWidth * 0.6,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight:
                        Radius.circular(10)), // Bo tròn ảnh với bán kính 10
                image: DecorationImage(
                  image: NetworkImage(AppUrl.bannerImage + bannerModel.image),
                  fit: BoxFit.cover,
                ),
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
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.15)),
                        child: Text(
                          "MODERN",
                          style: MyTextStyle.textStyle(
                              fontSize: 12, color: Colors.green),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: context.mediaQueryWidth * 0.5,
                        child: Text(
                          bannerModel.title,
                          style: MyTextStyle.textStyle(
                                  fontSize: 15,
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.bold)
                              .copyWith(
                            overflow: TextOverflow.clip,
                          ),
                          softWrap: true,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        bannerModel.description,
                        style: MyTextStyle.textStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey),
                      ),
                    ])),
          ],
        ),
      )),
    );
  }
}
