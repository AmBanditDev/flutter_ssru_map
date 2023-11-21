// packages
import 'package:flutter/material.dart';
import 'package:flutter_ssru_map/backend/screens/dashboard_screen.dart';
import 'package:flutter_ssru_map/backend/screens/form_edit_data/form_edit_content.dart';
import 'package:flutter_ssru_map/backend/screens/form_edit_data/form_edit_user.dart';
import 'package:flutter_ssru_map/frontend/screens/forgot_password_screen.dart';
import 'package:flutter_ssru_map/frontend/screens/launcher.dart';
import 'package:flutter_ssru_map/frontend/screens/login_register_screen.dart';
// screens
import 'package:flutter_ssru_map/frontend/screens/login_screen.dart';
import 'package:flutter_ssru_map/frontend/screens/map.dart';
import 'package:flutter_ssru_map/frontend/screens/register_screen.dart';
import 'package:flutter_ssru_map/frontend/screens/search_screen.dart';
import 'package:flutter_ssru_map/frontend/screens/splashToLoginRegis_screen.dart';

class AppRoute {
  static const splashToLoginRegister = 'splashToLoginRegister';
  static const loginRegister = 'loginRegister';
  static const login = 'login';
  static const register = 'register';
  static const forgetPassword = 'forgetPassword';
  static const home = 'home';
  static const map = 'map';
  static const search = 'search';
  static const dashboard = 'dashboard';

  static get all => <String, WidgetBuilder>{
        splashToLoginRegister: (context) => const SplashToLoginRegisScreen(),
        loginRegister: (context) => const LoginOrRegisterScreen(),
        login: (context) => const LoginScreen(),
        register: (context) => const RegisterScreen(),
        forgetPassword: (context) => const ForgetPasswordScreen(),
        home: (context) => const LauncherScreen(),
        map: (context) => const MapScreen(),
        search: (context) => const SearchScreen(),
        dashboard: (context) => const DashboardScreen(),
      };
}
