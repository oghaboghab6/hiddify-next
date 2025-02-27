import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

final TextEditingController nameController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class LoginPage extends StatefulHookConsumerWidget {
  //const LoginPage(this.child, {super.key});
  const LoginPage({super.key});

  //final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConnectionWrapperState();
}

class _ConnectionWrapperState extends ConsumerState<LoginPage> with PresLogger {
  bool checked = true;

  // const LoginPage({super.key});

/*  void initHook() {
    // WidgetsBinding.instance.addObserver(this);

  }*/
  late final FirebaseAuth _auth;

  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    final t = ref.watch(translationsProvider);
    final appInfo = ref.watch(appInfoProvider).requireValue;
    final appUpdate = ref.watch(appUpdateNotifierProvider);

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
    Future<void> SetRequestServer_subScription(BuildContext context) async {
      try {
        var deviceID = await get_unique_identifier();

        final DioHttpClient client = DioHttpClient(
            timeout: const Duration(seconds: 30),
            userAgent:
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:123.0) Gecko/20100101 Firefox/123.0",
            debug: true,
            Authorization: globals.globalTokenTemporary);
        // final response =
        // await client.get<Map<String, dynamic>>('https://shop.hologate.pro/api/login');
        var formData = FormData.fromMap({
          'device_id': null,
          'unique_id': deviceID,
          'is_plus_device': true,
          'token_fb': globals.globalTokenFB,
          'platform': Platform.operatingSystem,

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
          final jsonData = response.data!;

          if (jsonData['success'] == true) {
            globals.globalCheckGetListServer = true;
            globals.globalWaitingGetListServer = true;

            final SharedPreferences prefs = await SharedPreferences.getInstance();
            globals.globalToken = globals.globalTokenTemporary;
            await prefs.setString('token', globals.globalTokenTemporary);
            if (jsonData['subscription'].toString() != 'null') {
              print(
                  "oghab @@@ subscriptionrrrrr: ${jsonData['subscription'].toString()}");
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              await prefs.setString(
                  'subscription', jsonData['subscription'].toString());
              Navigator.of(context).pop();
            } else
              CustomToast.error(
                  jsonData['message']?.toString() ?? "هیچ اطلاعاتی از سرور دریافت نشد!!")
                  .show(context);
              //   Navigator.of(context).popUntil((route) => false);
              // Navigator.of(context).pop();
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
          CustomToast.error("سرور با خطا مواجه شد!").show(context);

          loggy.warning('Request failed with status: ${response.statusCode}');
        }
      } catch (e) {
        CustomToast.error("سرور با خطا مواجه شد!").show(context);

        loggy.warning('Could not get the local country code from ip');
      }
    }

    Future<void> RequestServer(
        BuildContext context, WidgetRef ref, user, pass) async {
      isLoading.value = true;
      // const CustomToast.error("aqqqqq").show(context);
      FocusScope.of(context).unfocus();
      try {
        final DioHttpClient client = DioHttpClient(
            timeout: const Duration(seconds: 30),
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
        print("oghab @@@ params: ${Platform.operatingSystem}  ${params} ${globals.globalTokenFB}");
        var formData = FormData.fromMap({
          'username': user,
          'password': pass,
          'platform': Platform.operatingSystem,
          'device_model': device_model,
          'device_code': device_code,
          'unique_id': deviceID,
          'is_plus_device': true,
          'token_fb': globals.globalTokenFB,

          // 'file': await MultipartFile.fromFile('./text.txt',filename: 'upload.txt')
        });

        final response = await client.post(
            //    'https://shop.hologate.pro/api/login' + params, formData
            //'https://shop.hologate.pro/api/login' , formData
            globals.global_url + '/api/login',
            formData);
        loggy.warning('oghab @@@ response:' + response.toString());
        final jsonData = response.data!;
        isLoading.value = false;

        if (response.statusCode == 200) {
          final SharedPreferences prefs =
          await SharedPreferences.getInstance();
          //      if(jsonData['success']==true||jsonData['status']==true||jsonData['ok']==true){
          if (jsonData['success'] == true) {
            var access_token = jsonData['access_token']?.toString() ?? "";
            var token_type = jsonData['token_type']?.toString() ?? "";
          //  var loginUrl = jsonData['login_url']?.toString() ?? "";
            var loginUrl = jsonData['login_url_no_domain']?.toString() ?? "";
            var tokenWeb = jsonData['web_token']?.toString() ?? "";
            globals.tokenWeb=tokenWeb;
            await prefs.setString('web_token', tokenWeb);

            // globals.globalCheckGetListServer = true;

            // loggy.debug(
            //   'oghab @@@: ${access_token}   ${token_type} ',
            // );

            var token = token_type + " " + access_token;
            globals.globalTokenTemporary = token;
            // globals.globalToken = token;
            // await prefs.setString('token', token);
            globals.urlLink=loginUrl;
            await prefs.setString('url_login', loginUrl);
            // switch(jsonData['accounts'].toString()){
            //   case "buy_account":
            //     CustomToast.error(
            //         jsonData['message']?.toString() ?? "سرور با خطا مواجه شد!!")
            //         .show(context);
            //     break;
            // }
            if ((jsonData['subscription'].toString()) != "null") {
              SetRequestServer_subScription(context);
              // final SharedPreferences prefs =
              //     await SharedPreferences.getInstance();
              // await prefs.setString(
              //     'subscription', jsonData['subscription'].toString());
              // print("oghab @@@@ subscription 333  " +
              //     jsonData['subscription'].toString());
              //
              // Navigator.of(context).pop();
            } else if ((jsonData['state'].toString()).isNotEmpty) {
              if ((jsonData['state'].toString()) == "accounts") {
                const ConfigDeviceRoute().push(context);
              } else if ((jsonData['state'].toString()) == "get-devices") {
                globals.globalCheckDevice = true;
                const ConfigDeviceRoute2().push(context);
              } else if ((jsonData['state'].toString()) == "get_mc_group") {
                globals.global_subscription_id =
                    jsonData['subscription_id'].toString();
                const ConfigLocationRoute().push(context);
              } else if ((jsonData['state'].toString()) == "no_account") {

                const ConfigNoAccountRoute().push(context);
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
            loggy.warning(
                'Request failed with status111: ${response.statusCode}');

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
        isLoading.value = false;

        CustomToast.error("سرور با خطا مواجه شد!").show(context);

        loggy.warning(
            'Could not get the local country code from ip 22 ' + e.toString());
      }
    }


    Future<void> RegisterRequestServer(
        BuildContext context, WidgetRef ref, email, name,id) async {
      isLoading.value = true;
      // const CustomToast.error("aqqqqq").show(context);
      FocusScope.of(context).unfocus();
      try {
        final DioHttpClient client = DioHttpClient(
            timeout: const Duration(seconds: 30),
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
        var token_static = "rbebXDj0vIEvPu6ogM69rtvSOwF8QcsCO2oMpKV2FElkr9BksNzvY14zgipNWUjS";
        var params =
            "?email=${email}&id=${id}&token=${token_static}&platform=android&token_fb=null&unique_id=${deviceID}&&device_model=${device_model}&&device_code=${device_code}";
        //  loggy.warning('oghab @@@ params: ${params}');
        print("oghab @@@ params: ${Platform.operatingSystem}  ${params} ${globals.globalTokenFB}");
        var formData = FormData.fromMap({
          'email': email,
          'id': id,
          'name': name,
          'token': token_static,
          'platform': Platform.operatingSystem,
          'device_model': device_model,
          'device_code': device_code,
          'unique_id': deviceID,
          'is_plus_device': true,
          'token_fb': globals.globalTokenFB,

          // 'file': await MultipartFile.fromFile('./text.txt',filename: 'upload.txt')
        });

        final response = await client.post(
          //    'https://shop.hologate.pro/api/login' + params, formData
          //'https://shop.hologate.pro/api/login' , formData
            globals.global_url + '/api/login-with-google',
            formData);
        loggy.warning('oghab @@@ response:' + response.toString());
        final jsonData = response.data!;
        isLoading.value = false;

        if (response.statusCode == 200) {
          final SharedPreferences prefs =
          await SharedPreferences.getInstance();
          //      if(jsonData['success']==true||jsonData['status']==true||jsonData['ok']==true){
          if (jsonData['success'] == true) {
            var access_token = jsonData['access_token']?.toString() ?? "";
            var token_type = jsonData['token_type']?.toString() ?? "";
            //  var loginUrl = jsonData['login_url']?.toString() ?? "";
            var loginUrl = jsonData['login_url_no_domain']?.toString() ?? "";
            var tokenWeb = jsonData['web_token']?.toString() ?? "";
            globals.tokenWeb=tokenWeb;
            await prefs.setString('web_token', tokenWeb);
            // globals.globalCheckGetListServer = true;

            // loggy.debug(
            //   'oghab @@@: ${access_token}   ${token_type} ',
            // );

            var token = token_type + " " + access_token;
            globals.globalTokenTemporary = token;
            // globals.globalToken = token;
            // await prefs.setString('token', token);
            globals.urlLink=loginUrl;
            await prefs.setString('url_login', loginUrl);
            // switch(jsonData['accounts'].toString()){
            //   case "buy_account":
            //     CustomToast.error(
            //         jsonData['message']?.toString() ?? "سرور با خطا مواجه شد!!")
            //         .show(context);
            //     break;
            // }
            if ((jsonData['subscription'].toString()) != "null") {
              SetRequestServer_subScription(context);
              // final SharedPreferences prefs =
              //     await SharedPreferences.getInstance();
              // await prefs.setString(
              //     'subscription', jsonData['subscription'].toString());
              // print("oghab @@@@ subscription 333  " +
              //     jsonData['subscription'].toString());
              //
              // Navigator.of(context).pop();
            } else if ((jsonData['state'].toString()).isNotEmpty) {
              if ((jsonData['state'].toString()) == "accounts") {
                const ConfigDeviceRoute().push(context);
              } else if ((jsonData['state'].toString()) == "get-devices") {
                globals.globalCheckDevice = true;
                const ConfigDeviceRoute2().push(context);
              } else if ((jsonData['state'].toString()) == "get_mc_group") {
                globals.global_subscription_id =
                    jsonData['subscription_id'].toString();
                const ConfigLocationRoute().push(context);
              } else if ((jsonData['state'].toString()) == "no_account") {

                const ConfigNoAccountRoute().push(context);
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
            loggy.warning(
                'Request failed with status111: ${response.statusCode}');

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
        isLoading.value = false;

        CustomToast.error("سرور با خطا مواجه شد!").show(context);

        loggy.warning(
            'Could not get the local country code from ip 22 ' + e.toString());
      }
    }
    Future<void> signInWithGoogle(BuildContext context) async {
      try {
        if (kIsWeb) {
          GoogleAuthProvider googleProvider = GoogleAuthProvider();

          googleProvider
              .addScope('https://www.googleapis.com/auth/contacts.readonly');

          await _auth.signInWithPopup(googleProvider);
        } else {
          print("oghab @@@ params: 000UserCredential");

          final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

          final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
          print("oghab @@@ params: UserCredential ${googleUser}");
          print("oghab @@@ params: UserCredential email:   ${googleUser?.email}");
          if(googleUser!=null){

            RegisterRequestServer(context, ref, googleUser?.email,
                googleUser?.displayName,googleUser?.id);
          }
          else{
            CustomToast.error("مشکلی پیش آمد شما می توانید اکانت خود را از طریق سایت بسازید و با نام کاربری و رمزعبور وارد اپلیکشن شوید دو ثانیه دیگر به سایت هدایت می شوید");

            Future.delayed(const Duration(milliseconds: 2500),() async {
              await UriUtils.tryLaunch(
                Uri.parse(
                    globals.global_url+"/register?type=android"),
              );

            });
          }

          if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
            // Create a new credential
            final credential = GoogleAuthProvider.credential(
              accessToken: googleAuth?.accessToken,
              idToken: googleAuth?.idToken,
            );
            UserCredential userCredential =
            await _auth.signInWithCredential(credential);

            print("oghab @@@ params: UserCredential $UserCredential");
            // if you want to do specific task like storing information in firestore
            // only for new users using google sign in (since there are no two options
            // for google sign in and google sign up, only one as of now),
            // do the following:

            // if (userCredential.user != null) {
            //   if (userCredential.additionalUserInfo!.isNewUser) {}
            // }
          }
        }
      } on FirebaseAuthException catch (e) {

        print("oghab @@@ FirebaseAuthException: 000UserCredential $e");
       // CustomToast.error("مشکلی پیش آمد شما می توانید اکانت خود را از طریق سایت بسازید و با نام کاربری و رمزعبور وارد اپلیکشن شوید دو ثانیه دیگر به سایت هدایت می شوید");
        CustomToast.error("مشکلی پیش آمد چند لحظه صبر نمایید و مجددا تلاش نمایید");
        // Future.delayed(const Duration(milliseconds: 2500),() async {
        //   await UriUtils.tryLaunch(
        //     Uri.parse(
        //         globals.global_url+"/register?type=android"),
        //   );
        //
        // });
        //  showSnackBar(context, e.message!); // Displaying the error message
      }
    }
    return Scaffold(
        appBar: AppBar(title: const Text('ورود')),

        body: isLoading.value && false
            ? Container(
                width: MediaQuery.of(context).size.width,

                //  color: Colors.pink,
                padding: const EdgeInsets.all(10),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text('please wait. loading ...')),
                    CircularProgressIndicator()
                  ],
                ),
              )
            : Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView(
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              t.general.appTitle,
                              style: TextStyle(
                                  color:  Color(0xffea5555),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 30),
                            )),
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            child: const Text(
                              'ورود',
                              style: TextStyle(fontSize: 20),
                            )),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'نام کاربری',
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: TextField(
                            obscureText: true,
                            controller: passwordController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'رمز عبور',
                            ),
                          ),
                        ),
                        Container(
                            child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Checkbox(
                                value: checked,
                                onChanged: (changedValue) {
                                  setState(() {
                                    checked = changedValue!;
                                  });
                                }),
                            const Text("مرا بخاطر بسپار"),
                          ],
                        )),
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
                            child: const Text('ورود',style: TextStyle(color: Colors.white, fontSize: 18),),

                            onPressed: () async {
                              print(nameController.text);
                              print(passwordController.text);
                              final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                              await prefs.setString(
                                  'username', nameController.text);
                              globals.globalUsername = nameController.text;

                              if (checked) {
                                await prefs.setString(
                                    'password', passwordController.text);
                              }

                              RequestServer(context, ref, nameController.text,
                                      passwordController.text)
                                  .then((value) => loggy.debug(
                                      "Auto Region selection finished!"));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:  Color(0xffea5555), // This is what you need!
                            ),
                          ),
                        ),

