import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
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
import 'package:hiddify/features/profile/widget/profile_tile.dart';
import 'package:hiddify/features/proxy/active/active_proxy_delay_indicator.dart';
import 'package:hiddify/features/proxy/active/active_proxy_footer.dart';
import 'package:hiddify/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:hiddify/utils/globals.dart' as globals;
import 'package:firebase_messaging/firebase_messaging.dart';

// import 'dart:async';
import '../../profile/overview/profiles_overview_notifier.dart';

class HomePage extends HookConsumerWidget with PresLogger {
  // bool checkGetListServer = true;

  const HomePage({super.key});

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
    globals.urlLink = prefs.getString('url_login') ?? globals.global_url;
    globals.globalToken = prefs.getString('token') ?? '';
    globals.globalUsername = prefs.getString('username') ?? '';
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
    final token1 = _loadPreferences(
        context, ref, addProfileProvider, deleteProfileMutation);
    // print("oghab @@@@ 1 " + token.toString());
    //final eeeeee = ref.watch(funnc() as ProviderListenable);
    final hasAnyProfile = ref.watch(hasAnyProfileProvider);
    final activeProfile = ref.watch(activeProfileProvider);
    final asyncProfiles = ref.watch(profilesOverviewNotifierProvider);
    if (asyncProfiles case AsyncData(value: final links)) {
      // print("oghab @@@@ count ******" + links.length.toString());
    }
    // switch (asyncProfiles) {
    //   AsyncData(value: final profiles) => var dd=1,
    //   AsyncError(:final error) =>var dd=2,
    //   AsyncLoading() =>var dd=3,
    // }
    // print("oghab @@@@" + asyncProfiles.length);

