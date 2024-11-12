enum SortHotel {
  defaultHotel(0, 'Mặc định'),
  priceDesc(1, "Giá tiền tăng"),
  priceAsc(2, "Giá tiền giảm"),
  nameDesc(3, "Tên A -> Z"),
  nameAsc(4, "Tên Z -> A");

  final int id;
  final String name;

  const SortHotel(this.id, this.name);

  static SortHotel? getById(int id) {
    return SortHotel.values.firstWhere(
      (area) => area.id == id,
    );
  }

  static SortHotel? getByName(String name) {
    return SortHotel.values.firstWhere(
      (area) => area.name == name,
    );
  }

  static int? getIdFromName(String name) {
    final area = getByName(name);
    return area?.id;
  }

  static List<String> getAreaNames() {
    return SortHotel.values.map((area) => area.name).toList();
  }
}
