import 'package:flutter/cupertino.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/model/gallery_restaurant_model.dart';
import 'package:my_hotel_and_restaurants/model/restaurant_model.dart';

class ListImageComponent extends StatefulWidget {
  final RestaurantModel restaurantModel;
  const ListImageComponent({super.key, required this.restaurantModel});

  @override
  State<ListImageComponent> createState() => _ListImageComponentState();
}

class _ListImageComponentState extends State<ListImageComponent> {
  late List<GalleryRestaurantModel> gallerys;
  @override
  Widget build(BuildContext context) {
    gallerys = widget.restaurantModel.galleryRestaurantList.toList();
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 5),
          width: context.mediaQueryWidth,
          height: 213,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image(
                image: NetworkImage(
                  widget.restaurantModel.restaurantImage,
                ),
                fit: BoxFit.cover,
              )),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          child: SizedBox(
            height: 85,
            child: ListView.separated(
              itemCount: gallerys.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(),
              separatorBuilder: (context, index) {
                return const SizedBox(
                  width: 4,
                );
              },
              itemBuilder: (context, index) {
                return Container(
                    padding: const EdgeInsets.only(right: 10),
                    width: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image(
                        image: NetworkImage(
                            gallerys[index].galleryRestaurantImage),
                        fit: BoxFit.cover,
                      ),
                    ));
              },
            ),
          ),
        )
      ],
    );
  }
}
