import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:hiddify/singbox/service/singbox_service.dart';
import 'package:hiddify/utils/link_parsers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/http_client/dio_http_client.dart';
import 'features/connection/data/connection_data_providers.dart';
import 'features/connection/data/connection_repository.dart';
import 'features/connection/notifier/connection_notifier.dart';
import 'firebase_options.dart';
import 'package:hiddify/utils/globals.dart' as globals;





import 'package:dio/dio.dart';

// import 'package:hiddify/utils/utils.dart';





late final SingboxService singbox;

// WidgetRef refff;
late WidgetRef refff;

class MessagingService {
  static String? fcmToken; // Variable to store the FCM token
  // static WidgetRef? refff; // Variable to store the FCM token
  static final MessagingService _instance = MessagingService._internal();
  factory MessagingService() => _instance;
  // static final ConnectionRepository  _connectionRepo ;

  MessagingService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init(BuildContext context,  WidgetRef ref) async {
    // final pushNotificationHandlerProvider =   Provider((ref) => _firebaseMessagingBackgroundHandler(ref as RemoteMessage));

    final ConnectionRepository  _connectionRepo = ref.read(connectionRepositoryProvider);
    // final ProviderListenable  tttttttt = ref.read(connectionNotifierProvider.notifier );
      refff=ref ;
    // Requesting permission for notifications
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint(
        'User granted notifications permission: ${settings.authorizationStatus}');

    // Retrieving the FCM token
    fcmToken = await _fcm.getToken();
    log('fcmToken: $fcmToken');
    globals.globalTokenFB=fcmToken!;
    // Handling background messages using the specified handler
    //  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler(BackgroundMessageHandler as RemoteMessage ,  aa: _connectionRepo) as BackgroundMessageHandler);
     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
  //   print('Handling a background message۰۰۰۰۰۰ ${message.messageId}');
  //   await handleMessage(message, ref);
  //   // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  //   // print('Handling a background message۰۰۰۰۰۰ ${message.messageId}');
  // });

    // Listening for incoming messages while the app is in the foreground
/*    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.notification!.title.toString()}');

      if (message.notification != null) {
        if (message.notification!.title != null &&
            message.notification!.body != null) {
          final notificationData = message.data;
          final screen = notificationData['screen'];

          // Showing an alert dialog when a notification is received (Foreground state)
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return WillPopScope(
                onWillPop: () async => false,
                child: AlertDialog(
                  title: Text(message.notification!.title!),
                  content: Text(message.notification!.body!),
                  actions: [
                    if (notificationData.containsKey('screen'))
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                         // Navigator.of(context).pushNamed(screen);
                        },
                        child: const Text('Open Screen'),
                      ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Dismiss'),
                    ),
                  ],
                ),
              );
            },
          );
        }
      }
    });*/

    // Handling the initial message received when the app is launched from dead (killed state)
    // When the app is killed and a new notification arrives when user clicks on it
    // It gets the data to which screen to open
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationClick(context, message);
      }
    });

    // Handling a notification click event when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint(
          'onMessageOpenedApp: ${message.notification!.title.toString()}');
      _handleNotificationClick(context, message);
    });
  }

  // Handling a notification click event by navigating to the specified screen
  void _handleNotificationClick(BuildContext context, RemoteMessage message) {
    final notificationData = message.data;

    if (notificationData.containsKey('screen')) {
      final screen = notificationData['screen'];
    //  Navigator.of(context).pushNamed(screen);
    }
  }
}
Future<void> handleMessage(RemoteMessage message, WidgetRef ref) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  print('Handling a background message ${message.messageId}');
  final notification = message.notification;
  if (notification != null) {
    print(notification.title);
    print(notification.body);
  }
  await ref.read(connectionNotifierProvider.notifier).toggleConnection();
}
// // Handler for background messages
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message,{required ConnectionRepository  aa}) async {
//   print('Handling a background message22226667777yyyyyy: ${message.notification!.title}');
//   debugPrint('Handling a background message22226667777: ${message.notification!.title}');
//
//   await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform,);
//   debugPrint('Handling a background message2222666: ${message.notification!.title}');
//   // await globals.global_ref.read(connectionNotifierProvider.notifier).abortConnection();
//   // await aa.disconnect().mapLeft((err) {
//   //     // loggy.warning("error disconnecting", err);
//   //     // state = AsyncError(err, StackTrace.current);
//   //   }).run();
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   debugPrint('Handling a background message6666: ${message.notification!.title}');
// }
/*Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  print('Handling a background message ${message.messageId}');
  final notification = message.notification;
  if (notification != null) {
    print(notification.title);
    print(notification.body);
  }
  // final appBadgeCounter = ConnectionNotifier();
  // await appBadgeCounter.toggleConnection();
  // await globals.global_ref.read(connectionNotifierProvider.notifier).abortConnection();

 // await MessagingService.refff?.read(connectionNotifierProvider.notifier).abortConnection();
 //  await ProviderContainer().read(connectionNotifierProvider.notifier).abortConnection();
  final container = ProviderContainer(
    overrides: [
      environmentProvider.overrideWithValue(Environment.dev),
    ],
  );
   container.read(connectionNotifierProvider.notifier).toggleConnection();
  await container.read(connectionNotifierProvider.notifier).toggleConnection();
  // await globals.global_container.read(connectionNotifierProvider.notifier).abortConnection();

  //await _disconnect();
  // ProviderContainer().read(connectionNotifierProvider.notifier).abortConnection();
  // await ProviderContainer().read(connectionNotifierProvider.notifier).disconnectVpn();
  // await modelProvider.read(connectionNotifierProvider.notifier).disconnectVpn();

//  await ProviderContainer().read(connectionNotifierProvider.notifier).toggleConnection();
  // ref.read(connectionNotifierProvider.notifier).toggleConnection()
  // Create a notification for this
}*/
// Handler for background messages
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   debugPrint('Handling a background message2222: ${message.notification!.title}');
//   final prefs = await SharedPreferences.getInstance();
//
//
//
//   prefs.setString('token', '');
//   prefs.setString('subscription', '');
//   globals.globalToken = "";
//   exit(0);
//  // context.read(connectionNotifierProvider.notifier).toggleConnection();
//   // Provider.of<CarsProvider>(context, listen: false).yourFunction();
//  // await singbox.stop().mapLeft(UnexpectedConnectionFailure.new);
//  //  Future.delayed(const Duration(milliseconds: 100), () {
//  //    final prefs = await SharedPreferences.getInstance();
//  //    prefs.setString('token', '');
//  //    prefs.setString('subscription', '');
//  //    globals.globalToken = "";
//  //    exit(0);
//  //  });  //  const channelPrefix = "holo.gate.app2";
//   //
//   //  const methodChannel = MethodChannel("$channelPrefix/method");
//   // await methodChannel.invokeMethod("stop");
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   debugPrint('Handling a background message: ${message.notification!.title}');
//   //ref.read(connectionNotifierProvider.notifier).func();
// }
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message2222: ${message.notification!.title}');
  if (message.data['exit'] == "true") {
    final prefs = await SharedPreferences.getInstance();

    String token = await prefs.getString('token')??'';
    if(token!=''){
      var deviceID = await get_unique_identifier();
      final DioHttpClient client = DioHttpClient(
          timeout: const Duration(seconds: 10),
          userAgent:
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:123.0) Gecko/20100101 Firefox/123.0",
          debug: true,
          Authorization: token);
      // final response =
      // await client.get<Map<String, dynamic>>('https://shop.hologate.pro/api/login');

      var formData = FormData.fromMap({
        'token': token,
        'unique_id': deviceID,
        'is_plus_device': true,
      });
      print("oghab @@@ deviceID: ${deviceID} ${token} ${globals
          .global_url}");

      final response = await client.post(
        // 'https://shop.hologate.pro/api/accounts' + params, formData);
          globals.global_url + '/api/accounts/log_out',
          formData);
      // final prefs2 = await SharedPreferences.getInstance();

      prefs.setString('token', '');
      prefs.setString('subscription', '');
      // globals.globalToken = "";
      print("oghab @@@ response bacccck: ${response}");

      Future.delayed(const Duration(milliseconds: 100), () {
        exit(0);
      });
      // context.read(connectionNotifierProvider.notifier).toggleConnection();
      // Provider.of<CarsProvider>(context, listen: false).yourFunction();
      // await singbox.stop().mapLeft(UnexpectedConnectionFailure.new);
      //  Future.delayed(const Duration(milliseconds: 100), () {
      //    final prefs = await SharedPreferences.getInstance();
      //    prefs.setString('token', '');
      //    prefs.setString('subscription', '');
      //    globals.globalToken = "";
      //    exit(0);
      //  });  //  const channelPrefix = "holo.gate.app2";
      //
      //  const methodChannel = MethodChannel("$channelPrefix/method");
      // await methodChannel.invokeMethod("stop");
      // If you're going to use other Firebase services in the background, such as Firestore,
      // make sure you call `initializeApp` before using other Firebase services.
    }

    debugPrint('Handling a background message: ${message.notification!.title}');
    //ref.read(connectionNotifierProvider.notifier).func();
  }
  else if (message.data['refresh'] == "true") {
    debugPrint('Handling a background message: ${message.notification!.title}');
    Future.delayed(const Duration(milliseconds: 100), () {
      exit(0);
    });
  }
}