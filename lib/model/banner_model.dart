class BannerModel {
  final int id;
  final String title;
  final String description;
  final int page;
  final String link;
  final String image;
  final int status;

  BannerModel({
    required this.id,
    required this.title,
    required this.description,
    required this.page,
    required this.link,
    required this.image,
    required this.status,
  });

  BannerModel.empty()
      : id = 0,
        title = '',
        description = '',
        page = 0,
        link = '',
        image = '',
        status = 0;

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return BannerModel.empty();
    }
    return BannerModel(
      id: json['bannerads_id'],
      title: json['bannerads_title'],
      description: json['bannerads_desc'],
      page: json['bannerads_page'],
      link: json['bannerads_link'],
      image: json['bannerads_image'],
      status: json['bannerads_status'],
    );
  }

  static List<BannerModel> getListBannerModel(List<dynamic> source) {
    List<BannerModel> hotelList =
        source.map((e) => BannerModel.fromJson(e)).toList();
    return hotelList;
  }
}
