import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:motivate_daily/routes/app_rotes.dart';
import '../../../data/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  var isLoading = false.obs;
  var user = Rxn<User>();

  @override
  void onInit() {
    user.bindStream(_authService.userChanges);
    super.onInit();
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      await _authService.signIn(email, password);

      // ✅ Go to Home after login
      Get.offAllNamed(AppRoutes.home);

      Get.snackbar("Success", "Logged in successfully!");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signup(String email, String password) async {
    try {
      isLoading.value = true;
      await _authService.signUp(email, password);

      // ✅ Go to Login after signup
      Get.offAllNamed(AppRoutes.login);

      Get.snackbar("Success", "Account created! Please login.");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();

    // ✅ Go to Login after logout
    Get.offAllNamed(AppRoutes.login);
  }
}
