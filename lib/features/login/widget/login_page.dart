import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hiddify/core/app_info/app_info_provider.dart';
import 'package:hiddify/core/http_client/dio_http_client.dart';
import 'package:hiddify/core/localization/translations.dart';
import 'package:hiddify/features/app_update/notifier/app_update_notifier.dart';
import 'package:hiddify/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hiddify/utils/globals.dart' as globals;
import 'package:hiddify/utils/link_parsers.dart';
import 'package:hiddify/core/router/router.dart';

class LoginPage extends HookConsumerWidget with PresLogger {
  const LoginPage({super.key});
  void initHook() {
    // WidgetsBinding.instance.addObserver(this);

  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);
    final appInfo = ref.watch(appInfoProvider).requireValue;
    final appUpdate = ref.watch(appUpdateNotifierProvider);
    final TextEditingController nameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    // ref.listen(
    //   appUpdateNotifierProvider,
    //   (_, next) async {
    //     if (!context.mounted) return;
    //     switch (next) {
    //       case AppUpdateStateAvailable(:final versionInfo) ||
    //             AppUpdateStateIgnored(:final versionInfo):
    //         return NewVersionDialog(
    //           appInfo.presentVersion,
    //           versionInfo,
    //           canIgnore: false,
    //         ).show(context);
    //       case AppUpdateStateError(:final error):
    //         return CustomToast.error(t.presentShortError(error)).show(context);
    //       case AppUpdateStateNotAvailable():
    //         return CustomToast.success(t.appUpdate.notAvailableMsg)
    //             .show(context);
    //     }
    //   },
    // );

/*    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'TutorialKart',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Sign in',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                //forgot password screen
              },
              child: const Text('Forgot Password',),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Login'),
                  onPressed: () {
                    print(nameController.text);
                    print(passwordController.text);
                  },
                ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Does not have account?'),
                TextButton(
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    //signup screen
                  },
                )
              ],
            ),
          ],
        ),);*/
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'HoloGate 2',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Sign in',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: const TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'User Name',
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: const TextField(
                obscureText: true,
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            // TextButton(
            //   onPressed: () {
            //     //forgot password screen
            //   },
            //   child: const Text('Forgot Password',),
            // ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              margin: const EdgeInsets.all(20),
              child: ElevatedButton(
                child: const Text('Login'),
                onPressed: () {
                  print(nameController.text);
                  print(passwordController.text);
                  RequestServer(context, ref, nameController.text,
                          passwordController.text)
                      .then((value) =>
                          loggy.debug("Auto Region selection finished!"));
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Does not have account?'),
                TextButton(
                  child: const Text(
                    'Sign in',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () async {
                    const ConfigDeviceRoute().push(context);

                    // await UriUtils.tryLaunch(
                    //   Uri.parse(
                    //       "https://shop.hologate.pro/register?type=android"),
                    // );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> RequestServer(
      BuildContext context, WidgetRef ref, user, pass) async {
    // const CustomToast.error("aqqqqq").show(context);
    FocusScope.of(context).unfocus();
    try {
      final DioHttpClient client = DioHttpClient(
          timeout: const Duration(seconds: 10),
          userAgent:
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:123.0) Gecko/20100101 Firefox/123.0",
          debug: true);
      // final response =
      // await client.get<Map<String, dynamic>>('https://shop.hologate.pro/api/login');
      var deviceID = await get_unique_identifier();
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String version = packageInfo.version;
      final String code = packageInfo.buildNumber;
      print("oghab @@@@ count 2*****www   2 " +
          "  -   " +
          version +
          "    ----   " +
          code +
          " unique_id=>" +
          deviceID.toString());
      var device_model = await get_info_device();
      var device_code = await get_info_device();
      var params =
          "?username=${user}&password=${pass}&platform=android&token_fb=null&unique_id=${deviceID}&&device_model=${device_model}&&device_code=${device_code}";
      //  loggy.warning('oghab @@@ params: ${params}');
      print("oghab @@@ params: ${params}");
      var formData = FormData.fromMap({
        'username': user,
        'password': pass,
        'platform': Platform,
        'device_model': device_model,
        'device_code': device_code,
        // 'unique_id': deviceID,
        'is_plus_device': true,

        // 'file': await MultipartFile.fromFile('./text.txt',filename: 'upload.txt')
      });

      final response = await client.post(
          //    'https://shop.hologate.pro/api/login' + params, formData
          //'https://shop.hologate.pro/api/login' , formData
          globals.global_url + '/api/login',
          formData);
      loggy.warning('oghab @@@ response:' + response.toString());
      final jsonData = response.data!;

      if (response.statusCode == 200) {
        //      if(jsonData['success']==true||jsonData['status']==true||jsonData['ok']==true){
        if (jsonData['success'] == true) {
          var access_token = jsonData['access_token']?.toString() ?? "";
          var token_type = jsonData['token_type']?.toString() ?? "";
          var loginUrl = jsonData['login_url']?.toString() ?? "";
          globals.globalCheckGetListServer = true;

          // loggy.debug(
          //   'oghab @@@: ${access_token}   ${token_type} ',
          // );
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          var token = token_type + " " + access_token;
          globals.globalToken = token;
          await prefs.setString('token', token);
          await prefs.setString('url_login', loginUrl);
          // switch(jsonData['accounts'].toString()){
          //   case "buy_account":
          //     CustomToast.error(
          //         jsonData['message']?.toString() ?? "سرور با خطا مواجه شد!!")
          //         .show(context);
          //     break;
          // }
          if ((jsonData['subscription'].toString()) != "null") {
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            await prefs.setString(
                'subscription', jsonData['subscription'].toString());
            print("oghab @@@@ subscription 333  " +
                jsonData['subscription'].toString());

            Navigator.of(context).pop();
          } else if ((jsonData['state'].toString()).isNotEmpty) {
            if ((jsonData['state'].toString()) == "accounts") {
              const ConfigDeviceRoute().push(context);
            } else if ((jsonData['state'].toString()) == "get-devices") {
              const ConfigDeviceRoute2().push(context);
            } else if ((jsonData['state'].toString()) == "get-subscription") {
              // const ConfigDeviceRoute2().push(context);
              SetRequestServer_subScription(context);
              //    Navigator.of(context).popUntil((route) => false);
              // Navigator.of(context).pop();
            }
          }
          //   Navigator.of(context).pop();

          // Navigator.of(context).popUntil(ModalRoute.withName('/'));
          // final regionLocale =
          // _getRegionLocale(jsonData['country_code']?.toString() ?? "");
          //
          // loggy.debug(
          //   'Region: ${regionLocale.region} Locale: ${regionLocale.locale}',
          // );
        } else {
          // CustomToast.error(((jsonData['message']?.toString())!.length > 0)
          //         ? jsonData['message'].toString()
          //         : "سرور با خطا مواجه شد!!")
          //     .show(context);
          CustomToast.error(
              jsonData['message']?.toString() ?? "سرور با خطا مواجه شد!!")
              .show(context);
        }
      } else {
        CustomToast.error(
            jsonData['message']?.toString() ?? "سرور با خطا مواجه شد!!")
            .show(context);
        // CustomToast.error(((jsonData['message']?.toString())!.length > 0)
        //     ? jsonData['message'].toString()
        //     : "سرور با خطا مواجه شد!!")
        //     .show(context);
        loggy.warning('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      CustomToast.error("سرور با خطا مواجه شد!").show(context);

      loggy.warning(
          'Could not get the local country code from ip 22 ' + e.toString());
    }
  }

  Future<void> SetRequestServer_subScription(BuildContext context) async {
    try {
      var deviceID = await get_unique_identifier();

      final DioHttpClient client = DioHttpClient(
          timeout: const Duration(seconds: 10),
          userAgent:
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:123.0) Gecko/20100101 Firefox/123.0",
          debug: true,
          Authorization: globals.globalToken);
      // final response =
      // await client.get<Map<String, dynamic>>('https://shop.hologate.pro/api/login');
      var formData = FormData.fromMap({
        'device_id': null,
        // 'unique_id': deviceID,
        'is_plus_device': true,

        // 'username': user,
        // 'password': pass,
        // 'file': await MultipartFile.fromFile('./text.txt',filename: 'upload.txt')
      });

      var device_model = await get_info_device();
      var device_code = await get_info_device();
      //  var params = "?username=${user}&password=${pass}&platform=android&token_fb=null&unique_id=${deviceID}&&device_model=${device_model}&&device_code=${device_code}";
      // var params =
      //     "?platform=android&token_fb=null&unique_id=${deviceID}&&device_model=${device_model}&&device_code=${device_code}";
      //  loggy.warning('oghab @@@ params: ${params}');
      // print("oghab @@@ params: ${params}");

      final response = await client.post(
          globals.global_url + '/api/accounts/get-subscription', formData);
      if (response.statusCode == 200) {
        globals.globalCheckGetListServer = true;
        globals.globalWaitingGetListServer = true;

        final jsonData = response.data!;
        if (jsonData['subscription'].toString() != 'null') {
          print(
              "oghab @@@ subscriptionrrrrr: ${jsonData['subscription'].toString()}");
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              'subscription', jsonData['subscription'].toString());
          Navigator.of(context).pop();
        } else
          //   Navigator.of(context).popUntil((route) => false);
          Navigator.of(context).pop();
        // Navigator.of(context).popUntil(ModalRoute.withName('/'));
        // final regionLocale =
        // _getRegionLocale(jsonData['country_code']?.toString() ?? "");
        //
        // loggy.debug(
        //   'Region: ${regionLocale.region} Locale: ${regionLocale.locale}',
        // );
      } else {
        loggy.warning('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      loggy.warning('Could not get the local country code from ip');
    }
  }
}
