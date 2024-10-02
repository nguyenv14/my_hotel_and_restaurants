class GalleryRoomModel {
  final int galleryRoomId;
  final int roomId;
  final String galleryRoomName;
  final String galleryRoomImage;
  final String galleryRoomContent;

  GalleryRoomModel({
    required this.galleryRoomId,
    required this.roomId,
    required this.galleryRoomName,
    required this.galleryRoomImage,
    required this.galleryRoomContent,
  });

  factory GalleryRoomModel.fromJson(Map<String, dynamic> json) {
    return GalleryRoomModel(
      galleryRoomId: json['gallery_room_id'],
      roomId: json['room_id'],
      galleryRoomName: json['gallery_room_name'],
      galleryRoomImage: json['gallery_room_image'],
      galleryRoomContent: json['gallery_room_content'],
    );
  }

  static List<GalleryRoomModel> getListHotel(List<dynamic> source) {
    List<GalleryRoomModel> hotelList =
        source.map((e) => GalleryRoomModel.fromJson(e)).toList();
    return hotelList;
  }
}
