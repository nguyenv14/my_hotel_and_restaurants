import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_hotel_and_restaurants/configs/color.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/configs/routes/routes_name.dart';
import 'package:my_hotel_and_restaurants/configs/text_style.dart';
import 'package:my_hotel_and_restaurants/data/response/app_url.dart';
import 'package:my_hotel_and_restaurants/data/response/status.dart';
import 'package:my_hotel_and_restaurants/main.dart';
import 'package:my_hotel_and_restaurants/model/banner_model.dart';
import 'package:my_hotel_and_restaurants/model/hotel_model.dart';
import 'package:my_hotel_and_restaurants/model/restaurant_model.dart';
import 'package:my_hotel_and_restaurants/repository/stripe_service.dart';
import 'package:my_hotel_and_restaurants/utils/app_functions.dart';
import 'package:my_hotel_and_restaurants/utils/user_db.dart';
import 'package:my_hotel_and_restaurants/view/checkout_hotel/order_restaurant/receipt_page.dart';
import 'package:my_hotel_and_restaurants/view/components/button_select_component.dart';
import 'package:my_hotel_and_restaurants/view/components/card_hotel_component.dart';
import 'package:my_hotel_and_restaurants/view/components/card_restaurant_component.dart';
import 'package:my_hotel_and_restaurants/view/components/hotel_component.dart';
import 'package:my_hotel_and_restaurants/view_model/area_view_model.dart';
import 'package:my_hotel_and_restaurants/view_model/favourite_view_model.dart';
import 'package:my_hotel_and_restaurants/view_model/hotel_view_model.dart';
import 'package:my_hotel_and_restaurants/view_model/restaurant_view_model.dart';
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
  late RestaurantViewModel restaurantViewModel;

  late AreaViewModel areaViewModel;
  String? _currentAddress;
  Position? _currentPosition;
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[4];
      setState(() {
        _currentAddress =
            '${place.subAdministrativeArea},${place.administrativeArea}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  void initState() {
    _getCurrentPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final favouriteViewModel =
        Provider.of<FavouriteViewModel>(context, listen: true);

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   customerViewModel.setCustomerModel(CustomerDB.getCustomer()!);
    // });
    return Scaffold(
      backgroundColor: ColorData.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 530,
              child: Stack(
                children: [
                  Container(
                    height: 390,
                    decoration: const BoxDecoration(
                      color: ColorData.myColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14.0, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50), // For status bar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello, ${CustomerDB.getNameCustomer()!.customer_name}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      _currentAddress ?? "",
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Card(
                                elevation: 10,
                                shape: const CircleBorder(),
                                child: IconButton(
                                  icon: const Icon(Icons.notifications_none),
                                  color: ColorData.myColor,
                                  iconSize: 30,
                                  onPressed: () {
                                    // print("aaaa");
                                    StripeService.instance.makePayment(1000);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, RoutesName.searchPage);
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 5),
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.search),
                                  color: Colors.grey,
                                  iconSize: 30,
                                  onPressed: () {},
                                ),
                                const Text(
                                  "Search your hotel...",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Popular Hotel Title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Popular Hotel 🔥",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ReceiptRestaurantPage(),
                                    ));
                              },
                              child: const Text(
                                'See All',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 250,
                    left: 0,
                    right: 0,
                    child: ChangeNotifierProvider<HotelViewModel>(
                      create: (context) =>
                          HotelViewModel(hotelRepository: getIt())
                            ..fetchHotelListRecomendation(),
                      child: Consumer<HotelViewModel>(
                        builder: (context, value, child) {
                          switch (value.hotelListRecomendationResponse.status) {
                            case Status.loading:
                              return SizedBox(
                                height: context.mediaQueryHeight * 0.3,
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: ColorData.myColor,
                                  ),
                                ),
                              );
                            case Status.error:
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            case Status.completed:
                              return SizedBox(
                                height: 280,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: value
                                      .hotelListRecomendationResponse
                                      .data!
                                      .length,
                                  itemBuilder: (context, index) {
                                    return HotelCard(
                                      hotelModel: value
                                          .hotelListRecomendationResponse
                                          .data![index],
                                      onPressed: () {},
                                      favouriteViewModel: favouriteViewModel,
                                    );
                                  },
                                ),
                              );
                            default:
                              return Container();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Restaurant Favorite",
                    style: TextStyle(
                      fontSize: 18,
                      color: ColorData.myColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      print("see all");
                    },
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        color: Color.fromARGB(255, 12, 146, 255),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ChangeNotifierProvider<RestaurantViewModel>(
              create: (context) =>
                  RestaurantViewModel(restaurantRepository: getIt())
                    ..fetchRestaurantListByArea(7),
              child: Consumer<RestaurantViewModel>(
                builder: (context, value, child) {
                  switch (value.restaurantListByArea.status) {
                    case Status.loading:
                      return SizedBox(
                        height: context.mediaQueryHeight * 0.3,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: ColorData.myColor,
                          ),
                        ),
                      );
                    case Status.error:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case Status.completed:
                      return SizedBox(
                        height: 260,
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return const SizedBox(
                              width: 10,
                            );
                          },
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: value.restaurantListByArea.data!.length,
                          itemBuilder: (context, index) {
                            return RestaurantCard(
                              restaurantModel:
                                  value.restaurantListByArea.data![index],
                              favouriteViewModel: favouriteViewModel,
                              onFavoritePressed: () {
                                print('fav $index');
                              },
                              onBookingPressed: () {
                                Navigator.pushNamed(
                                    context, RoutesName.detailRestaurant,
                                    arguments: value.restaurantListByArea
                                        .data![index].restaurantId);
                              },
                            );
                          },
                        ),
                      );
                    default:
                      return Container();
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: context.mediaQueryWidth,
              height: context.mediaQueryWidth * 0.12,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: listHotelType.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: ButtonSelectComponent(
                      index: index,
                      hotelString: listHotelType[index],
                      selectedIndex: indexHotelType,
                      onTap: (p0) {
                        setState(() {
                          indexHotelType = index;
                        });
                        hotelViewModelByType.fetchHotelListByType(type: index);
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 5,
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
                            color: ColorData.myColor,
                          ),
                        ),
                      );
                    case Status.error:
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case Status.completed:
                      return ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: value.hotelListByTypeResponse.data!.length,
                        itemBuilder: (context, index) {
                          HotelModel hotelModel =
                              value.hotelListByTypeResponse.data![index];
                          return HotelComponent(
                            hotelModel: hotelModel,
                            onPressed: () {},
                          );
                        },
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
            // SizedBox(
            //   height: 20,
            // ),
            // MenuComponent(
            //   imageUrl:
            //       'https://beptueu.vn/hinhanh/tintuc/top-15-hinh-anh-mon-an-ngon-viet-nam-khien-ban-khong-the-roi-mat-1.jpg',
            //   nameMeal: "Bánh mỳ",
            //   price: 23444,
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            // CardOrderComponent(
            //   hotelName: "Mường thanh Luxury",
            //   imageUrl:
            //       'https://muongthanh.com/images/video/original/muong-thanh-luxury-quang-ninh-1_1681902050_1688035221.jpg',
            //   orderDate: "08-10-2024/09-10-2024",
            //   viewType: "Hướng sông",
            //   person: 3,
            //   rooms: 2,
            //   price: 2.5000000,
            //   status: "complted",
            //   onPressed: () {
            //     print("detail");
            //   },
            // ),
            // SizedBox(
            //   height: 100,
            // ),
          ],
        ),
      ),
      // SingleChildScrollView(
      //   scrollDirection: Axis.horizontal,
      //   child: Row(
      //     children: [
      //       ButtonSelectComponent(
      //         index: 0,
      //         hotelString: "Khách Sạn",
      //         selectedIndex: indexHotelType,
      //         onTap: (index) {
      //           ListView.builder(
      //             scrollDirection: Axis.vertical,
      //             itemCount: 5, // Number of restaurants
      //             itemBuilder: (context, index) {
      //               return Padding(
      //                 padding: const EdgeInsets.symmetric(
      //                   horizontal: 8.0,
      //                 ),
      //                 child: RestaurantCard(
      //                   imageUrl:
      //                       'https://muongthanh.com/images/video/original/muong-thanh-luxury-quang-ninh-1_1681902050_1688035221.jpg',
      //                   location: 'Location $index',
      //                   ranking: 4,
      //                   restaurantName: 'Restaurant $index',
      //                   onFavoritePressed: () {
      //                     print('fav $index');
      //                   },
      //                   onBookingPressed: () {
      //                     print('booking $index');
      //                   },
      //                 ),
      //               );
      //             },
      //           );
      //         },
      //       ),
      //       ButtonSelectComponent(
      //         index: 1,
      //         hotelString: "Khu Nghỉ Dưỡng",
      //         selectedIndex: indexHotelType,
      //         onTap: (index) {
      //           setState(() {
      //             indexHotelType = index;
      //           });
      //           print("index khu nghi duong");
      //           // hotelViewModel.fetchHotelListByType(type: index);
      //         },
      //       ),
      //       ButtonSelectComponent(
      //         index: 2,
      //         hotelString: "Nhà Hàng",
      //         selectedIndex: indexHotelType,
      //         onTap: (index) {
      //           setState(() {
      //             indexHotelType = index;
      //           });
      //           print("index nha hang");
      //           // hotelViewModel.fetchHotelListByType(type: index);
      //         },
      //       ),
      //     ],
      //   ),
      // ),

      // HotelComponent(
      //   imageUrl:
      //       'https://muongthanh.com/images/video/original/muong-thanh-luxury-quang-ninh-1_1681902050_1688035221.jpg',
      //   hotelName: 'Restaurantssssssssssss',
      //   location: 'Da Nang',
      //   price: 3442222,
      //   onPressed: () {
      //     print('booking');
      //   },
      // ),

      //   Container(
      //     color: Colors.white,
      //     padding: const EdgeInsets.symmetric(horizontal: 0),
      //     child: Column(
      //       children: [
      //         SizedBox(
      //           height: context.mediaQueryHeight * 0.09,
      //         ),
      //         Padding(
      //           padding: const EdgeInsets.symmetric(horizontal: 20.0),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Container(
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     Text(
      //                       _currentAddress ?? "",
      //                       style: MyTextStyle.textStyle(
      //                           fontSize: 15,
      //                           color: Colors.grey,
      //                           fontWeight: FontWeight.bold),
      //                     ),
      //                     Text(
      //                         CustomerDB.getNameCustomer()!
      //                             .customer_name
      //                             .toString(),
      //                         style: MyTextStyle.textStyle(
      //                             fontSize: 18,
      //                             color: ColorData.myColor,
      //                             fontWeight: FontWeight.bold))
      //                   ],
      //                 ),
      //               ),
      //               GestureDetector(
      //                 onTap: () {
      // Navigator.pushNamed(context, RoutesName.test);
      //                   StripeService.instance.makePayment();
      //                 },
      //                 child: Container(
      //                   padding: const EdgeInsets.all(10),
      //                   decoration: BoxDecoration(
      //                       color: ColorData.myColor.withOpacity(0.1),
      //                       borderRadius: BorderRadius.circular(20),
      //                       boxShadow: const [
      //                         BoxShadow(blurRadius: 100, offset: Offset(1, 1))
      //                       ]),
      //                   child: const Icon(
      //                     FontAwesomeIcons.solidEnvelope,
      //                     color: ColorData.myColor,
      //                   ),
      //                 ),
      //               )
      //             ],
      //           ),
      //         ),
      //         Container(
      //           margin:
      //               const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      //           padding:
      //               const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      //           decoration: BoxDecoration(
      //             color: Colors.white,
      //             border: Border.all(
      //                 color: ColorData.myColor.withOpacity(0.4), width: 1),
      //             borderRadius: BorderRadius.circular(10),
      //           ),
      //           child: GestureDetector(
      //             onTap: () {},
      //             child: TextField(
      //               onTap: () {
      //                 Navigator.pushNamed(context, RoutesName.searchPage);
      //               },
      //               decoration: InputDecoration(
      //                 hintText: "Explore Something Fun",
      //                 hintStyle: MyTextStyle.textStyle(
      //                     fontSize: 15, color: Colors.grey),
      //                 border: InputBorder.none,
      //                 prefixIcon: const Icon(
      //                   size: 15,
      //                   FontAwesomeIcons.search,
      //                   color: ColorData.myColor,
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ),

      //         SizedBox(
      //           height: 10,
      //         ),

      //         Padding(
      //           padding: const EdgeInsets.symmetric(horizontal: 20),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Text(
      //                 "Recomendation",
      //                 style: MyTextStyle.textStyle(
      //                     fontSize: 15, fontWeight: FontWeight.bold),
      //               ),
      //             ],
      //           ),
      //         ),

      //         const SizedBox(
      //           height: 10,
      //         ),
      //         ChangeNotifierProvider<HotelViewModel>(
      //           create: (context) => HotelViewModel(hotelRepository: getIt())
      //             ..fetchHotelListRecomendation(),
      //           child: Consumer<HotelViewModel>(
      //             builder: (context, value, child) {
      //               // hotelViewModelByType = value;
      //               switch (value.hotelListRecomendationResponse.status) {
      //                 case Status.loading:
      //                   return SizedBox(
      //                     height: context.mediaQueryHeight * 0.3,
      //                     child: const Center(
      //                       child: CircularProgressIndicator(
      //                         color: ColorData.myColor,
      //                       ),
      //                     ),
      //                   );
      //                 case Status.error:
      //                   return const Center(
      //                     child: CircularProgressIndicator(),
      //                   );
      //                 case Status.completed:
      //                   return Container(
      //                     width: context.mediaQueryWidth,
      //                     height: 270,
      //                     padding: const EdgeInsets.symmetric(
      //                       vertical: 3,
      //                     ),
      //                     child: ListView.builder(
      //                       shrinkWrap: true,
      //                       scrollDirection: Axis.horizontal,
      //                       itemCount: value
      //                           .hotelListRecomendationResponse.data!.length,
      //                       itemBuilder: (context, index) {
      //                         HotelModel hotelModel = value
      //                             .hotelListRecomendationResponse.data![index];
      //                         return WidgetHotelByTypeView(hotelModel, context,
      //                             value, favouriteViewModel);
      //                       },
      //                     ),
      //                   );
      //                 default:
      //                   return Container();
      //               }
      //             },
      //           ),
      //         ),

      //         Padding(
      //           padding: const EdgeInsets.symmetric(horizontal: 20),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Text(
      //                 "Loại khách sạn",
      //                 style: MyTextStyle.textStyle(fontSize: 15),
      //               ),
      //               InkWell(
      //                 child: Row(
      //                   children: [
      //                     Text(
      //                       "See all",
      //                       style: MyTextStyle.textStyle(fontSize: 15),
      //                     ),
      //                     const Icon(
      //                       FontAwesomeIcons.angleRight,
      //                       size: 16,
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //         const SizedBox(
      //           height: 10,
      //         ),
      //         Container(
      //           width: context.mediaQueryWidth,
      //           height: context.mediaQueryWidth * 0.13,
      //           padding: const EdgeInsets.symmetric(vertical: 3),
      //           child: ListView.builder(
      //             shrinkWrap: true,
      //             scrollDirection: Axis.horizontal,
      //             itemCount: listHotelType.length,
      //             itemBuilder: (context, index) {
      //               return hotelTypeButton(
      //                   index, listHotelType[index], hotelViewModelByType);
      //             },
      //           ),
      //         ),
      //         ChangeNotifierProvider<HotelViewModel>(
      //           create: (context) => HotelViewModel(hotelRepository: getIt())
      //             ..fetchHotelListByType(),
      //           child: Consumer<HotelViewModel>(
      //             builder: (context, value, child) {
      //               hotelViewModelByType = value;
      //               switch (value.hotelListByTypeResponse.status) {
      //                 case Status.loading:
      //                   return SizedBox(
      //                     height: context.mediaQueryHeight * 0.3,
      //                     child: const Center(
      //                       child: CircularProgressIndicator(
      //                         color: ColorData.myColor,
      //                       ),
      //                     ),
      //                   );
      //                 case Status.error:
      //                   return const Center(
      //                     child: CircularProgressIndicator(),
      //                   );
      //                 case Status.completed:
      //                   return Container(
      //                     width: context.mediaQueryWidth,
      //                     height: 270,
      //                     padding: const EdgeInsets.symmetric(
      //                       vertical: 3,
      //                     ),
      //                     child: ListView.builder(
      //                       shrinkWrap: true,
      //                       scrollDirection: Axis.horizontal,
      //                       itemCount:
      //                           value.hotelListByTypeResponse.data!.length,
      //                       itemBuilder: (context, index) {
      //                         HotelModel hotelModel =
      //                             value.hotelListByTypeResponse.data![index];
      //                         return WidgetHotelByTypeView(hotelModel, context,
      //                             value, favouriteViewModel);
      //                       },
      //                     ),
      //                   );
      //                 default:
      //                   return Container();
      //               }
      //             },
      //           ),
      //         ),
      //         Padding(
      //             padding:
      //                 const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 Row(
      //                   children: [
      //                     const Icon(
      //                       FontAwesomeIcons.locationArrow,
      //                       color: Colors.amberAccent,
      //                       size: 24,
      //                     ),
      //                     const SizedBox(
      //                       width: 6,
      //                     ),
      //                     Text(
      //                       "Top nearby",
      //                       style: MyTextStyle.textStyle(
      //                           fontSize: 18,
      //                           fontWeight: FontWeight.bold,
      //                           color: ColorData.myColor),
      //                     ),
      //                   ],
      //                 ),
      //                 Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                     Column(
      //                       crossAxisAlignment: CrossAxisAlignment.end,
      //                       children: [
      //                         Text(
      //                           "Location",
      //                           style: MyTextStyle.textStyle(
      //                               fontSize: 12,
      //                               color: Colors.black.withOpacity(0.4)),
      //                         ),
      //                         widgetTextForLocation(),
      //                       ],
      //                     ),
      //                     Container(
      //                       margin: const EdgeInsets.only(left: 10),
      //                       padding: const EdgeInsets.all(10),
      //                       decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(10),
      //                           color: ColorData.myColor.withOpacity(0.1)),
      //                       child: const Icon(
      //                         FontAwesomeIcons.locationCrosshairs,
      //                         color: ColorData.myColor,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ],
      //             )),

      //         // Container(child: ,)
      //         ChangeNotifierProvider<RestaurantViewModel>(
      //           create: (context) =>
      //               RestaurantViewModel(restaurantRepository: getIt())
      //                 ..fetchRestaurantListByArea(areaId),
      //           child: Consumer<RestaurantViewModel>(
      //             builder: (context, value, child) {
      //               restaurantViewModel = value;
      //               switch (value.restaurantListByArea.status) {
      //                 case Status.loading:
      //                   return SizedBox(
      //                     height: context.mediaQueryHeight * 0.3,
      //                     child: const Center(
      //                       child: CircularProgressIndicator(),
      //                     ),
      //                   );
      //                 case Status.completed:
      //                   return ListView.builder(
      //                     physics: const NeverScrollableScrollPhysics(),
      //                     padding: EdgeInsets.zero,
      //                     itemBuilder: (context, index) {
      //                       // return WidgetHotelByArea(
      //                       //     value.hotelListByLocation.data![index],
      //                       //     context,
      //                       //     favouriteViewModel);
      //                       return WidgetRestaurantByArea(
      //                           value.restaurantListByArea.data![index],
      //                           context);
      //                     },
      //                     itemCount: value.restaurantListByArea.data!.length,
      //                     shrinkWrap: true,
      //                   );
      //                 default:
      //                   return Container();
      //               }
      //             },
      //           ),
      //         ),

      //         Padding(
      //           padding:
      //               const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      //           child: Row(
      //             children: [
      //               const Icon(
      //                 FontAwesomeIcons.newspaper,
      //                 color: Colors.amberAccent,
      //               ),
      //               const SizedBox(
      //                 width: 10,
      //               ),
      //               Text(
      //                 "Insight for You",
      //                 style: MyTextStyle.textStyle(
      //                     fontSize: 15,
      //                     color: Colors.blueGrey,
      //                     fontWeight: FontWeight.bold),
      //               )
      //             ],
      //           ),
      //         ),
      //         SizedBox(
      //             width: context.mediaQueryWidth,
      //             height: context.mediaQueryHeight * 0.35,
      //             child: ChangeNotifierProvider<BannerViewModel>(
      //               create: (context) =>
      //                   BannerViewModel(bannerRepository: getIt())
      //                     ..fetchBannerResponse(),
      //               child: Consumer<BannerViewModel>(
      //                 builder: (context, value, child) {
      //                   switch (value.bannerListResponse.status) {
      //                     case Status.loading:
      //                       return SizedBox(
      //                         height: context.mediaQueryHeight * 0.2,
      //                         child: const Center(
      //                           child: CircularProgressIndicator(),
      //                         ),
      //                       );
      //                     case Status.error:
      //                       return Center(
      //                         child: Text(
      //                             value.bannerListResponse.message!.toString()),
      //                       );
      //                     case Status.completed:
      //                       return SizedBox(
      //                         height: context.mediaQueryHeight * 0.6,
      //                         child: ListView.builder(
      //                           scrollDirection: Axis.horizontal,
      //                           itemCount:
      //                               value.bannerListResponse.data!.length,
      //                           shrinkWrap: true,
      //                           itemBuilder: (context, index) {
      //                             return WidgetNewsForHotel(
      //                                 value.bannerListResponse.data![index]);
      //                           },
      //                         ),
      //                       );
      //                     default:
      //                       return Container();
      //                   }
      //                 },
      //               ),
      //             )),
      //         SizedBox(
      //           height: 10,
      //         ),
      //       ],
      //     ),
      //   ),
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
              color: index == indexHotelType ? ColorData.myColor : Colors.white,
              borderRadius: BorderRadius.circular(60),
              border: Border.all(
                  color: index == indexHotelType
                      ? Colors.transparent
                      : ColorData.borderColorMain,
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

  Widget WidgetHotelByTypeView(HotelModel hotelModel, BuildContext context,
      HotelViewModel hotelViewModel, FavouriteViewModel favouriteViewModel) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 10),
        child: GestureDetector(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: ColorData.borderColorMain, width: 1),
                borderRadius: BorderRadius.circular(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigator.pushNamed(context, RoutesName.detailHotel,
                    //         arguments: hotelModel.hotelId)
                    //     .then((value) {
                    //   // print("huhuhuhu");
                    //   // hotelViewModelByType.fetchHotelListByType();
                    // });
                    Navigator.pushNamed(context, RoutesName.detailRestaurant);
                  },
                  child: Stack(
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
                          GestureDetector(
                            onTap: () {
                              if (favouriteViewModel
                                      .checkFavouriteId(hotelModel.hotelId) ==
                                  true) {
                                favouriteViewModel
                                    .deleteFavouriteId(hotelModel.hotelId);
                                CherryToast.success(
                                  title: const Text(
                                      "Đã xóa ra khỏi mục yêu thích!"),
                                ).show(context);
                              } else {
                                favouriteViewModel
                                    .addFavouriteId(hotelModel.hotelId);
                                CherryToast.success(
                                  title:
                                      const Text("Đã thêm vào mục yêu thích!"),
                                ).show(context);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.pink.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: favouriteViewModel.checkFavouriteId(
                                          hotelModel.hotelId) ==
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

  Widget WidgetRestaurantByArea(
      RestaurantModel restaurantModel, BuildContext context) {
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
                Navigator.pushNamed(context, RoutesName.detailRestaurant,
                    arguments: restaurantModel.restaurantId);
              },
              child: Stack(
                children: <Widget>[
                  Container(
                    width: context.mediaQueryWidth * 0.35,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      image: DecorationImage(
                        image: NetworkImage(restaurantModel.restaurantImage),
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
                      restaurantModel.restaurantName,
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
                        restaurantModel.area.areaName,
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
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
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
                      color: ColorData.myColor),
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
            color: Colors.white,
            border: Border.all(
                color: const Color.fromRGBO(232, 234, 241, 1), width: 1),
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
                                  color: ColorData.myColor,
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
