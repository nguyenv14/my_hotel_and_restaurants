import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/configs/routes/routes_name.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/data/response/app_url.dart';
import 'package:my_hotel_and_restaurants/data/response/status.dart';
import 'package:my_hotel_and_restaurants/data/sort_hotel.dart';
import 'package:my_hotel_and_restaurants/data/sort_restaurant.dart';
import 'package:my_hotel_and_restaurants/model/hotel_model.dart';
import 'package:my_hotel_and_restaurants/utils/app_functions.dart';
import 'package:my_hotel_and_restaurants/view/components/button_leading_component.dart';
import 'package:my_hotel_and_restaurants/view/components/button_select_component.dart';
import 'package:my_hotel_and_restaurants/view/components/search_card_component.dart';
import 'package:my_hotel_and_restaurants/view/search/filter_component.dart';
import 'package:my_hotel_and_restaurants/view/search/filter_restaurant_component.dart';
import 'package:my_hotel_and_restaurants/view_model/favourite_view_model.dart';
import 'package:my_hotel_and_restaurants/view_model/search_view_model.dart';
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
  late SearchViewModel _searchViewModel;
  int categoryIndex = 0;
  int brandIndex = 0;
  int locationIndex = 0;
  int indexHotelType = 1;
  @override
  Widget build(BuildContext context) {
    final favouriteViewModel =
        Provider.of<FavouriteViewModel>(context, listen: true);
    return Scaffold(
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
            Container(
              width: context.mediaQueryWidth * 0.62,
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border:
                      Border.all(color: ColorData.borderColorMain, width: 1)),
              child: TextField(
                onChanged: (value) {
                  _searchViewModel.search(textMain.text, indexHotelType);
                },
                controller: textMain,
                decoration: InputDecoration(
                  hintText: "Explore something",
                  hintStyle:
                      MyTextStyle.textStyle(fontSize: 16, color: Colors.grey),
                  border: InputBorder.none,
                  prefixIcon: const Icon(FontAwesomeIcons.search),
                ),
              ),
            ),
            ButtonLeadingComponent(
              iconData: Icons.menu,
              onPress: () {
                indexHotelType == 1
                    ? showSearchFilter(context, indexHotelType)
                    : showRestaurantFilter(context);
              },
            )
          ],
        ),
      ),
      body: Scrollbar(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: ButtonSelectComponent(
                      index: 1,
                      hotelString: "Hotel",
                      selectedIndex: indexHotelType,
                      onTap: (index) {
                        setState(() {
                          indexHotelType = index;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: ButtonSelectComponent(
                      index: 2,
                      hotelString: "Restaurant",
                      selectedIndex: indexHotelType,
                      onTap: (index) {
                        setState(() {
                          indexHotelType = index;
                        });
                        // showRestaurantFilter(
                        //     context); // Show filter for restaurants
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Consumer<SearchViewModel>(
                builder: (context, searchViewModel, child) {
              _searchViewModel = searchViewModel;
              return Expanded(
                child: Column(
                  children: [
                    searchViewModel.searchModels.status == Status.completed
                        ? Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount:
                                  searchViewModel.searchModels.data!.length,
                              itemBuilder: (context, index) {
                                return SearchCardComponent(
                                  searchModel:
                                      searchViewModel.searchModels.data![index],
                                  onPressed: () {},
                                );
                              },
                            ),
                          )
                        : searchViewModel.searchModels.status == Status.loading
                            ? Center(
                                child:
                                    Lottie.asset("assets/raw/waiting_1.json"),
                              )
                            : Column(
                                children: [
                                  Center(
                                    child:
                                        Lottie.asset("assets/raw/empty.json"),
                                  ),
                                  const Text("Không có khách sạn đó!")
                                ],
                              ),
                  ],
                ),
              );
            }),

            // Expanded(
            //   child: ListView.builder(
            //     itemCount: 10,
            //     itemBuilder: (context, index) {
            //       return Padding(
            //         padding: const EdgeInsets.all(10.0),
            //         child: HotelCard(
            //           imageUrl:
            //               'https://muongthanh.com/images/video/original/muong-thanh-luxury-quang-ninh-1_1681902050_1688035221.jpg',
            //           hotelName: 'Hotel Name $index',
            //           location: 'Location $index',
            //           ranking: 4,
            //           price: 1200.0,
            //           onPressed: () {
            //             print('Booking Hotel $index');
            //           },
            //           onFavoritePressed: () {
            //             print('Favorited Hotel $index');
            //           },
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void showSearchFilter(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FilterComponent(
          title: "Hotel Filter",
          sortOptions: SortHotel.getAreaNames(),
          initialStarRating: 4,
          initialHotelType: "Khách sạn",
          initialMinPrice: 100,
          initialMaxPrice: 1000,
          searchViewModel: _searchViewModel,
          onApply: () {},
          showPriceRange: true, // Change to false to hide price range
          showHotelButtons: true, // Change to false to hide hotel buttons
        );
      },
    );
  }

  void showRestaurantFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FilterRestaurantComponent(
          searchViewModel: _searchViewModel,
          title: "Restaurant Filter",
          sortOptions: SortRestaurant.getAreaNames(),
          initialStarRating: 4,
          onApply: () {
            // Handle apply logic
          },
          showPriceRange: false, // Change to false to hide price range
          showHotelButtons: false, // Change to false to hide hotel buttons
        );
      },
    );
  }
}

Widget WidgetHotelByArea(HotelModel hotelModel, BuildContext context,
    FavouriteViewModel favouriteViewModel) {
  return Padding(
    padding: const EdgeInsets.only(left: 20.0, top: 10, right: 20, bottom: 10),
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
                        bottomLeft:
                            Radius.circular(10)), // Bo tròn ảnh với bán kính 10
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
                            title: const Text("Đã xóa ra khỏi mục yêu thích!"),
                          ).show(context);
                        } else {
                          favouriteViewModel.addFavouriteId(hotelModel.hotelId);
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
