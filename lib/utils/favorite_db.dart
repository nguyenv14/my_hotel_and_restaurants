import 'package:get_storage/get_storage.dart';
import 'package:my_hotel_and_restaurants/model/list_id_model.dart';
import 'package:my_hotel_and_restaurants/utils/user_db.dart';

class FavouriteDB {
  static List<FavouriteModel> getListUserFee() {
    final box = GetStorage();
    List<FavouriteModel> userList =
        FavouriteModel.getListUser(box.read("Favourite") ?? []);
    return userList;
  }

  static void saveFavoriteId(int hotel_id) {
    final box = GetStorage();
    List<FavouriteModel> favouriteList =
        FavouriteModel.getListUser(box.read("Favourite") ?? []);

    FavouriteModel favouriteModel = new FavouriteModel(
        customer_id: CustomerDB.getCustomer()!.customer_id!,
        hotel_id: hotel_id);
    favouriteList.add(favouriteModel);
    box.write("Favourite", FavouriteModel.getListUserFeeJson(favouriteList));
  }

  static bool checkFavourite(int id) {
    final box = GetStorage();
    List<FavouriteModel> favouriteList =
        FavouriteModel.getListUser(box.read("Favourite") ?? []);
    if (favouriteList.isEmpty) {
      return false;
    } else {
      // int index = favouriteList.indexWhere((element) =>
      //     element.customer_id == CustomerDB.getCustomer()!.customer_id &&
      //     element.hotel_id == id);
      return favouriteList.contains(id);
      // if (index == -1) {
      //   return false;
      // } else {
      //   return true;
      // }
    }
  }

  static void deleteFavouriteId(int id) {
    final box = GetStorage();
    List<FavouriteModel> favouriteList =
        FavouriteModel.getListUser(box.read("Favourite") ?? []);
    int index = favouriteList.indexWhere((element) =>
        element.customer_id == CustomerDB.getCustomer()!.customer_id &&
        element.hotel_id == id);
    favouriteList.removeAt(index);
    box.write("Favourite", FavouriteModel.getListUserFeeJson(favouriteList));
  }
}
