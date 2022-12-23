import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Dark ==0
//White==1


class AppTheme extends GetxController{
  ThemeMode themeAtual = ThemeMode.system;
  static AppTheme get to => Get.find();
  late SharedPreferences _preferences;

  AppTheme(){
    SharedPreferences.getInstance().then((value) => _preferences=value);
  }



  changeTheme(ThemeMode newTheme){
    themeAtual=newTheme;
    update();
  }

  saveTheme(ThemeMode newTheme){

    //_preferences.setInt("theme", newTh)
  }
}