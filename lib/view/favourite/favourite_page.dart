import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/data/response/app_url.dart';
import 'package:my_hotel_and_restaurants/data/response/status.dart';
import 'package:my_hotel_and_restaurants/main.dart';
import 'package:my_hotel_and_restaurants/model/hotel_model.dart';
import 'package:my_hotel_and_restaurants/utils/app_functions.dart';
import 'package:my_hotel_and_restaurants/view_model/favourite_view_model.dart';
import 'package:provider/provider.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  @override
  Widget build(BuildContext context) {
    final favouriteViewModel =
        Provider.of<FavouriteViewModel>(context, listen: true);
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 246, 249, 1),
      appBar: AppBar(
        // elevation: 10,
        // backgroundColor: Colors.white,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Favourite",
                style: MyTextStyle.textStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey),
              ),
              Container(
                decoration: BoxDecoration(
                    // border: Border.all(
                    //   width: 2,
                    //   color: Colors.blueGrey,
                    // ),
                    color: Colors.blueGrey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Icon(
                  FontAwesomeIcons.search,
                  color: Colors.blueGrey,
                  size: 15,
                  shadows: [
                    Shadow(
                      blurRadius: 2,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: Container(
          child: SingleChildScrollView(
        child: favouriteViewModel.favouriteViewModel.status == Status.completed
            ? ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: favouriteViewModel.favouriteViewModel.data!.length,
                itemBuilder: (context, index) {
                  return WidgetHotelByArea(
                      favouriteViewModel.favouriteViewModel.data![index],
                      context,
                      favouriteViewModel);
                },
              )
            : Container(
                child: Center(
                  child: Lottie.asset("assets/raw/waiting_1.json"),
                ),
              ),
      )),
    );
  }

  Widget WidgetHotelByArea(HotelModel hotelModel, BuildContext context,
      FavouriteViewModel favouriteViewModel) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 20.0, top: 10, right: 20, bottom: 10),
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border.all(color: Color.fromRGBO(232, 234, 241, 1), width: 1),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
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
                              fontSize: 13,
                              color: Colors.black.withOpacity(0.5)),
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
                              ? Icon(
                                  FontAwesomeIcons.heart,
                                  size: 20,
                                  color: Colors.pinkAccent,
                                )
                              : Icon(
                                  FontAwesomeIcons.solidHeart,
                                  size: 20,
                                  color: Colors.pinkAccent,
                                ),
                        )
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
      ),
    );
  }
}
