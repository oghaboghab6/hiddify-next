import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hiddify/bootstrap.dart';
import 'package:hiddify/core/model/environment.dart';
import 'package:hiddify/utils/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  if(!Platform.isWindows){
    if (Platform.isAndroid) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      await Firebase.initializeApp();
    }
    //
  }


  final prefs = await SharedPreferences.getInstance();

  var base_url = await prefs.getString("base_url");
  // if (base_url.isNotNullOrEmpty) {
  //   global_url = base_url!;
  // }
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  return lazyBootstrap(widgetsBinding, Environment.dev);
}
