import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_hotel_and_restaurants/data/response/dto_object.dart';
import 'package:my_hotel_and_restaurants/model/customer_model.dart';
import 'package:my_hotel_and_restaurants/repository/Auth/auth_repository.dart';
import 'package:my_hotel_and_restaurants/utils/user_db.dart';

class LoginViewModel extends ChangeNotifier {
  AuthRepository authRepository;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final ggSignin = GoogleSignIn();
  LoginViewModel({required this.authRepository});
  bool _loginLoading = false;
  bool get loginLoading => _loginLoading;
  bool _sinUpLoading = false;
  bool get sinUpLoading => _sinUpLoading;

  bool _ggLoading = false;
  bool get ggLoading => _ggLoading;
  setGGLoading(bool value) {
    _ggLoading = value;
    notifyListeners();
  }

  setLoginLoading(bool value) {
    _loginLoading = value;
    notifyListeners();
  }

  setSignUpLoading(bool value) {
    _sinUpLoading = value;
    notifyListeners();
  }

  //creating getter method to store value of input email
  String _email = '';
  String get email => _email;

  setEmail(String email) {
    _email = email;
  }

  //creating getter method to store value of input password
  String _password = '';
  String get password => _password;

  setPassword(String password) {
    _password = password;
  }

  Future<ObjectDTO> loginApi(
      String customerEmail, String customerPassword) async {
    // final CustomerP
    try {
      setLoginLoading(true);
      var body = {
        "customer_email": customerEmail,
        "customer_password": customerPassword
      };
      final response = await authRepository.checkLogin(body);
      if (response.statusCode == 200) {
        CustomerModel customerModel = CustomerModel.fromJson(response.data);
        CustomerDB.saveCustomer(customerModel);
        // ggSignin.disconnect();
      }
      setLoginLoading(false);
      return response;
    } catch (e) {
      setLoginLoading(false);
      throw Exception(e);
    }
  }

  Future<ObjectDTO> signUp(String customerEmail, String customerPassword,
      String customerPhone, String customerName) async {
    // final CustomerP
    try {
      setSignUpLoading(true);
      var body = {
        "customer_email": customerEmail,
        "customer_password": customerPassword,
        "customer_phone": customerPhone,
        "customer_name": customerName,
      };
      final response = await authRepository.signUp(body);
      setSignUpLoading(false);
      return response;
    } catch (e) {
      setSignUpLoading(false);
      throw Exception(e);
    }
  }

  Future<ObjectDTO> signInWithGoogle() async {
    setGGLoading(true);
    try {
      final GoogleSignInAccount? googleUser = await ggSignin.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;
      // print(user!.email!);
      // print(user.displayName!);
      var body = {
        "customer_password": "",
        "customer_email": user!.email!,
        "customer_phone": user.phoneNumber ?? "",
        "customer_name": user.displayName ?? "Người Dùng 1",
      };
      final response = await authRepository.singInWithGG(body);
      if (response.statusCode == 200) {
        CustomerModel customerModel = CustomerModel.fromJson(response.data);
        CustomerDB.saveCustomer(customerModel);
        setSignUpLoading(false);
      }
      setGGLoading(false);
      ggSignin.disconnect();
      // print(user!.phoneNumber);
      // await getOrSetUserFirestore(user);
      // print('Đăng nhập thành công!');
      // return userFromUserFirebase(user);
      // await getUserModel(userCredential.user!.uid);
      return response;
    } catch (error) {
      ggSignin.disconnect();
      if (kDebugMode) {
        print('Lỗi đăng nhập: $error');
      }
      setGGLoading(false);
      throw Exception(error.toString());
    }
  }
}
