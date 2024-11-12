enum SortRestaurant {
  defaultHotel(0, 'Mặc định'),
  nameDesc(3, "Tên A -> Z"),
  nameAsc(4, "Tên Z -> A");

  final int id;
  final String name;

  const SortRestaurant(this.id, this.name);

  static SortRestaurant? getById(int id) {
    return SortRestaurant.values.firstWhere(
      (area) => area.id == id,
    );
  }

  static SortRestaurant? getByName(String name) {
    return SortRestaurant.values.firstWhere(
      (area) => area.name == name,
    );
  }

  static int? getIdFromName(String name) {
    final area = getByName(name);
    return area?.id;
  }

  static List<String> getAreaNames() {
    return SortRestaurant.values.map((area) => area.name).toList();
  }
}
