import 'package:get_storage/get_storage.dart';
import 'package:my_hotel_and_restaurants/model/list_id_model.dart';
import 'package:my_hotel_and_restaurants/utils/user_db.dart';

class FavouriteDB {
  static List<FavouriteModel> getListFavorite() {
    final box = GetStorage();
    List<FavouriteModel> userList =
        FavouriteModel.getListFavourite(box.read("Favourite") ?? []);
    return userList;
  }

  static void saveFavoriteId(int hotelId) {
    final box = GetStorage();
    List<FavouriteModel> favouriteList =
        FavouriteModel.getListFavourite(box.read("Favourite") ?? []);

    FavouriteModel favouriteModel = FavouriteModel(
      customer_id: CustomerDB.getCustomer()!.customer_id!,
      hotel_id: hotelId,
    );
    favouriteList.add(favouriteModel);
    box.write("Favourite", FavouriteModel.getListUserFeeJson(favouriteList));
  }

  static bool checkFavourite(int id) {
    final box = GetStorage();
    List<FavouriteModel> favouriteList =
        FavouriteModel.getListFavourite(box.read("Favourite") ?? []);
    if (favouriteList.isEmpty) {
      return false;
    } else {
      return favouriteList.any((element) =>
          element.hotel_id == id &&
          element.customer_id == CustomerDB.getCustomer()?.customer_id);
    }
  }

  static void deleteFavouriteId(int id) {
    final box = GetStorage();
    List<FavouriteModel> favouriteList =
        FavouriteModel.getListFavourite(box.read("Favourite") ?? []);
    int index = favouriteList.indexWhere((element) =>
        element.customer_id == CustomerDB.getCustomer()!.customer_id &&
        element.hotel_id == id);
    favouriteList.removeAt(index);
    box.write("Favourite", FavouriteModel.getListUserFeeJson(favouriteList));
  }
}
