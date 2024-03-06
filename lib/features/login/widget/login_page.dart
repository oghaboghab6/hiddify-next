import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hiddify/core/app_info/app_info_provider.dart';
import 'package:hiddify/core/http_client/dio_http_client.dart';
import 'package:hiddify/core/localization/translations.dart';
import 'package:hiddify/features/app_update/notifier/app_update_notifier.dart';
import 'package:hiddify/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hiddify/utils/globals.dart' as globals;

class LoginPage extends HookConsumerWidget with PresLogger {
  const LoginPage({super.key});

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
                  'HoloGate',
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
                  RequestServer(context,ref,nameController.text,passwordController.text).then((value) =>
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
                  onPressed: () {
                    //signup screen
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> RequestServer(BuildContext context,WidgetRef ref, user, pass) async {
    try {
      final DioHttpClient client = DioHttpClient(
          timeout: const Duration(seconds: 2),
          userAgent:
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:123.0) Gecko/20100101 Firefox/123.0",
          debug: true);
      // final response =
      // await client.get<Map<String, dynamic>>('https://shop.hologate.pro/api/login');
      var formData = FormData.fromMap({
        'username': user,
        'password': pass,
        // 'file': await MultipartFile.fromFile('./text.txt',filename: 'upload.txt')
      });
      final response =
          await client.post('https://shop.hologate.pro/api/login', formData);
      if (response.statusCode == 200) {
        globals.globalCheckGetListServer=true;

        final jsonData = response.data!;
        var access_token=jsonData['access_token']?.toString() ?? "";
        var token_type=jsonData['token_type']?.toString() ?? "";
        // loggy.debug(
        //   'oghab @@@: ${access_token}   ${token_type} ',
        // );
       final SharedPreferences prefs = await SharedPreferences.getInstance();
       var token=token_type +" "+access_token;
        globals.globalToken=token;
       await prefs.setString('token', token);
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
