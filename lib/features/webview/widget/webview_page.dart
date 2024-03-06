import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:hiddify/utils/globals.dart' as globals;

class WebViewPage extends HookConsumerWidget {
  const WebViewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = WebViewController();

    var token = "";
    token = globals.globalToken.replaceAll("Bearer ", "");
    print("oghab @@@@ url" + 'https://shop.hologate.pro/login/' + token);
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      // ..loadRequest(Uri.parse('https://shop.hologate.pro/login/' + token));
      ..loadRequest(Uri.parse(globals.urlLink));

    return Scaffold(
      body: SafeArea(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: WebViewWidget(controller: controller),
        ),
      ),
    );
  }
}

/*

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WebViewPageState();
  }
}

class _WebViewPageState extends State {
  // var url_link="";
  // @override
  // // ignore: must_call_super
  // initState() {
  //   super.initState();
  //   getUrl();
  // }
  // getUrl() async{
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   url_link=  prefs.getString('url_login').toString();
  //   // ignore: avoid_print
  //   print("initState Called"+url_link);
  //
  // }
  @override
  Widget build(BuildContext context) {
    final controller = WebViewController();

    var token = "";
    token=  globals.globalToken.replaceAll("Bearer ", "");
    // print("oghab @@@@ url"+'https://shop.hologate.pro/login/'+token);
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
     // ..loadRequest(Uri.parse('https://shop.hologate.pro/login/'+token));
      ..loadRequest(Uri.parse(globals.urlLink));



    return Scaffold(
      body: SafeArea(
        child: AspectRatio(
          aspectRatio: 9 / 16, child: WebViewWidget(controller: controller),),
      ),
    );
  }
}*/
