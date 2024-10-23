import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:my_hotel_and_restaurants/view_model/favourite_view_model.dart';
import 'package:provider/provider.dart';

class FavoriteButton extends StatelessWidget {
  final double right;
  final double top;
  final int hotelId;
  final Color iconColor;

  const FavoriteButton({
    Key? key,
    this.right = 8.0,
    this.top = 8.0,
    this.iconColor = const Color.fromARGB(255, 240, 18, 18),
    required this.hotelId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final favouriteViewModel =
        Provider.of<FavouriteViewModel>(context, listen: true);
    return Positioned(
      right: right,
      top: top,
      child: IconButton(
        icon: Icon(
          favouriteViewModel.checkFavouriteId(hotelId)
              ? Icons.favorite
              : Icons.favorite_border,
          color: iconColor,
        ),
        onPressed: () {
          if (favouriteViewModel.checkFavouriteId(hotelId) == true) {
            favouriteViewModel.deleteFavouriteId(hotelId);
            CherryToast.success(
              title: const Text("Removed from favorites!"),
            ).show(context);
          } else {
            favouriteViewModel.addFavouriteId(hotelId);
            CherryToast.success(
              title: const Text("Added to favourites!"),
            ).show(context);
          }
        },
      ),
    );
  }
}
