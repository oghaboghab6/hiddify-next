import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dartx/dartx.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:package_info_plus/package_info_plus.dart';

// import 'package:firebase_core/firebase_core.dart';
import 'package:dio/dio.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hiddify/core/app_info/app_info_provider.dart';
import 'package:hiddify/core/http_client/dio_http_client.dart';
import 'package:hiddify/core/localization/translations.dart';
import 'package:hiddify/core/model/failures.dart';
import 'package:hiddify/core/router/router.dart';
import 'package:hiddify/features/common/nested_app_bar.dart';
import 'package:hiddify/features/home/widget/connection_button.dart';
import 'package:hiddify/features/home/widget/empty_profiles_home_body.dart';
import 'package:hiddify/features/profile/notifier/active_profile_notifier.dart';
import 'package:hiddify/features/profile/notifier/profile_notifier.dart';
// import 'package:hiddify/features/profile/widget/profile_tile.dart';
import 'package:hiddify/features/proxy/active/active_proxy_delay_indicator.dart';
import 'package:hiddify/features/proxy/active/active_proxy_footer.dart';
import 'package:hiddify/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:hiddify/utils/globals.dart' as globals;
import 'package:firebase_messaging/firebase_messaging.dart';

// import 'dart:async';
import '../../../core/analytics/analytics_controller.dart';
import '../../../messaging_service.dart';
import '../../../singbox/model/singbox_config_enum.dart';
import '../../../utils/globals.dart';

// import '../../config_option/model/config_option_entity.dart';
// import '../../config_option/notifier/config_option_notifier.dart';
import '../../connection/data/connection_data_providers.dart';
import '../../connection/data/connection_repository.dart';
import '../../connection/notifier/connection_notifier.dart';
// import '../../connection/widget/experimental_feature_notice.dart';
import '../../profile/overview/profiles_overview_notifier.dart';

// import 'io.flutter.plugin.common.PluginRegistry';
// import 'io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback';
// import 'io.flutter.plugins.GeneratedPluginRegistrant';
// import 'io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService';
final List items = [
  {'title': 'Meeting with John', 'date': '2025-01-10'},
  {'title': 'Project Deadline', 'date': '2025-01-15'},
  {'title': 'Call with Client', 'date': '2025-01-20'},
];

class HomePage extends HookConsumerWidget with PresLogger {
  // bool checkGetListServer = true;

  const HomePage({super.key});

  // main() {
  //   print('@@@@@ mainnnnn');
  //
  // }

  void funnc() {
    // print("oghab @@@@ yyyyyyyyyyyyyy ");
    //return true;
  }

  @override
  // Method to load the shared preference data
  Future<String> _loadPreferences(
      BuildContext context,
      WidgetRef ref,
      AutoDisposeNotifierProvider<AddProfile, AsyncValue<Unit?>>
          addProfileProvider,
      dynamic deleteProfileMutation) async {
    final prefs = await SharedPreferences.getInstance();
    globals.urlLink = prefs.getString('url_login') ?? '';
    // globals.urlLink = prefs.getString('url_login') ?? globals.global_url;
    globals.globalToken = prefs.getString('token') ?? '';
    globals.globalUsername = prefs.getString('config') != null
        ? ''
        : prefs.getString('username') ?? '';
    globals.globalPassword = prefs.getString('password') ?? '';
    print("oghab @@@@ 0 token " + globals.globalToken.toString());
    // print("oghab @@@@ 0 globalCheckGetListServer " +
    //     globals.globalCheckGetListServer.toString());
    if (globals.globalToken == '') {
      // const LoginRoute().push(context).then((data){
      //   print("oghab @@@@ ppppppp1 " + globals.globalToken.toString());
      //   if (globals.globalCheckGetListServer)
      //     GetListAccountServer(context, ref, addProfileProvider);
      //   // then will return value when the loginscreen's pop is called.
      // });
    } else {
      if (globals.globalCheckGetListServer)
        GetListAccountServer(
            context, ref, addProfileProvider, deleteProfileMutation);
    }
    return globals.globalToken;
  }

  void _requestPermission(BuildContext context) async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    CustomToast.error("dfgdfgdf").show(context);
    final NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      print(await FirebaseMessaging.instance.getToken());
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void initHook(BuildContext context) {
    //super.initHook();
   // print("@@@@@?????");
    // CustomToast.error(
    //     "rrrrrrr")
    //     .show(context);
    // _requestPermission(context);
    // WidgetsBinding.instance.addObserver(this);
  }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  // }
  //
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   print("app state now is $state");
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoadingSubscription = useState(false);
    final isLoadingExit = useState(false);
    final device_name = useState("");
    final count_device = useState("");
    final date_account = useState("");
    final volume_account = useState("");
    final connectionStatus = ref.watch(connectionNotifierProvider);

    // useEffect(
    //       () {
    //
    //
    //         final device_name = useState("");
    //         final count_device = useState("");
    //         final date_account = useState("");
    //         final volume_account = useState("");
    //     return null;
    //
    //   },
    //   [],
    // );

    final ConnectionRepository _connectionRepo =
        ref.read(connectionRepositoryProvider);
    final token = '';
    final t = ref.watch(translationsProvider);
    final deleteProfileMutation = useMutation(
      initialOnFailure: (err) {
        CustomAlertDialog.fromErr(t.presentError(err)).show(context);
      },
    );
    // final deleteProfileMutation = useMutation(
    //   initialOnFailure: (err) {
    //     CustomAlertDialog.fromErr(t.presentError(err)).show(context);
    //   },
    // );
    // deleteProfileMutation.setFuture(
    //   ref
    //       .read(profilesOverviewNotifierProvider.notifier)
    //       .deleteAllProfile(),
    // );
    // final addProfileState =
    // ref.watch(globals.globalToken );

    // ref.listen(
    //   globals.globalToken,
    //   (previous, next) {
    //     print("oghab @@@@ 1 ");
    //
    //   },
    // );
    print("oghab @@@@ ###### token " + globals.globalToken.toString());

    String token1 = "";
    // final token1 = _loadPreferences(
    //     context, ref, addProfileProvider, deleteProfileMutation);
    // print("oghab @@@@ 1 " + token.toString());
    //final eeeeee = ref.watch(funnc() as ProviderListenable);
    final hasAnyProfile = ref.watch(hasAnyProfileProvider);
    final activeProfile = ref.watch(activeProfileProvider);
    final asyncProfiles = ref.watch(profilesOverviewNotifierProvider);
    final addProfileState = ref.watch(addProfileProvider);
    final connect_disconnectProfile =
        ref.read(connectionNotifierProvider.notifier);

    disableAnalytics(ref);

