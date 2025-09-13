
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../modules/auth/view/login_view.dart';
import '../modules/auth/view/sign_up_view.dart';
import '../modules/favourites/favourites_view.dart';
import '../modules/home/home_view.dart';
import 'app_rotes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => LoginView(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => SignupView(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => HomeView(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: AppRoutes.favorites,
      page: () => FavoritesView(),
      transition: Transition.downToUp,
    ),
  ];
}
