enum Area {
  tatCa(0, 'Tất Cả'),
  camLe(3, "Cẩm Lệ"),
  haiChau(4, "Hải Châu"),
  hoaVang(5, "Hòa Vang"),
  lienChieu(6, "Liên Chiểu"),
  nguHanhSon(7, "Ngũ Hành Sơn"),
  sonTra(8, "Sơn Trà"),
  thanhKhe(9, "Thanh Khê");

  final int id;
  final String name;

  const Area(this.id, this.name);

  static Area? getById(int id) {
    return Area.values.firstWhere(
      (area) => area.id == id,
    );
  }

  static Area? getByName(String name) {
    return Area.values.firstWhere(
      (area) => area.name == name,
    );
  }

  static int? getIdFromName(String name) {
    final area = getByName(name);
    return area?.id;
  }

  static List<String> getAreaNames() {
    return Area.values.map((area) => area.name).toList();
  }
}
