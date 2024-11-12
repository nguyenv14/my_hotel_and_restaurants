import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:my_hotel_and_restaurants/view_model/favourite_restaurant_view_model.dart';
import 'package:my_hotel_and_restaurants/view_model/favourite_view_model.dart';
import 'package:provider/provider.dart';

class FavoriteButton extends StatefulWidget {
  final double right;
  final double top;
  final int hotelId;
  final int type;
  final Color iconColor;

  const FavoriteButton(
      {super.key,
      this.right = 8.0,
      this.top = 8.0,
      this.iconColor = const Color.fromARGB(255, 240, 18, 18),
      required this.hotelId,
      required this.type});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    final favouriteViewModel =
        Provider.of<FavouriteViewModel>(context, listen: true);
    final favouriteRestaurantViewModel =
        Provider.of<FavouriteRestaurantViewModel>(context, listen: true);
    return Positioned(
      right: widget.right,
      top: widget.top,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(5)),
        child: IconButton(
            icon: Icon(
              widget.type == 1
                  ? favouriteViewModel.checkFavouriteId(widget.hotelId)
                      ? Icons.favorite
                      : Icons.favorite_border
                  : favouriteRestaurantViewModel
                          .checkFavouriteId(widget.hotelId)
                      ? Icons.favorite
                      : Icons.favorite_border,
              color: widget.iconColor,
            ),
            onPressed: () {
              if (widget.type == 1) {
                if (favouriteViewModel.checkFavouriteId(widget.hotelId) ==
                    true) {
                  favouriteViewModel.deleteFavouriteId(widget.hotelId);
                  CherryToast.success(
                    title: const Text("Removed from favorites!"),
                  ).show(context);
                } else {
                  favouriteViewModel.addFavouriteId(widget.hotelId);
                  CherryToast.success(
                    title: const Text("Added to favourites!"),
                  ).show(context);
                }
              } else {
                if (favouriteRestaurantViewModel
                        .checkFavouriteId(widget.hotelId) ==
                    true) {
                  favouriteRestaurantViewModel
                      .deleteFavouriteId(widget.hotelId);
                  CherryToast.success(
                    title: const Text("Removed from favorites!"),
                  ).show(context);
                } else {
                  favouriteRestaurantViewModel.addFavouriteId(widget.hotelId);
                  CherryToast.success(
                    title: const Text("Added to favourites!"),
                  ).show(context);
                }
              }
            }),
      ),
    );
  }
}
