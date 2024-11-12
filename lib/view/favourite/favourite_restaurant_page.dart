import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_hotel_and_restaurants/data/response/status.dart';
import 'package:my_hotel_and_restaurants/main.dart';
import 'package:my_hotel_and_restaurants/view/components/search_card_component.dart';
import 'package:my_hotel_and_restaurants/view_model/favourite_restaurant_view_model.dart';
import 'package:provider/provider.dart';

class FavouriteRestaurantPage extends StatefulWidget {
  const FavouriteRestaurantPage({super.key});

  @override
  State<FavouriteRestaurantPage> createState() =>
      _FavouriteRestaurantPageState();
}

class _FavouriteRestaurantPageState extends State<FavouriteRestaurantPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FavouriteRestaurantViewModel>(
      create: (context) =>
          FavouriteRestaurantViewModel(restaurantRepository: getIt())
            ..fetchFavouriteList(),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(246, 248, 251, 1),
        body: SingleChildScrollView(
          child: Consumer<FavouriteRestaurantViewModel>(
            builder: (context, value, child) {
              switch (value.favouriteViewModel.status) {
                case Status.completed:
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: value.favouriteViewModel.data!.length,
                    itemBuilder: (context, index) {
                      return SearchCardComponent(
                        onPressed: () {},
                        searchModel: value.favouriteViewModel.data![index],
                      );
                    },
                  );
                case Status.loading:
                  return Center(
                    child: Lottie.asset("assets/raw/waiting_1.json"),
                  );
                case Status.error:
                  if (value.favouriteViewModel.message == "completed") {
                    return Column(
                      children: [
                        Center(
                          child: Lottie.asset("assets/raw/empty.json"),
                        ),
                        const Text("Không có nhà hàng nào!")
                      ],
                    );
                  }
                  return Center(
                    child: Text(value.favouriteViewModel.message.toString()),
                  );
                default:
                  return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
