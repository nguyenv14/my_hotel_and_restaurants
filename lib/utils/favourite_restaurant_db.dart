import 'package:get_storage/get_storage.dart';
import 'package:my_hotel_and_restaurants/model/favourite_restaurant_model.dart';
import 'package:my_hotel_and_restaurants/utils/user_db.dart';

class FavouriteRestaurantDB {
  static List<FavouriteRestaurantModel> getListFavorite() {
    final box = GetStorage();
    List<FavouriteRestaurantModel> userList =
        FavouriteRestaurantModel.getListFavourite(
            box.read("FavouriteRestaurant") ?? []);
    return userList;
  }

  static void saveFavoriteId(int hotelId) {
    final box = GetStorage();
    List<FavouriteRestaurantModel> favouriteList =
        FavouriteRestaurantModel.getListFavourite(
            box.read("FavouriteRestaurant") ?? []);

    FavouriteRestaurantModel favouriteModel = FavouriteRestaurantModel(
      customer_id: CustomerDB.getCustomer()!.customer_id!,
      restaurant_id: hotelId,
    );
    favouriteList.add(favouriteModel);
    box.write("FavouriteRestaurant",
        FavouriteRestaurantModel.getListUserFeeJson(favouriteList));
  }

  static bool checkFavouriteId(int id) {
    final box = GetStorage();
    List<FavouriteRestaurantModel> favouriteList =
        FavouriteRestaurantModel.getListFavourite(
            box.read("FavouriteRestaurant") ?? []);
    if (favouriteList.isEmpty) {
      return false;
    } else {
      return favouriteList.any((element) =>
          element.restaurant_id == id &&
          element.customer_id == CustomerDB.getCustomer()?.customer_id);
    }
  }

  static void deleteFavouriteId(int id) {
    final box = GetStorage();
    List<FavouriteRestaurantModel> favouriteList =
        FavouriteRestaurantModel.getListFavourite(
            box.read("FavouriteRestaurant") ?? []);
    int index = favouriteList.indexWhere((element) =>
        element.customer_id == CustomerDB.getCustomer()!.customer_id &&
        element.restaurant_id == id);
    favouriteList.removeAt(index);
    box.write("FavouriteRestaurant",
        FavouriteRestaurantModel.getListUserFeeJson(favouriteList));
  }
}
