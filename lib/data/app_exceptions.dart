class AppException implements Exception {
  final _message;
  final _prefix;
  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return '$_message$_prefix';
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, 'Lỗi trong quá trình fetch dữ liệu');
}

class BadRequestException extends AppException {
  BadRequestException([String? message])
      : super(message, 'Request không hợp lệ!');
}

class UnauthorisedException extends AppException {
  UnauthorisedException([String? message])
      : super(message, 'Request không được cho phép!');
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message])
      : super(message, 'Đầu vào không đúng!');
}

class NoInternetException extends AppException {
  NoInternetException([String? message])
      : super(message, ' Không có kết nối internet!');
}