                        if(!Platform.isWindows)
                        Container(
                          height: 50,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          margin: const EdgeInsets.only(right: 20,left: 20,bottom: 20),
                          child: ElevatedButton(
                         //   child: const Text('ورود از طریق جیمیل',style: TextStyle(color: Colors.white, fontSize: 18),),
                            onPressed: () async {
                              signInWithGoogle(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:  Color(0xffea5555), // This is what you need!
                            ),
                         //   child: const Text('ورود از طریق جیمیل',style: TextStyle(color: Colors.white, fontSize: 18),),
                            child: Row(

                               mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(width: 20),
                                const Text('ورود با جیمیل',style: TextStyle(color: Colors.white, fontSize: 18),),
                                TextButton(
                                  // child: Text(
                                  //   'ثبت نام',
                                  //   //t.settings.general.locale,
                                  //   style: const TextStyle(fontSize: 20),
                                  // ),
                                  child:  const Image( height: 40,width: 40,image: AssetImage('assets/images/gmail.png')),
                                  onPressed: () async {
                                    // const ConfigDeviceRoute().push(context);
                                    //  const LoginEmailRoute().push(context);
                                    signInWithGoogle(context);
                                    // await UriUtils.tryLaunch(
                                    //   Uri.parse(
                                    //       globals.global_url+"/register?type=android"),
                                    // );
                                  },
                                ),
                                SizedBox(width: 20),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 50,
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          margin: const EdgeInsets.only(right: 20,left: 20),
                          child: ElevatedButton(
                            child: const Text('ورود از طریق کانفیگ پلاس',style: TextStyle(color: Colors.white, fontSize: 18),),

                            onPressed: () async {
                              const LoginConfigRoute().push(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:  Color(0xffea5555), // This is what you need!
                            ),
                          ),
                        ),
                        Row(

                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(width: 20),
                            const Text('آیا حساب کاربری ندارید؟'),
                            TextButton(
                              child: Text(
                                ' ثبت نام ',
                                //t.settings.general.locale,
                                style: const TextStyle(fontSize: 20),
                              ),
                              onPressed: () async {
                                // const ConfigDeviceRoute().push(context);
                               const LoginEmailRoute().push(context);
                                // signInWithGoogle(context);
                                // await UriUtils.tryLaunch(
                                //   Uri.parse(
                                //       globals.global_url+"/register?type=android"),
                                // );
                              },
                            ),
                            SizedBox(width: 20),
                          ],
                        ),
                        // Row(
                        //
                        //   // mainAxisAlignment: MainAxisAlignment.center,
                        //   children: <Widget>[
                        //     SizedBox(width: 20),
                        //     const Text('ورود/ثبت نام با جیمیل'),
                        //     TextButton(
                        //       // child: Text(
                        //       //   'ثبت نام',
                        //       //   //t.settings.general.locale,
                        //       //   style: const TextStyle(fontSize: 20),
                        //       // ),
                        //         child:  const Image( height: 40,width: 40,image: AssetImage('assets/images/gmail.png')),
                        //       onPressed: () async {
                        //         // const ConfigDeviceRoute().push(context);
                        //      //  const LoginEmailRoute().push(context);
                        //          signInWithGoogle(context);
                        //         // await UriUtils.tryLaunch(
                        //         //   Uri.parse(
                        //         //       globals.global_url+"/register?type=android"),
                        //         // );
                        //       },
                        //     ),
                        //     SizedBox(width: 20),
                        //   ],
                        // ),
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(width: 20),
                            const Text('رمز عبور خودرا فراموش کرده‌اید؟'),
                            TextButton(
                              child: Text(
                                'کلیک نمایید',
                                //t.settings.general.locale,
                                style: const TextStyle(fontSize: 20),
                              ),
                              onPressed: () async {
                                // const ConfigDeviceRoute().push(context);
                                // const ConfigDeviceRoute2().push(context);

                                await UriUtils.tryLaunch(
                                  Uri.parse(
                                      globals.global_url+"/forget-password"),
                                );
                              },
                            ),
                            SizedBox(width: 20),

                          ],
                        ),
               /*         Row(
                          //mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(width: 20),
                            const Text('ورود از طریق مشخصات کانفیگ'),
                            TextButton(
                              child: Text(
                                'کلیک نمایید',
                                //t.settings.general.locale,
                                style: const TextStyle(fontSize: 20),
                              ),
                              onPressed: () async {
                                const LoginConfigRoute().push(context);
                                // const ConfigDeviceRoute2().push(context);

                                // await UriUtils.tryLaunch(
                                //   Uri.parse(
                                //       globals.global_url+"/forget-password"),
                                // );
                              },
                            ),
                            SizedBox(width: 20),

                          ],
                        ),*/
                        /*             Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: MediaQuery.of(context).size.width,

                        //  color: Colors.pink,
                        padding: const EdgeInsets.all(10),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text('please wait. loading ...')),
                            CircularProgressIndicator()
                          ],
                        ),
                      )),*/
                      ],
                    ),
                  ),
                  if (isLoading.value)
                    Positioned(
                        left: 0.0,
                        right: 0.0,
                        bottom: 0.0,
                        top: 0.0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black.withOpacity(0.6),
                          //  color: Colors.pink,
                          padding: const EdgeInsets.all(10),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text('لطفا صبر نمایید ...')),
                              CircularProgressIndicator()
                            ],
                          ),
                        ))
                ],
              )
    );
  }

  @override
  void initState()  {
    super.initState();
    doSomeAsyncStuff();

  }
  Future<void> doSomeAsyncStuff() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    nameController.text = (await prefs.getString('username'))!;
    passwordController.text = (await prefs.getString('password'))!;
  }

}

