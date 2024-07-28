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
     // appBar: AppBar(title: const Text('Flutter Simple Example')),
      body:  Container(
        margin: const EdgeInsets.only(top: 30.0,),
       // child: WebViewWidget(controller: controller),
        child: Platform.isWindows?     OutlinedButton.icon(
          // onPressed: () => const AddProfileRoute().push(context),
          // onPressed: () =>{const LoginRoute().push(context)} ,
          onPressed: () async {
            // const ConfigDeviceRoute().push(context);
            // const ConfigDeviceRoute2().push(context);

            await UriUtils.tryLaunch(
              Uri.parse(globals.global_url+"/hologate-plus"),
            );
          },
          icon: const Icon(FluentIcons.web_asset_16_filled),
          label: const Text("باز کردن سایت"),
          // style: OutlinedButton.styleFrom(
          //   side: BorderSide(width: 1.0, color: Color(0xffea5555)),
          // ),
        ) :InAppWebViewExampleScreen(urlString:globals.global_url+"/hologate-plus"),
      ),
    );

  }
}

