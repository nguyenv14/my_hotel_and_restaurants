class CouponModel {
  final int couponId;
  final String couponName;
  final String couponNameCode;
  final String couponDesc;
  final int couponQtyCode;
  final int couponCondition;
  final int couponPriceSale;
  final String couponStartDate;
  final String couponEndDate;

  CouponModel({
    required this.couponId,
    required this.couponName,
    required this.couponNameCode,
    required this.couponDesc,
    required this.couponQtyCode,
    required this.couponCondition,
    required this.couponPriceSale,
    required this.couponStartDate,
    required this.couponEndDate,
  });

  CouponModel.empty()
      : couponId = 0,
        couponName = '',
        couponNameCode = '',
        couponDesc = '',
        couponQtyCode = 0,
        couponCondition = 0,
        couponPriceSale = 0,
        couponStartDate = '',
        couponEndDate = '';

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      couponId: json['coupon_id'],
      couponName: json['coupon_name'],
      couponNameCode: json['coupon_name_code'],
      couponDesc: json['coupon_desc'],
      couponQtyCode: json['coupon_qty_code'],
      couponCondition: json['coupon_condition'],
      couponPriceSale: json['coupon_price_sale'],
      couponStartDate: json['coupon_start_date'],
      couponEndDate: json['coupon_end_date'],
    );
  }

  static List<CouponModel> getListCoupon(List<dynamic> source) {
    List<CouponModel> hotelList =
        source.map((e) => CouponModel.fromJson(e)).toList();
    return hotelList;
  }
}
