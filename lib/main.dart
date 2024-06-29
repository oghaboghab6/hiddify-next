import 'package:flutter/widgets.dart';
import 'package:hiddify/bootstrap.dart';
import 'package:hiddify/core/model/environment.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

// external ConnectionNotifier get ref;

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message)async{
//
//   debugPrint("Handling a background message: ${message.data}");
//   final prefs = await SharedPreferences.getInstance();
//   prefs.setString('token', '');
//   prefs.setString('subscription', '');
//   globals.globalToken = "";
//
//   // await _connectionRepo.disconnect().mapLeft((err) {
//   //   // loggy.warning("error disconnecting", err);
//   //   // state = AsyncError(err, StackTrace.current);
//   // }).run();
//   // await ref.read(configOptionNotifierProvider.future).then(
//   //       (value) => value.hasExperimentalOptions(),
//   //   onError: (_) => false,
//   // );
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
//  final uncompletedTodosCount = Provider<int>((ref) {
//   return ref.read(connectionNotifierProvider.notifier).toggleConnection();
// });
// final nameProvider = Provider<String>(
// (ref){ return ref.read(connectionNotifierProvider.notifier).toggleConnection() };
// );
/*
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
  final notification = message.notification;
  if (notification != null) {
    print(notification.title);
    print(notification.body);
  }
  // final appBadgeCounter = ConnectionNotifier();
  // await appBadgeCounter.toggleConnection();
  await globals.global_ref.read(connectionNotifierProvider.notifier).abortConnection();
  //await _disconnect();
  // ProviderContainer().read(connectionNotifierProvider.notifier).abortConnection();
 // await ProviderContainer().read(connectionNotifierProvider.notifier).disconnectVpn();
 // await modelProvider.read(connectionNotifierProvider.notifier).disconnectVpn();

//  await ProviderContainer().read(connectionNotifierProvider.notifier).toggleConnection();
 // ref.read(connectionNotifierProvider.notifier).toggleConnection()
  // Create a notification for this
}
*/

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  await Firebase.initializeApp();

  // Background Message Handler

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
/*  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // final prefs = await SharedPreferences.getInstance();
  //
  // await prefs.setString("ipv6-mode", "prefer_ipv6");
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

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
    print('User granted permission2');
    String? gg=await FirebaseMessaging.instance.getToken();
    print(gg);
    globals.globalTokenFB=gg!;

  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }*/
  return lazyBootstrap(widgetsBinding, Environment.dev);
}
