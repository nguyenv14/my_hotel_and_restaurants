import 'package:flutter/cupertino.dart';
import 'package:my_hotel_and_restaurants/configs/extensions.dart';
import 'package:my_hotel_and_restaurants/data/response/app_url.dart';
import 'package:my_hotel_and_restaurants/model/gallery_hotel_model.dart';
import 'package:my_hotel_and_restaurants/model/hotel_model.dart';
import 'package:my_hotel_and_restaurants/utils/app_functions.dart';

class ListImageHotelComponent extends StatefulWidget {
  final HotelModel hotelModel;
  const ListImageHotelComponent({super.key, required this.hotelModel});

  @override
  State<ListImageHotelComponent> createState() =>
      _ListImageHotelComponentState();
}

class _ListImageHotelComponentState extends State<ListImageHotelComponent> {
  late List<GalleryHotelModel> gallerys;
  @override
  Widget build(BuildContext context) {
    gallerys = widget.hotelModel.galleryHotel.toList();
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
                  widget.hotelModel.hotelImage,
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
                          "${AppUrl.hotelGallery}${AppFunctions.deleteSpaceWhite(widget.hotelModel.hotelName)}/${gallerys[index].galleryHotelImage}",
                        ),
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
