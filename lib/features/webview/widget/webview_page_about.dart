import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hiddify/utils/globals.dart' as globals;
import '../../../utils/uri_utils.dart';
import 'custom_webview.dart';

class WebViewAboutPage extends HookConsumerWidget {
  const WebViewAboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var token = "";
    token = globals.globalToken.replaceAll("Bearer ", "");

    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Scaffold(
      appBar: AppBar(title: const Text('راهنما')),
      body: Container(
        margin: const EdgeInsets.only(
          top: 30.0,
        ),
        // child: WebViewWidget(controller: controller),
        child: Platform.isWindows
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                    Expanded(
                      child: Container(
                      //  color: Colors.blue,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text('برای مطالعه راهنمای اتصال در اپلیکیشن هلوگیت پلاس و انجام تنظیمات لازم، روی لینک زیر کلیک کنید'),
                            SizedBox(height: 15),
                            OutlinedButton.icon(
                              // onPressed: () => const AddProfileRoute().push(context),
                              // onPressed: () =>{const LoginRoute().push(context)} ,
                              onPressed: () async {
                                // const ConfigDeviceRoute().push(context);
                                // const ConfigDeviceRoute2().push(context);

                                await UriUtils.tryLaunch(
                                  Uri.parse(globals.global_url + "/hologate-plus"),
                                );
                              },
                              icon: const Icon(FluentIcons.web_asset_16_filled),
                              label: const Text("آموزش هلوگیت پلاس"),
                              // style: OutlinedButton.styleFrom(
                              //   side: BorderSide(width: 1.0, color: Color(0xffea5555)),
                              // ),
                            )
                          ],
                        ),
                      ),
                    )
                  ])
            /*IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    OutlinedButton.icon(
                      // onPressed: () => const AddProfileRoute().push(context),
                      // onPressed: () =>{const LoginRoute().push(context)} ,
                      onPressed: () async {
                        // const ConfigDeviceRoute().push(context);
                        // const ConfigDeviceRoute2().push(context);

                        await UriUtils.tryLaunch(
                          Uri.parse(globals.global_url + "/hologate-plus"),
                        );
                      },
                      icon: const Icon(FluentIcons.web_asset_16_filled),
                      label: const Text("باز کردن سایت"),
                      // style: OutlinedButton.styleFrom(
                      //   side: BorderSide(width: 1.0, color: Color(0xffea5555)),
                      // ),
                    )
                    // Expanded(...)
                  ],
                ),
              )*/
            : InAppWebViewExampleScreen(
                urlString: globals.global_url + "/hologate-plus"),
      ),
    );
  }
}