/*class LoginPage extends HookConsumerWidget with PresLogger {
  const LoginPage({super.key});

*/ /*  void initHook() {
    // WidgetsBinding.instance.addObserver(this);

  }*/ /*

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool checked = true;

    final isLoading = useState(false);
    final t = ref.watch(translationsProvider);
    final appInfo = ref.watch(appInfoProvider).requireValue;
    final appUpdate = ref.watch(appUpdateNotifierProvider);

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

*/ /*    return Padding(
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
        ),);*/ /*
    Future<void> SetRequestServer_subScription(BuildContext context) async {
      try {
        var deviceID = await get_unique_identifier();

        final DioHttpClient client = DioHttpClient(
            timeout: const Duration(seconds: 30),
            userAgent:
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:123.0) Gecko/20100101 Firefox/123.0",
            debug: true,
            Authorization: globals.globalToken);
        // final response =
        // await client.get<Map<String, dynamic>>('https://shop.hologate.pro/api/login');
        var formData = FormData.fromMap({
          'device_id': null,
          'unique_id': deviceID,
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
          final jsonData = response.data!;

          if (jsonData['success'] == true) {
            globals.globalCheckGetListServer = true;
            globals.globalWaitingGetListServer = true;

            if (jsonData['subscription'].toString() != 'null') {
              print(
                  "oghab @@@ subscriptionrrrrr: ${jsonData['subscription'].toString()}");
              final SharedPreferences prefs =
              await SharedPreferences.getInstance();
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
            // CustomToast.error(((jsonData['message']?.toString())!.length > 0)
            //         ? jsonData['message'].toString()
            //         : "سرور با خطا مواجه شد!!")
            //     .show(context);
            CustomToast.error(
                jsonData['message']?.toString() ?? "سرور با خطا مواجه شد!!")
                .show(context);
          }


        } else {
          CustomToast.error("سرور با خطا مواجه شد!").show(context);

          loggy.warning('Request failed with status: ${response.statusCode}');
        }
      } catch (e) {
        CustomToast.error("سرور با خطا مواجه شد!").show(context);

        loggy.warning('Could not get the local country code from ip');
      }
    }

    Future<void> RequestServer(
        BuildContext context, WidgetRef ref, user, pass) async {
      isLoading.value = true;
      // const CustomToast.error("aqqqqq").show(context);
      FocusScope.of(context).unfocus();
      try {
        final DioHttpClient client = DioHttpClient(
            timeout: const Duration(seconds: 30),
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
          'platform': Platform.operatingSystem,
          'device_model': device_model,
          'device_code': device_code,
          'unique_id': deviceID,
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
        isLoading.value = false;

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
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
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
                globals.globalCheckDevice=true;
                const ConfigDeviceRoute2().push(context );

              }   else if ((jsonData['state'].toString()) == "get_mc_group") {
                globals.global_subscription_id=jsonData['subscription_id'].toString();
                const ConfigLocationRoute().push(context );

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
            loggy.warning('Request failed with status111: ${response.statusCode}');

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
        isLoading.value = false;

        CustomToast.error("سرور با خطا مواجه شد!").show(context);

        loggy.warning(
            'Could not get the local country code from ip 22 ' + e.toString());
      }
    }

    return Scaffold(
        body: isLoading.value && false
            ? Container(
                width: MediaQuery.of(context).size.width,

                //  color: Colors.pink,
                padding: const EdgeInsets.all(10),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text('please wait. loading ...')),
                    CircularProgressIndicator()
                  ],
                ),
              )
            : Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView(
                      children: <Widget>[
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'HoloGate 2  ',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 30),
                            )),
                        Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(10),
                            child: const Text(
                              'ورود',
                              style: TextStyle(fontSize: 20),
                            )),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'نام کاربری',
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: TextField(
                            obscureText: true,
                            controller: passwordController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'رمز عبور',
                            ),
                          ),
                        ),
                        Container(
                          child:  Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Checkbox(
                                  value: checked,
                                  onChanged: (changedValue){
                                    setState(() {
                                      checked = changedValue!;
                                    });
                                  }
                              ),
                              const Text("مرا بخاطر بسپار"),

                            ],
                        )
                        )
                          ,
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
                            child: const Text('ورود'),
                            onPressed: () {
                              print(nameController.text);
                              print(passwordController.text);
                              RequestServer(context, ref, nameController.text,
                                      passwordController.text)
                                  .then((value) => loggy.debug(
                                      "Auto Region selection finished!"));
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text('آیا حساب کاربری ندارید؟'),
                            TextButton(
                              child:  Text(
                                'ثبت نام',
                                //t.settings.general.locale,
                                style: const TextStyle(fontSize: 20),
                              ),
                              onPressed: () async {
                                // const ConfigDeviceRoute().push(context);
                                const ConfigDeviceRoute2().push(context );

                                // await UriUtils.tryLaunch(
                                //   Uri.parse(
                                //       "https://shop.hologate.pro/register?type=android"),
                                // );
                              },
                            )
                          ],
                        ),
                        */ /*             Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: MediaQuery.of(context).size.width,

                        //  color: Colors.pink,
                        padding: const EdgeInsets.all(10),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text('please wait. loading ...')),
                            CircularProgressIndicator()
                          ],
                        ),
                      )),*/ /*
                      ],
                    ),
                  ),
                  if (isLoading.value)
                    Positioned(
                        left: 0.0,
                        right: 0.0,
                        bottom: 0.0,
                        top: 0.0,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          color: Colors.black.withOpacity(0.6),
                          //  color: Colors.pink,
                          padding: const EdgeInsets.all(10),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text('لطفا صبر نمایید ...')),
                              CircularProgressIndicator()
                            ],
                          ),
                        ))
                ],
              ));
  }
}*/
