import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart';

// import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:hiddify/utils/globals.dart' as globals;

import '../../../core/localization/translations.dart';
import '../../common/nested_app_bar.dart';
import '../../home/widget/home_page.dart';

class WebViewAboutPage extends HookConsumerWidget {
  const WebViewAboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = WebViewController();

    var token = "";
    token = globals.globalToken.replaceAll("Bearer ", "");
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
      ..loadRequest(Uri.parse(globals.global_url+"/hologate-plus"));
    final t = ref.watch(translationsProvider);

/*    return Scaffold(
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

              ),
              if (1 == 1)
                MultiSliver(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28.0, vertical: 6.0),
                      child: AspectRatio(
                        aspectRatio: 9 / 16,
                        child: WebViewWidget(controller: controller),
                      )
                    ),
                  ],
                ),

              // SafeArea(
              //   child: AspectRatio(
              //     aspectRatio: 9 / 16,
              //     child: WebViewWidget(controller: controller),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );*/
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Scaffold(
     // appBar: AppBar(title: const Text('Flutter Simple Example')),
      body:  Container(
        margin: const EdgeInsets.only(top: 30.0,),
        child: WebViewWidget(controller: controller),
      ),
    );
   /* return Scaffold(
      body:  Transform.scale(
        scale: controller.value.aspectRatio/deviceRatio,
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child:  WebViewWidget(controller: controller),
        ),
      ),
    );*/
/*    return Scaffold(
      body: SafeArea(
        child: AspectRatio(
          aspectRatio: 8 / 15,
          child: WebViewWidget(controller: controller),
        ),
      ),
    );*/
    return Scaffold(
      body: SafeArea(
        child: AspectRatio(
          aspectRatio: 8 / 15,
          child: WebViewWidget(controller: controller),
        ),
      ),
    );
/*    return Scaffold(
      body: Container(
          child: Column(children: <Widget>[
            Expanded(
                child: InAppWebView(
                  initialUrl:
                  "https://shoham.biu.ac.il/BiuCoursesViewer/MainPage.aspx",
                  initialHeaders: {},
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                        debuggingEnabled: true,
                        preferredContentMode: UserPreferredContentMode.DESKTOP),
                  ),
                  onWebViewCreated: (InAppWebViewController controller) {
                    webView = controller;
                  },
                  onLoadStart: (InAppWebViewController controller, String url) {

                  },
                  onLoadStop: (InAppWebViewController controller, String url) async {

                  },
                ))
          ])),
    );*/
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