    void goScreenLogin() {
      const LoginRoute().push(context).then((data) {
        print(
            "oghab @@@@ ppppppp2 ${globals.globalToken} ${globals.globalCheckGetListServer}");
        if (globals.globalCheckGetListServer == true) {
          GetListAccountServer(
            context,
            ref,
            addProfileProvider,
            deleteProfileMutation,
          );
          CustomToast.error("در حال ساختن  اکانت لطفا صبر نمایید")
              .show(context);
          isLoadingSubscription.value = true;

          Future.delayed(
            const Duration(seconds: 30),
            () => 100,
          ).then((value) {
            isLoadingSubscription.value = false;
            if (globals.globalCheckGetListServer == true) {
              GetListAccountServer(
                  context, ref, addProfileProvider, deleteProfileMutation);
            }

            print('The value is $value.'); // Prints later, after 3 seconds.
          });
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

    void exitApp(
        BuildContext context,
        WidgetRef ref,
        AutoDisposeNotifierProvider<AddProfile, AsyncValue<Unit?>>
            addProfileProvider,
        deleteProfileMutation) async {
      try {
        final DioHttpClient client = DioHttpClient(
            timeout: const Duration(seconds: 10),
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

          // 'username': user,
          // 'password': pass,
          // 'file': await MultipartFile.fromFile('./text.txt',filename: 'upload.txt')
        });
        print("oghab @@@ deviceID: ${deviceID}");

        final response = await client.post(
            // 'https://shop.hologate.pro/api/accounts' + params, formData);
            globals.global_url + '/api/accounts/log_out',
            formData);
        final jsonData = response.data!;
        print("oghab @@@ response: ${response}");

        if (response.statusCode == 200) {
          if (jsonData['success'] == true) {
            CustomToast.success(
                    jsonData['message']?.toString() ?? "باموفقیت انجام شد!")
                .show(context);
            final prefs = await SharedPreferences.getInstance();
            prefs.setString('token', '');
            prefs.setString('subscription', '');
            globals.globalToken = "";
            deleteProfileMutation.setFuture(
              ref
                  .read(profilesOverviewNotifierProvider.notifier)
                  .deleteAllProfile(),
            );
            goScreenLogin();
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
                    jsonData['message']?.toString() ?? "سرور با خطا مواجه شد!!")
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
        CustomToast.error("سرور با خطا مواجه شد!!").show(context);
        loggy.warning('Could not get the local country code from ip');
      }

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
          'unique_id': deviceID,
          'is_plus_device': true,
          'token_fb': globals.globalTokenFB,

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
            "oghab @@@ params: ${deviceID} ${globals.globalToken} ${globals.globalTokenFB}");

        final response = await client.post(
            globals.global_url + '/api/accounts/device-permission', formData);
        if (response.statusCode == 200) {
          final jsonData = response.data!;

          if (jsonData['success'] == true) {
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
    }

    useOnAppLifecycleStateChange((pref, state) {
      if (state == AppLifecycleState.resumed) {
        AuthenticationServer(context);
        //make a request
      }
    });
    Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)async{
      await Firebase.initializeApp();
      print('Handling a background message ${message.messageId}');
      debugPrint("Handling a background message: ${message.data}");
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // String? userCourseValue = prefs.getString('userCourse');
      // print(message.data['userCourse']);
      // print(userCourseValue);
     //  if(userCourseValue==message.data['userCourse']){
     // /*   AwesomeNotifications().createNotification(
     //        content: NotificationContent(
     //            id: 1,
     //            channelKey: message.notification!.android!.channelId ?? 'basic',
     //            title: message.notification!.title,
     //            body: message.notification!.body,
     //            bigPicture: message.notification!.android!.imageUrl,
     //            notificationLayout: NotificationLayout.BigPicture
     //        )
     //    );*/
     //  }
    }
    useEffect(
          ()  {
            // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            // FlutterLocalNotificationsPlugin();
            // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
            //   alert: true, // Required to display a heads up notification
            //   badge: true,
            //   sound: true,
            // );
            FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
            FirebaseMessaging.onMessage.listen((remoteMessage) {
              debugPrint('Got a message in the foreground');
              debugPrint('message data: ${remoteMessage.data}');

              if (remoteMessage.data['exit'] == "true") {
                CustomToast.success(remoteMessage.data['message']?.toString() ??
                    "شما توسط شخص دیگری بیرون انداخته شدید")
                    .show(context);
                exitApp(context, ref, addProfileProvider, deleteProfileMutation);
              }
              if (remoteMessage.notification != null) {
             /*   flutterLocalNotificationsPlugin.show(
                  notification.hashCode,
                  notification.title,
                  notification.body,
                  NotificationDetails(
                      android: AndroidNotificationDetails(
                        channel.id,
                        channel.name,
                      ),
                      iOS: const IOSNotificationDetails()),
                );*/
                debugPrint('message is a notification');
                // On Android, foreground notifications are not shown, only when the app
                // is backgrounded.
              }
            });

            print("oghab @@@@ @@@@@@@@ token " + globals.globalToken.toString());

        return null;

        // return () {
        //   print("oghab @@@@ @@@@@@@@ token " + globals.globalToken.toString());
        //
        //   // your dispose code
        // };
      } ,
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
                      const WidgetSpan(
                        child: AppVersionLabel(),
                        alignment: PlaceholderAlignment.middle,
                      ),
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
                      onPressed: () => GetListAccountServer(context, ref,
                          addProfileProvider, deleteProfileMutation),
                      icon: const Icon(FluentIcons.arrow_sync_24_regular),
                      tooltip: t.profile.add.buttonText,
                    ),
               if(1!=1)   IconButton(
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

              if (isLoadingSubscription.value == true &&
                  globals.globalCheckGetListServer == true)
                MultiSliver(children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    // color: Colors.blue.withOpacity(0.6),
                    //  color: Colors.pink,
                    padding: const EdgeInsets.all(10),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                                'در حال ساختن اکانت. لطفا صبر نمایید ...')),
                        CircularProgressIndicator()
                      ],
                    ),
                  )
                ]),
              switch (activeProfile) {
                AsyncData(value: final profile?) => MultiSliver(
                    children: [
                      ProfileTile(profile: profile, isMain: true),
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
        ],
      ),
    );
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
          timeout: const Duration(seconds: 10),
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

  Future<void> GetListAccountServer(
      BuildContext context,
      WidgetRef ref,
      AutoDisposeNotifierProvider<AddProfile, AsyncValue<Unit?>>
          addProfileProvider,
      dynamic deleteProfileMutation) async {
    var deviceID = await get_unique_identifier();

    final prefs = await SharedPreferences.getInstance();
    var id_device = prefs.getString('id_device') ?? '';
    final String stringifiedString = jsonEncode(deviceID);
//   var subscription = prefs.getString('subscription')! + "?unique_id=" + stringifiedString! ??'';
    var subscription =
        prefs.getString('subscription')! + "?unique_id=" + deviceID! ?? '';
    //  var subscription = "https://hologate6.com:83/sub/c259f0a0afeadeaae48c9ecb33f9154a?unique_id=%22a6lte%20-%20SM-A600F%20-%20QP1A.190711.020%22";
    // var subscription = prefs.getString('subscription') ?? '';

    // Clipboard.setData(new ClipboardData(text: subscription));

    print("oghab @@@@ subscription  " +
        subscription +
        "  ----   " +
        id_device +
        "  ----   ");
    // print("oghab @@@@ subscription 2222  " + activeProfile.toString());

    globals.globalCheckGetListServer = false;
    //await ref.read(addProfileProvider.notifier).ge(subscription);
    deleteProfileMutation.setFuture(
      ref.read(profilesOverviewNotifierProvider.notifier).deleteAllProfile(),
    );
    await ref.read(addProfileProvider.notifier).add(subscription);
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
          timeout: const Duration(seconds: 10),
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
