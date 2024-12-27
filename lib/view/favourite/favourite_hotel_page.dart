import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_hotel_and_restaurants/data/response/status.dart';
import 'package:my_hotel_and_restaurants/main.dart';
import 'package:my_hotel_and_restaurants/view/components/search_card_component.dart';
import 'package:my_hotel_and_restaurants/view_model/favourite_view_model.dart';
import 'package:provider/provider.dart';

class FavouriteHotelPage extends StatefulWidget {
  const FavouriteHotelPage({super.key});

  @override
  State<FavouriteHotelPage> createState() => _FavouriteHotelPageState();
}

class _FavouriteHotelPageState extends State<FavouriteHotelPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FavouriteViewModel>(
      create: (context) =>
          FavouriteViewModel(hotelRepository: getIt())..fetchFavouriteList(),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(246, 248, 251, 1),
        body: SingleChildScrollView(
          child: Consumer<FavouriteViewModel>(
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
                        const Text("Không có khách sạn nào!")
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