    if (asyncProfiles case AsyncData(value: final links)) {
      // print("oghab @@@@ count ******" + links.length.toString());
    }
    // switch (asyncProfiles) {
    //   AsyncData(value: final profiles) => var dd=1,
    //   AsyncError(:final error) =>var dd=2,
    //   AsyncLoading() =>var dd=3,
    // }
    // print("oghab @@@@" + asyncProfiles.length);
    Future<void> getInformationServer(BuildContext context) async {
      var statusVpn = "";

      if (connectionStatus case AsyncData(:final value)) {
        if (value.isConnected) {
          statusVpn = "connect";
        } else {
          statusVpn = "disconnect";
        }
        //  status_vpn=value as String;
      }

      // switch (connectionStatus) {
      //   case AsyncData(value: final status):
      //     status_vpn=status as String;
      // }
      try {
        var deviceID = await get_unique_identifier();

        final DioHttpClient client = DioHttpClient(
            timeout: const Duration(seconds: 30),
            userAgent:
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:123.0) Gecko/20100101 Firefox/123.0",
            debug: true,
            Authorization: globals.globalToken);

        var formData = FormData.fromMap({
          'unique_id': deviceID,
          'is_plus_device': true,
          'connectionStatus': statusVpn,
          'token_fb': globals.globalTokenFB,
          'platform': Platform.operatingSystem,
        });

        final response = await client.post(
            globals.global_url + '/api/accounts/device-permission', formData);
        if (response.statusCode == 200) {
          final SharedPreferences prefs =
          await SharedPreferences.getInstance();
          final jsonData = response.data!;
          print( jsonData);
          if (jsonData['success'] == true) {
            device_name.value = jsonData['username'].toString() ?? '';
            count_device.value = jsonData['number_of_devices'].toString() ?? '';
            date_account.value = jsonData['expiration_date'].toString() ?? '';
            volume_account.value = jsonData['traffic'].toString() ?? '';
            globalBanner = jsonData['banner']?.toString() ?? "";
            globalUnreadNotificationCount = jsonData['unread_notification_count']?.toString() ?? "20";
            globalClickBanner = jsonData['banner_click']?.toString() ?? "";

            var subscription_id = jsonData['subscription_id']?.toString() ?? '';
            prefs.setString('subscription_id', subscription_id);
            globals.global_subscription_id = subscription_id;
            var loginUrl = jsonData['login_url_no_domain']?.toString() ?? "";
            if (loginUrl.isNotNullOrEmpty) {

              globals.urlLink = loginUrl;
              await prefs.setString('url_login', loginUrl);
            }
            var tokenWeb = jsonData['web_token']?.toString() ?? "";
            if (tokenWeb.isNotNullOrEmpty) {

              globals.tokenWeb=tokenWeb;
              await prefs.setString('web_token', tokenWeb);
            }
          } else {
            loggy
                .warning('Request failed with status2: ${response.statusCode}');
          }
        } else {
          loggy.warning('Request failed with status: ${response.statusCode}');
        }
      } catch (e) {
        loggy.warning('Could not get the local country code from ip');
      }
    }

    void goScreenLogin() {
      const LoginRoute().push(context).then((data) async {
        print(
            "oghab @@@@ ppppppp2 ${globals.globalToken} ${globals.globalCheckGetListServer}");
        if (globals.globalCheckGetListServer == true) {
          GetListAccountServer(
            context,
            ref,
            addProfileProvider,
            deleteProfileMutation,
          );
          getInformationServer(context);

          CustomToast.success("در حال ساختن  اکانت لطفا صبر نمایید")
              .show(context);
          isLoadingSubscription.value = true;
          globals.globalIsLoadingSubscription = true;
          await Future.delayed(
            const Duration(seconds: 30),
            () => 100,
          ).then((value) {
            isLoadingSubscription.value = false;
            globals.globalIsLoadingSubscription = false;
            globals.globalWaitingGetListServer = false;
            var statusVpn = "";

            if (connectionStatus case AsyncData(:final value)) {
              if (value.isConnected) {
                statusVpn = "connect";
              } else {
                statusVpn = "disconnect";
              }
              //  status_vpn=value as String;
            }
            print(
                'The globals.globalCheckGetListServer is ${statusVpn}   ${globals.globalCheckGetListServer}.');

            // if (statusVpn == "disconnect") {
            if (globals.globalCheckGetListServer == true) {
              globals.globalCheckGetListServer = false;
              GetListAccountServer(
                  context, ref, addProfileProvider, deleteProfileMutation);
            }
            print('The value is $value.'); // Prints later, after 3 seconds.
          });
          // isLoadingSubscription.value = false;
          // globals.globalWaitingGetListServer = false;
          // var statusVpn = "";
          //
          // if (connectionStatus case AsyncData(:final value)) {
          //   if (value.isConnected) {
          //     statusVpn = "connect";
          //   } else {
          //     statusVpn = "disconnect";
          //   }
          //   //  status_vpn=value as String;
          // }
          // print('The globals.globalCheckGetListServer is ${statusVpn}   ${globals.globalCheckGetListServer}.');
          //
          // if (statusVpn == "disconnect") {
          //   GetListAccountServer(
          //       context, ref, addProfileProvider, deleteProfileMutation);
          // }
          // print('The vaerfsefsdlue is 12132123.'); // Prints later, after 3 seconds.
          /*


                                  Future.delayed(
                                    const Duration(seconds: 30),
                                        () => 100,
                                  ).then((value) {
                                    GetListAccountServer(
                                        context,
                                        ref,
                                        addProfileProvider,
                                        deleteProfileMutation)
                                    print(
                                        'The value is $value.'); // Prints later, after 3 seconds.

                                  })
                                  */
        }
        // then will return value when the loginscreen's pop is called.
      });
    }

    void testtt() {
      print('Handling a exitApp message22222');
    }

    clear_app() async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', '');
      prefs.setString('config', '');
      prefs.setString('url_login', '/login/teuyrtye');
      globals.urlLink = "/login/teuyrtye";
      prefs.setString('subscription', '');
      globals.globalToken = "";
      deleteProfileMutation.setFuture(
        ref.read(profilesOverviewNotifierProvider.notifier).deleteAllProfile(),
      );

      goScreenLogin();
      await FirebaseAuth.instance.signOut();
    }

    void exitApp(
        BuildContext context,
        WidgetRef ref,
        AutoDisposeNotifierProvider<AddProfile, AsyncValue<Unit?>>
            addProfileProvider,
        deleteProfileMutation) async {
      print('Handling a exitApp message');
      isLoadingExit.value = true;
      try {
        ///////////////////////////

        // final hasExperimental =
        //     await ref.read(configOptionNotifierProvider.future).then(
        //           (value) => value.hasExperimentalOptions(),
        //           onError: (_) => false,
        //         );
        // final canShowNotice =
        //     !ref.read(disableExperimentalFeatureNoticeProvider);

        ///////////////////////////
        final DioHttpClient client = DioHttpClient(
            timeout: const Duration(seconds: 30),
            userAgent:
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:123.0) Gecko/20100101 Firefox/123.0",
            debug: true,
            Authorization: globals.globalToken);
        // final response =
        // await client.get<Map<String, dynamic>>('https://shop.hologate.pro/api/login');

        var deviceID = await get_unique_identifier();

        var device_model = await get_info_device();
        var device_code = await get_info_device();
        //  var params = "?username=${user}&password=${pass}&platform=android&token_fb=null&unique_id=${deviceID}&&device_model=${device_model}&&device_code=${device_code}";
        // var params =
        //     "?platform=android&token_fb=null&unique_id=${deviceID}&&device_model=${device_model}&&device_code=${device_code}";
        // //  loggy.warning('oghab @@@ params: ${params}');
        var formData = FormData.fromMap({
          'token': globals.globalToken,
          'unique_id': deviceID,
          'is_plus_device': true,
          'platform': Platform.operatingSystem,
          // 'username': user,
          // 'password': pass,
          // 'file': await MultipartFile.fromFile('./text.txt',filename: 'upload.txt')
        });
        print(
            "oghab @@@ deviceID exitttt: ${deviceID} ${globals.globalToken} ${globals.global_url}");

        final response = await client.post(
            // 'https://shop.hologate.pro/api/accounts' + params, formData);
            globals.global_url + '/api/accounts/log_out',
            formData);
        final jsonData = response.data!;
        print("oghab @@@ response: ${response}");
        isLoadingExit.value = false;

        if (response.statusCode == 200) {
          if (jsonData['success'] == true) {
            CustomToast.success(
                    jsonData['message']?.toString() ?? "باموفقیت انجام شد!")
                .show(context);

            // const LoginRoute().push(context).then((data) {
            //   // print("oghab @@@@ ppppppp2 " + globals.globalToken.toString());
            //   if (globals.globalCheckGetListServer)
            //     GetListAccountServer(
            //         context, ref, addProfileProvider, deleteProfileMutation);
            //   // then will return value when the loginscreen's pop is called.
            // });
          } else {
            // CustomToast.error(((jsonData['message']?.toString())!.length > 0)
            //         ? jsonData['message'].toString()
            //         : "سرور با خطا مواجه شد!!")
            //     .show(context);
            CustomToast.error(
                    jsonData['message']?.toString() ?? "سرور با خطا مواجه شد!")
                .show(context);
          }
          // Navigator.of(context).pop();
          // Navigator.of(context).popUntil(ModalRoute.withName('/'));
          // final regionLocale =
          // _getRegionLocale(jsonData['country_code']?.toString() ?? "");
          //
          // loggy.debug(
          //   'Region: ${regionLocale.region} Locale: ${regionLocale.locale}',
          // );
        } else {
          CustomToast.error("سرور با خطا مواجه شد!!").show(context);
          loggy.warning('Request failed with status: ${response.statusCode}');
        }
      } catch (e) {
        isLoadingExit.value = false;
        CustomToast.error("سرور با خطا مواجه شد!!!").show(context);
        loggy.warning('Could not get the local country code from ip');
      }
      clear_app();

      // final prefs = await SharedPreferences.getInstance();
      // prefs.setString('token', '');
      // prefs.setString('subscription', '');
      // globals.globalToken = "";
      // deleteProfileMutation.setFuture(
      //   ref.read(profilesOverviewNotifierProvider.notifier).deleteAllProfile(),
      // );
      //
      // const LoginRoute().push(context).then((data) {
      //   // print("oghab @@@@ ppppppp2 " + globals.globalToken.toString());
      //   if (globals.globalCheckGetListServer)
      //     GetListAccountServer(
      //         context, ref, addProfileProvider, deleteProfileMutation);
      //   // then will return value when the loginscreen's pop is called.
      // });

      // final t = ref.watch(translationsProvider);
      // final deleteProfileMutation = useMutation(
      //   initialOnFailure: (err) {
      //     CustomAlertDialog.fromErr(t.presentError(err)).show(context);
      //   },
      // );
      // if (deleteProfileMutation.state.isInProgress) {
      //   return;
      // }
      //
      //
      // deleteProfileMutation.setFuture(ref.read(profilesOverviewNotifierProvider.notifier).deleteProfile(profile));
    }

    Future<void> AuthenticationServer(BuildContext context) async {
      try {
        var statusVpn = "";
        // String status_vpn = connectionStatus as String;
        //AsyncData<ConnectionStatus>(value: ConnectionStatus.disconnected(connectionFailure: null))
        //AsyncData<ConnectionStatus>(value: ConnectionStatus.connected())
        // if(status_vpn=="AsyncData<ConnectionStatus>(value: ConnectionStatus.connected())")
        //   status_vpn="hjghj";
        // status_vpn= AsyncData(connectionStatus) as String;
        if (connectionStatus case AsyncData(:final value)) {
          if (value.isConnected) {
            statusVpn = "connect";
          } else {
            statusVpn = "disconnect";
          }
          //  status_vpn=value as String;
        }
        //   status_vpn= AsyncData(connectionStatus) as String;
        // switch (connectionStatus) {
        //   case AsyncData(value: final status):
        //     status_vpn=status as String;
        //     // return;
        // }
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
          'unique_id': deviceID,
          'is_plus_device': true,
          'token_fb': globals.globalTokenFB,
          'connectionStatus': statusVpn,
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

        print(
            "oghab @@@ params: ${statusVpn}  ${deviceID} ${globals.globalToken} ${globals.globalTokenFB}");

        final response = await client.post(
            globals.global_url + '/api/accounts/device-permission', formData);
        if (response.statusCode == 200) {
          final jsonData = response.data!;
          print(jsonData);
          final SharedPreferences prefs =
          await SharedPreferences.getInstance();
          if (jsonData['success'] == true) {
            device_name.value = jsonData['username'].toString() ?? '';
            count_device.value = jsonData['number_of_devices'].toString() ?? '';
            date_account.value = jsonData['expiration_date'].toString() ?? '';
            volume_account.value = jsonData['traffic'].toString() ?? '';
            globalBanner = jsonData['banner']?.toString() ?? "";
            globalUnreadNotificationCount = jsonData['unread_notification_count']?.toString() ?? "20";
            globalClickBanner = jsonData['banner_click']?.toString() ?? "";

            var subscription_id = jsonData['subscription_id']?.toString() ?? '';
            prefs.setString('subscription_id', subscription_id);
            globals.global_subscription_id = subscription_id;
            var loginUrl = jsonData['login_url_no_domain']?.toString() ?? "";
            if (loginUrl.isNotNullOrEmpty) {

              globals.urlLink = loginUrl;
              await prefs.setString('url_login', loginUrl);
            }
            var tokenWeb = jsonData['web_token']?.toString() ?? "";
            if (tokenWeb.isNotNullOrEmpty) {

              globals.tokenWeb=tokenWeb;
              await prefs.setString('web_token', tokenWeb);
            }

          } else {
            exitApp(context, ref, addProfileProvider, deleteProfileMutation);
            // CustomToast.error(((jsonData['message']?.toString())!.length > 0)
            //         ? jsonData['message'].toString()
            //         : "سرور با خطا مواجه شد!!")
            //     .show(context);
            CustomToast.error(jsonData['message']?.toString() ??
                    "***سرور با خطا مواجه شد!!")
                .show(context);
          }
        } else {
          // CustomToast.error(
          //     "سرور با خطا مواجه شد!!*")
          //     .show(context);
          loggy.warning('Request failed with status: ${response.statusCode}');
        }
      } catch (e) {
        // CustomToast.error(
        //     "**سرور با خطا مواجه شد!!")
        //     .show(context);
        loggy.warning('Could not get the local country code from ip');
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var ipv6 = prefs.getString("ipv6-mode");
      //prefer_ipv6
      // if (ipv6 != null && ipv6 != "prefer_ipv6") {
      //   await ref
      //       .read(configOptionNotifierProvider.notifier)
      //       .updateOption(const ConfigOptionPatch(ipv6Mode: IPv6Mode.prefer));
      //   await ref.read(analyticsControllerProvider.notifier).disableAnalytics();
      // }
    }

    Future<void> GetNotificationsServer(BuildContext context) async {
      try {
        var statusVpn = "";
        // String status_vpn = connectionStatus as String;
        //AsyncData<ConnectionStatus>(value: ConnectionStatus.disconnected(connectionFailure: null))
        //AsyncData<ConnectionStatus>(value: ConnectionStatus.connected())
        // if(status_vpn=="AsyncData<ConnectionStatus>(value: ConnectionStatus.connected())")
        //   status_vpn="hjghj";
        // status_vpn= AsyncData(connectionStatus) as String;
        if (connectionStatus case AsyncData(:final value)) {
          if (value.isConnected) {
            statusVpn = "connect";
          } else {
            statusVpn = "disconnect";
          }
          //  status_vpn=value as String;
        }
        //   status_vpn= AsyncData(connectionStatus) as String;
        // switch (connectionStatus) {
        //   case AsyncData(value: final status):
        //     status_vpn=status as String;
        //     // return;
        // }
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
          'unique_id': deviceID,
          'is_plus_device': true,
          'token_fb': globals.globalTokenFB,
          'connectionStatus': statusVpn,
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

        print(
            "oghab @@@ params: ${statusVpn}  ${deviceID} ${globals.globalToken} ${globals.globalTokenFB}");

        final response = await client.post(
            globals.global_url + '/api/get-notifications', formData);
        if (response.statusCode == 200) {
          final jsonData = response.data!;
          print("oghab @@@ params:${jsonData} ");
          //List<String> streetsList = new List<String>.from(jsonData['notifications'] );

          _showModalList(context,jsonData['notifications'] as List );
          if (jsonData['success'] == true) {
            // device_name.value = jsonData['username']?.toString() ?? '';
            // count_device.value =
            //     jsonData['number_of_devices']?.toString() ?? '';
            // date_account.value = jsonData['expiration_date']?.toString() ?? '';
            // volume_account.value = jsonData['traffic']?.toString() ?? '';
            // globalBanner = jsonData['banner']?.toString() ?? "";
            // globalClickBanner = jsonData['banner_click']?.toString() ?? "";
            // // CustomToast.error(globalBanner).show(context);
            // var loginUrl = jsonData['login_url_no_domain']?.toString() ?? "";
            // if (loginUrl.isNotNullOrEmpty) {
            //   final SharedPreferences prefs =
            //   await SharedPreferences.getInstance();
            //   globals.urlLink = loginUrl;
            //   await prefs.setString('url_login', loginUrl);
            // }
          } else {

          }
        } else {
          // CustomToast.error(
          //     "سرور با خطا مواجه شد!!*")
          //     .show(context);
          loggy.warning('Request failed with status: ${response.statusCode}');
        }
      } catch (e) {
        // CustomToast.error(
        //     "**سرور با خطا مواجه شد!!")
        //     .show(context);
        loggy.warning('Could not get the local country code from ip'+e.toString());
      }

    }

    // @override
    // void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // print(" @@@@@@@@ ");
    // }
    useOnAppLifecycleStateChange((pref, state) {
      if (state == AppLifecycleState.resumed) {
        if (globals.globalToken != "") AuthenticationServer(context);
        // CustomToast.success(globals.globalCheckChangeServerUrl.toString()).show(context);
        if (globals.globalCheckChangeServerUrl) {
          GetListAccountServer(
              context, ref, addProfileProvider, deleteProfileMutation);
        }
        //make a request
      }
    });
    // Future<void> _firebaseMessagingBackgroundHandler(
    //     RemoteMessage message) async {
    //   // await Firebase.initializeApp();
    //   print('Handling a background message111 ${message.messageId}');
    //   testtt();
    //   exitApp(context, ref, addProfileProvider, deleteProfileMutation);
    //   debugPrint("Handling a background message1111111: ${message.data}");
    //
    //   // SharedPreferences prefs = await SharedPreferences.getInstance();
    //   // String? userCourseValue = prefs.getString('userCourse');
    //   // print(message.data['userCourse']);
    //   // print(userCourseValue);
    //   //  if(userCourseValue==message.data['userCourse']){
    //   // /*   AwesomeNotifications().createNotification(
    //   //        content: NotificationContent(
    //   //            id: 1,
    //   //            channelKey: message.notification!.android!.channelId ?? 'basic',
    //   //            title: message.notification!.title,
    //   //            body: message.notification!.body,
    //   //            bigPicture: message.notification!.android!.imageUrl,
    //   //            notificationLayout: NotificationLayout.BigPicture
    //   //        )
    //   //    );*/
    //   //  }
    // }

    useEffect(
      () {
        _loadPreferences(
            context, ref, addProfileProvider, deleteProfileMutation);
        // globals.global_ref=ref;
        // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        // FlutterLocalNotificationsPlugin();
        // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        //   alert: true, // Required to display a heads up notification
        //   badge: true,
        //   sound: true,
        // );

        AuthenticationServer(context);
        // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

        if (!Platform.isWindows) {
          final _messagingService = MessagingService();
          _messagingService.init(context, ref);
          // _messagingService.init(context);
          //     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
          FirebaseMessaging.onMessage.listen((remoteMessage) async {
            debugPrint('Got a message in the foreground');
            debugPrint('message data00000: ${remoteMessage.data}');

            var base_url = remoteMessage.data['link_url']?.toString() ?? "";
            if (base_url.isNotNullOrEmpty) {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString("base_url", base_url);

              global_url = base_url;
            }

            // final ConnectionRepository _connectionRepo =
            //     ref.read(connectionRepositoryProvider);

            await _connectionRepo.disconnect().mapLeft((err) {
              // loggy.warning("error disconnecting", err);
              // state = AsyncError(err, StackTrace.current);
            }).run();
            if (remoteMessage.data['exit'] == "true") {
              CustomToast.success(remoteMessage.data['message']?.toString() ??
                      "شما توسط شخص دیگری بیرون انداخته شدید")
                  .show(context);
              if (globals.globalToken != "")
                exitApp(
                    context, ref, addProfileProvider, deleteProfileMutation);
            } else if (remoteMessage.data['refresh'] == "true") {
              GetListAccountServer(
                  context, ref, addProfileProvider, deleteProfileMutation);
              CustomToast.success(remoteMessage.data['message']?.toString() ??
                      "سرورهای شما در حال بروزرسانی است شکیبا باشید")
                  .show(context);
            }
            /*   if (remoteMessage.notification != null) {
               flutterLocalNotificationsPlugin.show(
                  notification.hashCode,
                  notification.title,
                  notification.body,
                  NotificationDetails(
                      android: AndroidNotificationDetails(
                        channel.id,
                        channel.name,
                      ),
                      iOS: const IOSNotificationDetails()),
                );
            debugPrint('message is a notification');
            // On Android, foreground notifications are not shown, only when the app
            // is backgrounded.
          }*/
          });

          print("oghab @@@@ @@@@@@@@ token " + globals.globalToken.toString());
        }

        if (globals.globalIsAdmin) {
          /*    Future.delayed(
            const Duration(seconds: 6),
                () => 100,
          ).then((value) async{
            if((globals.globalToken != "" &&
                globals.global_status_Connection == "success")){
              await ref
                  .read(connectionNotifierProvider.notifier)
                  .toggleConnection();
            }
          });*/
          // Timer.periodic(Duration(minutes: 5), (timer) {
          //   if(condition){
          //     timer.cancel();
          //     createNewPeriodicTask();
          //   }
          //   // task code
          // });
          //Timer.periodic(Duration(minutes: globals.globalTimeRefresh), (timer) async {

          if (globals.globalCheckTimer) {
            globals.globalCheckTimer = false;
            Timer.periodic(const Duration(minutes: 1), (timer) async {
              //final contants cons=contants();
              // print('Timer.periodic@@@   ' +contants.name.toString()+"  ---  "+ globals.globalCheckGetListServer.toString()+"   ---   "+ globals.globalTimeRefresh.toString()+"   ---   "+globals.globalCheckFinish.toString());
              // print('Timer.periodic@@@   ' + globals.globalCheckGetListServer.toString()+"   ---   "+ globals.globalTimeRefresh.toString()+"   ---   "+globals.globalCheckFinish.toString());

              //if (globals.globalCheckFinish && globals.globalTimeRefresh < 5) {
              if (globals.globalTimeRefresh != 0) {
                // if (contants.name !=0) {
                globals.globalTimeRefresh -= 1;
                // contants.name =contants.name -1;
              } else {
                if (globals.globalToken != "" &&
                    globals.global_status_Connection == "success") {
                  globals.globalTimeRefresh = 1;
                  // contants.name =0;
                  //await ref.read(connectionNotifierProvider.notifier).toggleConnection();
                  await connect_disconnectProfile.toggleConnection();
                }
              }
            });
          }
        }
        return null;

        // return () {
        //   print("oghab @@@@ @@@@@@@@ token " + globals.globalToken.toString());
        //
        //   // your dispose code
        // };
      },
      [],
    );
    // if(checkFirebase)

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          CustomScrollView(
            slivers: [
              NestedAppBar(
                title: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: t.general.appTitle),
                      const TextSpan(text: " "),
                      // const WidgetSpan(
                      //   child: AppVersionLabel(),
                      //   alignment: PlaceholderAlignment.middle,
                      // ),
                    ],
                  ),
                ),
                actions: [
                  if (1 != 1)
                    IconButton(
                      onPressed: () => const AddProfileRoute().push(context),
                      icon: const Icon(FluentIcons.add_circle_24_filled),
                      tooltip: t.profile.add.buttonText,
                    ),
                  if (globals.globalToken != "")
                    IconButton(
                      onPressed: () async {
                        //    print("@!@@@@"+addProfileState.hasError.toString());
                        // await _connectionRepo.disconnect().mapLeft((err) {
                        //   // loggy.warning("error disconnecting", err);
                        //   // state = AsyncError(err, StackTrace.current);
                        // }).run();
                        isLoadingSubscription.value = true;
                        globals.globalIsLoadingSubscription = true;

                        globals.globalCheckGetListServer = true;
                        GetListAccountServer(context, ref, addProfileProvider,
                            deleteProfileMutation);
                        // SharedPreferences prefs =
                        //     await SharedPreferences.getInstance();
                        // var ssss = prefs.getString("ipv6-mode");
                        // //prefer_ipv6
                        // print("oghab @@@@ 0 options.ipv6Mode " + ssss!);

                        // ref.read(connectionNotifierProvider.notifier).toggleConnection();
                        //   globals.global_ref.read(connectionNotifierProvider.notifier).toggleConnection();
                        //   globals.global_container.read(connectionNotifierProvider.notifier).toggleConnection();
                      },
                      icon: const Icon(FluentIcons.arrow_sync_24_regular),
                      tooltip: t.profile.add.buttonText,
                    ),
                  IconButton(
                    onPressed: () => {
                      GetNotificationsServer(context)

                    },
                    icon: Stack(
                      children: <Widget>[
                        new Container(
                          padding: EdgeInsets.only(right: 5.0),
                          child: Icon(FluentIcons.alert_24_regular),
                        ),
                        if(globalUnreadNotificationCount!="0")
                        new Positioned(
                          top: 0.0,
                          right: 0.0,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.brightness_1,
                                size: 15.0,
                                color: Colors.redAccent,
                              ),

                              Text(
                                globalUnreadNotificationCount,
                                textAlign: TextAlign.center,
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 8.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () => {
                  //     GetNotificationsServer(context)
                  //
                  //   },
                  //   icon: const Icon(FluentIcons.alert_24_regular),
                  //   tooltip: t.profile.add.buttonText,
                  // ),
                  if (1 != 1)
                    IconButton(
                      onPressed: () => {
                        if (globals.globalToken != "")
                          const WebViewRoute().push(context)
                        else
                          goScreenLogin()
                        // const LoginRoute().push(context).then((data) {
                        //   //  print("oghab @@@@ ppppppp2 ${globals.globalToken}");
                        //   if (globals.globalCheckGetListServer) {
                        //     GetListAccountServer(context, ref,
                        //         addProfileProvider, deleteProfileMutation);
                        //   }
                        //   // then will return value when the loginscreen's pop is called.
                        // }),
                      },
                      icon: const Icon(FluentIcons.cart_16_filled),
                      tooltip: t.profile.add.buttonText,
                    ),
                  IconButton(
                    onPressed: () => {
                      if (globals.globalToken != "")
                        exitApp(context, ref, addProfileProvider,
                            deleteProfileMutation)
                      else
                        goScreenLogin()
                      // const LoginRoute().push(context).then((data) {
                      //   // print("oghab @@@@ ppppppp2 ${globals.globalToken } ${globals.globalCheckGetListServer }");
                      //   if (globals.globalCheckGetListServer == true) {
                      //     GetListAccountServer(
                      //       context,
                      //       ref,
                      //       addProfileProvider,
                      //       deleteProfileMutation,
                      //     );
                      //     CustomToast.error(
                      //             "در حال ساختن  اکانت لطفا صبر نمایید")
                      //         .show(context);
                      //     isLoadingSubscription.value = true;
                      //
                      //     Future.delayed(
                      //       const Duration(seconds: 30),
                      //       () => 100,
                      //     ).then((value) {
                      //       isLoadingSubscription.value = false;
                      //
                      //       GetListAccountServer(context, ref,
                      //           addProfileProvider, deleteProfileMutation);
                      //       print(
                      //           'The value is $value.'); // Prints later, after 3 seconds.
                      //     });
                      //     /*
                      //
                      //
                      //           Future.delayed(
                      //             const Duration(seconds: 30),
                      //                 () => 100,
                      //           ).then((value) {
                      //             GetListAccountServer(
                      //                 context,
                      //                 ref,
                      //                 addProfileProvider,
                      //                 deleteProfileMutation)
                      //             print(
                      //                 'The value is $value.'); // Prints later, after 3 seconds.
                      //
                      //           })
                      //           */
                      //   }
                      //   // then will return value when the loginscreen's pop is called.
                      // }),
                    },
                    icon: (globals.globalToken != "")
                        ? const Icon(FluentIcons.arrow_exit_20_filled)
                        : const Icon(FluentIcons.person_board_20_regular),
                    tooltip: t.profile.add.buttonText,
                  ),
                ],
              ),
              if (1 != 1)
                MultiSliver(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28.0, vertical: 6.0),
                      child: FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(FluentIcons.arrow_sync_24_filled),
                        label: const Text("بروزرسانی اپلیکیسشن"),
                        // style: ButtonStyle( ),
                      ),
                    ),
                  ],
                ),
              if (globals.globalBanner.isNotNullOrEmpty)
                MultiSliver(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 4.0),
                      child: SizedBox(
                        height: (MediaQuery.of(context).size.height) / 9,
                        width: (MediaQuery.of(context).size.height),
                        child: InkWell(
                          onTap: () async {
                            if (globals.globalClickBanner.isNotNullOrEmpty)
                              await UriUtils.tryLaunch(
                                Uri.parse(globals.globalClickBanner),
                              );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.network(
                              //  globals.global_url+ globals.globalBanner,
                              globals.globalBanner,
                              //"https://static.vecteezy.com/ti/gratis-vektor/t2/5715816-banner-abstract-vector-background-board-for-text-and-message-design-modern-vektor.jpg",
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              if (globals.globalToken != "")
                MultiSliver(children: [
                  Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 12.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    // products2[index]['name']!.toString() +" "+
                                    "نام اشتراک : ",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    // products2[index]['name']!.toString() +" "+
                                    device_name.value,
                                    style: TextStyle(
                                      // color: Colors.black,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              const Gap(8),
                              Row(
                                children: [
                                  Text(
                                    // products2[index]['name']!.toString() +" "+
                                    "تعداد اتصال : ",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    // products2[index]['name']!.toString() +" "+
                                    count_device.value,
                                    style: TextStyle(
                                      // color: Colors.black,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              /*   Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      // products2[index]['name']!.toString() +" "+
                                      "نام اشتراک : ",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                     Text(
                                      // products2[index]['name']!.toString() +" "+
                                      device_name.value,
                                      style: TextStyle(
                                        // color: Colors.black,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      // products2[index]['name']!.toString() +" "+
                                      "تعداد دستگاه : ",
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                     Text(
                                      // products2[index]['name']!.toString() +" "+
                                      count_device.value,
                                      style: TextStyle(
                                        // color: Colors.black,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ],
                            ),*/
                              const Gap(8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        // products2[index]['name']!.toString() +" "+
                                        "تاریخ انقضا : ",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        // products2[index]['name']!.toString() +" "+
                                        date_account.value,
                                        style: TextStyle(
                                          // color: Colors.black,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        // products2[index]['name']!.toString() +" "+
                                        "حجم: ",
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        // products2[index]['name']!.toString() +" "+
                                        volume_account.value,
                                        style: TextStyle(
                                          // color: Colors.black,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )))
                ]),

              if (globals.globalToken != "")
                MultiSliver(children: [
                  SizedBox(
                    width: 200,
                    child: FilledButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();

                        globals.globalCheckMcGroup = true;

                        var account_id = prefs.getString('account_id') ?? '';
                        globals.global_account_id = account_id;

                        var device_name = prefs.getString('device_name') ?? '';
                        globals.global_account_name = device_name;
                        const ConfigLocationRoute().push(context).then((data) {
                          print(
                              "oghab @@@@ globals.globalCheckMcGroup ${globals.globalCheckMcGroup}");
                          globals.globalCheckMcGroup = false;
                          if (globals.globalWaitingGetListServer == true) {
                            print(
                                "oghab @@@@ ppppppp2 ${globals.globalToken} ${globals.globalCheckGetListServer}");
                            // GetListAccountServer(context, ref, addProfileProvider,
                            //     deleteProfileMutation);
                            globals.globalCheckGetListServer = false;
                            //await ref.read(addProfileProvider.notifier).ge(subscription);
                            deleteProfileMutation.setFuture(
                              ref
                                  .read(
                                      profilesOverviewNotifierProvider.notifier)
                                  .deleteAllProfile(),
                            );
                            isLoadingSubscription.value = true;
                            globals.globalIsLoadingSubscription = true;

                            Future.delayed(
                              const Duration(seconds: 20),
                              () => 100,
                            ).then((value) {
                              isLoadingSubscription.value = false;
                              globals.globalIsLoadingSubscription = false;

                              globals.globalWaitingGetListServer = false;
                              GetListAccountServer(context, ref,
                                  addProfileProvider, deleteProfileMutation);

                              print(
                                  'The value is $value.'); // Prints later, after 3 seconds.
                            });
                          }

                          // then will return value when the loginscreen's pop is called.
                        });

                        // var subscription_id =
                        //     prefs.getString('subscription_id') ?? '';
                        // globals.global_subscription_id = subscription_id;
                        // var deviceID = await get_unique_identifier();
                        //
                        // await UriUtils.tryLaunch(
                        //   Uri.parse(
                        //        globals.global_url+"/subscription/"+globals.global_subscription_id+"/change-server/provider?token="+globals.globalToken+"&unique_id="+deviceID.toString()),
                        //     //  "https://hologate4731.com:90" + "/subscription/" + globals.global_subscription_id + "/change-server/provider?token=" + globals.globalToken + "&unique_id=" + deviceID.toString()),
                        // );
                        // deleteProfileMutation.setFuture(
                        //   ref
                        //       .read(profilesOverviewNotifierProvider.notifier)
                        //       .deleteAllProfile(),
                        // );
                        // globals.globalCheckChangeServerUrl = true;
                      },
                      child: const Text(
                        "تغییر گروه سرور",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            Color(0xffea5555), // This is what you need!
                      ),
                      // style: ButtonStyle( ),
                    ),
                  ),
                ]),
              if (globals.globalToken != "" &&
                  addProfileState.isLoading == false &&
                  addProfileState.hasError == true)
                MultiSliver(children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2,
                    // color: Colors.blue.withOpacity(0.6),
                    //  color: Colors.pink,
                    padding: const EdgeInsets.all(10),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                                'در ساخت اکانت با مشکل مواجه شد علامت بروزرسانی  (🔄) را در بالا بزنید')),
                        //  CircularProgressIndicator()
                      ],
                    ),
                  )
                ]),
              if (globals.globalToken != "" &&
                  globals.global_status_Connection == "success")
                switch (activeProfile) {
                  AsyncData(value: final profile?) => MultiSliver(
                      children: [
                        //   ProfileTile(profile: profile, isMain: true),
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // const Text(
                              //   "profile.name",
                              //   maxLines: 2,
                              //   overflow: TextOverflow.ellipsis,
                              //   // style: theme.textTheme.titleMedium,
                              //   semanticsLabel: "aaaa",
                              // ),

                              const Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ConnectionButton(),
                                    ActiveProxyDelayIndicator(),
                                  ],
                                ),
                              ),
                              if (MediaQuery.sizeOf(context).width < 840)
                                const ActiveProxyFooter(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  AsyncData() => switch (hasAnyProfile) {
                      AsyncData(value: true) =>
                        const EmptyActiveProfileHomeBody(),
                      _ => EmptyProfilesHomeBody(
                          key: ValueKey("add_from_clipboard_button"),
                          onTap: () {
                            goScreenLogin();
                          }),
                      // _ => const EmptyProfilesHomeBody(),
                    },
                  AsyncError(:final error) =>
                    SliverErrorBodyPlaceholder(t.presentShortError(error)),
                  _ => const SliverToBoxAdapter(),
                },
              if (addProfileState.isLoading == true &&
                  // globals.global_status_Connection =="success")
                  globals.globalToken != "")
                MultiSliver(children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2,
                    // color: Colors.blue.withOpacity(0.6),
                    //  color: Colors.pink,
                    padding: const EdgeInsets.all(10),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                                'لیست سرور خالی شد، لطفا حدود 30 ثانیه منتظر بمانید و اگر علامت هلوگیت را مشاهده نکردید علامت بروزرسانی  (🔄) را در بالا بزنید!!')),
                        CircularProgressIndicator()
                      ],
                    ),
                  )
                ]),

              if (globals.globalToken == "")
                SliverFillRemaining(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Text(t.home.emptyProfilesMsg),
                      const Gap(16),
                      OutlinedButton.icon(
                        // onPressed: () => const AddProfileRoute().push(context),
                        // onPressed: () =>{const LoginRoute().push(context)} ,
                        onPressed: () => goScreenLogin(),
                        icon: const Icon(FluentIcons.person_board_20_regular),
                        label: Text(t.profile.add.buttonText),
                        // style: OutlinedButton.styleFrom(
                        //   side: BorderSide(width: 1.0, color: Color(0xffea5555)),
                        // ),
                      ),
                    ])),

              // else
              // if (isLoadingSubscription.value)  Positioned(
              //       left: 0.0,
              //       right: 0.0,
              //       bottom: 0.0,
              //       top: 0.0,
              //       child: Container(
              //         width: MediaQuery.of(context).size.width,
              //         color: Colors.black.withOpacity(0.6),
              //         //  color: Colors.pink,
              //         padding: const EdgeInsets.all(10),
              //         child: const Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: <Widget>[
              //             Padding(
              //                 padding: EdgeInsets.all(10.0),
              //                 child: Text('درحال ساختن لطفا صبر نمایید ...')),
              //             CircularProgressIndicator()
              //           ],
              //         ),
              //       ))
            ],
          ),
          if (isLoadingExit.value)
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
      ),
    );
  }

  Future<void> disableAnalytics(WidgetRef ref) async {
    //   if (!ref.read(analyticsControllerProvider).requireValue) {
    loggy.info("disabling analytics per user request");
    try {
      await ref.read(analyticsControllerProvider.notifier).disableAnalytics();
    } catch (error, stackTrace) {
      loggy.error(
        "could not disable analytics",
        error,
        stackTrace,
      );
    }
    // }
  }

  Future<void> GetListAccountServer2233(
      BuildContext context,
      WidgetRef ref,
      AutoDisposeNotifierProvider<AddProfile, AsyncValue<Unit?>>
          addProfileProvider,
      dynamic deleteProfileMutation) async {
    final prefs = await SharedPreferences.getInstance();
    var id_device = prefs.getString('id_device') ?? '';
    final addProfileState = ref.watch(addProfileProvider);
    // final t = ref.watch(translationsProvider);
    //
    // if (Platform.isIOS) { // import 'dart:io'
    //   var iosDeviceInfo = await deviceInfo.iosInfo;
    //   return iosDeviceInfo.utsname.machine; //
    // }
    var deviceInfo = DeviceInfoPlugin();
    //   var iosDeviceInfo = await deviceInfo.iosInfo;
    var androidDeviceInfo = await deviceInfo.androidInfo;
    var abis = androidDeviceInfo.supportedAbis;
    var stringAbi = "";
    for (var abi in abis) {
      stringAbi += abi.toString() + ", ";
      print("oghab @@@@ count 2*****www  " + abi);
    }
    print("oghab @@@@ count 2*****www  stringAbi " +
        stringAbi +
        "  -   " +
        androidDeviceInfo.serialNumber +
        androidDeviceInfo.device +
        androidDeviceInfo.id);

    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String version = packageInfo.version;
    final String code = packageInfo.buildNumber;
    print("oghab @@@@ count 2*****www   2 " +
        "  -   " +
        version +
        "    ----   " +
        code +
        "    ----   " +
        id_device);

    // loggy.debug(
    //   'oghab @@@ token : ${globals.globalToken} } ',
    // );
    try {
      final DioHttpClient client = DioHttpClient(
          timeout: const Duration(seconds: 30),
          userAgent:
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:123.0) Gecko/20100101 Firefox/123.0",
          debug: true,
          Authorization: globals.globalToken);
      // final response =
      // await client.get<Map<String, dynamic>>('https://shop.hologate.pro/api/login');
      var formData = FormData.fromMap({
        'token': globals.globalToken,
        'id_device': id_device,
        'is_plus_device': true,

        // 'file': await MultipartFile.fromFile('./text.txt',filename: 'upload.txt')
      });
      final response =
          await client.post('https://shop.hologate.pro/api/accounts', formData);
      // await client.post('https://shop.hologate.pro/api/get-subscription', formData);
      // await client.post(globals.global_url+'/api/accounts/get-subscription', formData);
      if (response.statusCode == 200) {
        final jsonData = response.data!;
        // final jsonData1 = json.decode(response.data.toString());
        // loggy.debug(
        //   'oghab @@@ jsonData : ${jsonData} } ',
        // );
        // loggy.debug(
        //   'oghab @@@ jsonData1 : ${jsonData1} } ',
        // );
        //   var accounts = jsonData.getJSONArray['accounts'];
        // var accounts = jsonData.getJSONArray('accounts');
        globals.globalVersionApp = 20;
        var accounts = jsonData['accounts'];
        // Int? length = jsonData['accounts']?.length??0;
        // var accounts1 = jsonData1['accounts'].length;
        var length = int.parse(accounts.length.toString());
        // loggy.debug(
        //   'oghab @@@ accounts : ${accounts} ${length} } ',
        // );
        // loggy.debug(
        //   'oghab @@@ accounts1 : ${accounts1} } ',
        // );
        globals.globalCheckGetListServer = false;
        // print("oghab @@@@ count 2*****  " + length.toString());
        // await notifier.delete();

        deleteProfileMutation.setFuture(
          ref
              .read(profilesOverviewNotifierProvider.notifier)
              .deleteAllProfile(),
        );
        for (var i = 0; i < length; i++) {
          // loggy.debug(
          //   'oghab @@@ accounts[] : ${accounts[i]['link']} } ',
          // );
          if (accounts[i]['link'] != null) {
            await ref.read(addProfileProvider.notifier).add(
                accounts[i]['link'].toString(),
                showMessageState1: (length - 1 == i));
            // loggy.debug(
            //   'oghab @@@ accounts[] 44444 : ${accounts[i]['link']} } ',
            // );
            //  if (addProfileState.isLoading) return;
//             Future.delayed(const Duration(milliseconds: 2000), () async{
//
// // Here you can write your code
//
//               await ref
//                   .read(addProfileProvider.notifier)
//                   .add(accounts[i]['link'].toString());
//             });
          }
        }
        // final captureResult =
        // await Clipboard.getData(Clipboard.kTextPlain)
        //     .then((value) => value?.text ?? '');
        // if (addProfileState.isLoading) return;

        /*  ref.read(addProfileProvider.notifier)
            .add(link);*/

        // final SharedPreferences prefs = await SharedPreferences.getInstance();
        // await prefs.setString('token', globals.globalToken);
        // Navigator.of(context).pop();
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

  void _showModalList(BuildContext context,List  items) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,

      builder: (context) {
        return  Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: new BoxDecoration(
          //  color: Colors.white,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(25.0),
              topRight: const Radius.circular(25.0),
            ),
          ),
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40.0),
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        color: Colors.black,
                        child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                            child: ListTile(
                              title: Text(items[index]['subject'].toString()),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(items[index]['body'].toString()),
                                  Text(items[index]['time'].toString(), style: TextStyle(color: Colors.grey)),
                                ],
                              ),

                              trailing: (items[index]['url_text'].toString()!="")? ElevatedButton(
                                onPressed:() async {
                                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                                  var token = prefs.getString('web_token') ?? '';
                                  token = token.replaceAll("Bearer ", "");

                                await UriUtils.tryLaunch(
                                  Uri.parse( globals.global_url +items[index]['url'].toString()+"?token="+token),
                                );
                              },
                                child: Text(items[index]['url_text'].toString()),
                              ):null,
                            )));
                  },
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.close,
                    size: 24,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ],
          )


        );
      },
    );
  }

  Future<void> GetListAccountServer(
      BuildContext context,
      WidgetRef ref,
      AutoDisposeNotifierProvider<AddProfile, AsyncValue<Unit?>>
          addProfileProvider,
      dynamic deleteProfileMutation) async {
    var deviceID = await get_unique_identifier();

    final prefs = await SharedPreferences.getInstance();
    var id_device = prefs.getString('id_device') ?? '';
    var token = prefs.getString('token') ?? '';
    final String stringifiedString = jsonEncode(deviceID);
    token = token.replaceAll("Bearer ", "");

//   var subscription = prefs.getString('subscription')! + "?unique_id=" + stringifiedString! ??'';
    var subscription = global_url +
            prefs.getString('subscription')! +
            "?unique_id=" +
            deviceID! +
            "&token=" +
            token ??
        '';
    //  var subscription = "https://hologate6.com:83/sub/c259f0a0afeadeaae48c9ecb33f9154a?unique_id=%22a6lte%20-%20SM-A600F%20-%20QP1A.190711.020%22";
    // var subscription = prefs.getString('subscription') ?? '';

    // Clipboard.setData(new ClipboardData(text: subscription));

    print("oghab @@@@ subscription  " +
        subscription +
        "  ----   " +
        id_device +
        "  ----   ");
    // print("oghab @@@@ subscription 2222  " + activeProfile.toString());

    //  globals.globalCheckGetListServer = false;
    //await ref.read(addProfileProvider.notifier).ge(subscription);
    deleteProfileMutation.setFuture(
      ref.read(profilesOverviewNotifierProvider.notifier).deleteAllProfile(),
    );
    await ref.read(addProfileProvider.notifier).add(subscription);
    //await ref.read(addProfileProvider.notifier).add("https://mavarimis.blog/wp-content/uploads/2024/v2raytel-configxx.txt");
    ///  await ref.read(addProfileProvider.notifier).add("vmess://eyJ2IjoiMiIsInBzIjoicm9ib3QiLCJhZGQiOiJydTY5MS5ob2xvMzMzLmNvbSIsInBvcnQiOiI0ODQxMCIsImlkIjoiMDAyMjY5OTgtYjVhNi0xYzhhLTQ0YjEtMjc1ZTc0M2IxYzRlIiwiYWlkIjowLCJuZXQiOiJ0Y3AiLCJ0eXBlIjoibm9uZSIsImhvc3QiOiIiLCJwYXRoIjoiXC8iLCJ0bHMiOiJub25lIn0=");
    // await ref.read(addProfileProvider.notifier).add(subscription,onTap: ()  {            isLoadingSubscription.value = false;});
    return;

    final addProfileState = ref.watch(addProfileProvider);
    // final t = ref.watch(translationsProvider);
    //
    // if (Platform.isIOS) { // import 'dart:io'
    //   var iosDeviceInfo = await deviceInfo.iosInfo;
    //   return iosDeviceInfo.utsname.machine; //
    // }
    var deviceInfo = DeviceInfoPlugin();
    //   var iosDeviceInfo = await deviceInfo.iosInfo;
    var androidDeviceInfo = await deviceInfo.androidInfo;
    var abis = androidDeviceInfo.supportedAbis;
    var stringAbi = "";
    for (var abi in abis) {
      stringAbi += abi.toString() + ", ";
      print("oghab @@@@ count 2*****www  " + abi);
    }
    print("oghab @@@@ count 2*****www  stringAbi " +
        stringAbi +
        "  -   " +
        androidDeviceInfo.serialNumber +
        androidDeviceInfo.device +
        androidDeviceInfo.id);

    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String version = packageInfo.version;
    final String code = packageInfo.buildNumber;
    print("oghab @@@@ count 2*****www   2 " +
        "  -   " +
        version +
        "    ----   " +
        code +
        "    ----   " +
        id_device);

    // loggy.debug(
    //   'oghab @@@ token : ${globals.globalToken} } ',
    // );
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
        'token': globals.globalToken,
        'id_device': id_device,
        'is_plus_device': true,
        'unique_id': deviceID,

        // 'file': await MultipartFile.fromFile('./text.txt',filename: 'upload.txt')
      });
      final response =
          // await client.post('https://shop.hologate.pro/api/accounts', formData);
          // await client.post('https://shop.hologate.pro/api/get-subscription', formData);
          await client.post(
              globals.global_url + '/api/accounts/get-subscription', formData);
      loggy.warning('oghab @@@ response: home' + response.toString());
      if (response.statusCode == 200) {
        final jsonData = response.data!;
        // final jsonData1 = json.decode(response.data.toString());
        // loggy.debug(
        //   'oghab @@@ jsonData : ${jsonData} } ',
        // );
        // loggy.debug(
        //   'oghab @@@ jsonData1 : ${jsonData1} } ',
        // );
        //   var accounts = jsonData.getJSONArray['accounts'];
        // var accounts = jsonData.getJSONArray('accounts');
        globals.globalVersionApp = 20;
        var accounts = jsonData['subscription'];
        // Int? length = jsonData['accounts']?.length??0;
        // var accounts1 = jsonData1['accounts'].length;
        // loggy.debug(
        //   'oghab @@@ accounts : ${accounts} ${length} } ',
        // );
        // loggy.debug(
        //   'oghab @@@ accounts1 : ${accounts1} } ',
        // );
        globals.globalCheckGetListServer = false;
        // print("oghab @@@@ count 2*****  " + length.toString());
        // await notifier.delete();

        deleteProfileMutation.setFuture(
          ref
              .read(profilesOverviewNotifierProvider.notifier)
              .deleteAllProfile(),
        );
        if (accounts != null) {
          await ref.read(addProfileProvider.notifier).add(accounts.toString());
        }
      } else {
        loggy.warning('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      loggy.warning('Could not get the local country code from ip');
    }
  }
}

class AppVersionLabel extends HookConsumerWidget {
  const AppVersionLabel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);
    final theme = Theme.of(context);

    final version = ref.watch(appInfoProvider).requireValue.presentVersion;
    if (version.isBlank) return const SizedBox();

    return Semantics(
      label: t.about.version,
      button: false,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 1,
        ),
        child: Text(
          version,
          textDirection: TextDirection.ltr,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSecondaryContainer,
          ),
        ),
      ),
    );
  }
}
