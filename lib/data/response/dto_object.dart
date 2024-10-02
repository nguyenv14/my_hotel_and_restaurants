class ObjectDTO {
  final int? statusCode;
  final String? message;
  final dynamic
      data; // Dữ liệu có thể là null, một đối tượng hoặc một danh sách các đối tượng

  ObjectDTO({this.statusCode, this.message, this.data});

  factory ObjectDTO.fromJson(Map<String, dynamic> json) {
    return ObjectDTO(
      statusCode: json['status_code'],
      message: json['message'],
      data: json['data'],
    );
  }
}
