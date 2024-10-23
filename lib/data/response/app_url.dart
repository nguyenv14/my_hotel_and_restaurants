class AppUrl {
  static var base = 'http://192.168.1.19/DoAnCoSo2/';
  static var baseUrl = base + 'api/';
  static var testApi = "${baseUrl}get-brand";

  //customer
  static var CheckLogin = "${baseUrl}check-login";

  static var signUp = baseUrl + "create-customer";

  static var SignInGG = baseUrl + "login-gg";

  static var updateCustomer = baseUrl + "customer/update-customer";

  // Hotel
  static var hotelURL = "${baseUrl}hotel/";
  static var hoteListByType = "${hotelURL}get-hotel-list-by-type";
  static var hotelListByArea = "${hotelURL}get-hotel-list-by-area";
  static var hotelById = "${hotelURL}get-hotel-by-id";
  static var hotelFavourite = "${hotelURL}get-hotel-favourite-list";
  static var searchHotel = "${hotelURL}search-hotel";
  static var hotelRecommendation = "${hotelURL}hotel-recomendation";

  //Restaurant
  static var restaurantUrl = "${baseUrl}restaurant/";
  static var restaurantListByArea = "${restaurantUrl}restaurant-by-area";
  static var restaurantById = "${restaurantUrl}restaurant-by-id";

  //Order
  static var orderListByStatus = baseUrl + "order/get-order-list-by-status";

  static var cancelOrderById = baseUrl + "order/cancel-order-by-customer";

  static var sendCommentOrder = baseUrl + "order/evaluate-customer";

  //Area
  static var areaList = "${baseUrl}area/get-area-list-have-hotel";

  //Banner
  static var bannerList = "${baseUrl}banner/get-banner-list";

  //image
  static var hotelImage = base + 'public/fontend/assets/img/hotel/';
  static var restaurantImage = base + 'public/fontend/assets/img/restaurant/';
  static var restaurantMenuImage = base + 'public/fontend/assets/img/menu/';
  static var bannerImage = base + 'public/fontend/assets/img/bannerads/';
  static var hotelGallery = base + "public/fontend/assets/img/hotel/gallery_";
  static var roomGallery =
      base + "public/fontend/assets/img/hotel/room/gallery_";

  // Coupon
  static var couponList = '${baseUrl}coupon/get-coupon';

  static var checkOut = "${baseUrl}order/checkout";

  // Brand
  static var brand = '${baseUrl}brand/get-brand';
}
