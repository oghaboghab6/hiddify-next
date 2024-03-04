import 'package:flutter/material.dart';
import 'package:hiddify/core/app_info/app_info_provider.dart';
import 'package:hiddify/core/localization/translations.dart';
import 'package:hiddify/core/model/failures.dart';
import 'package:hiddify/features/app_update/notifier/app_update_notifier.dart';
import 'package:hiddify/features/app_update/notifier/app_update_state.dart';
import 'package:hiddify/features/app_update/widget/new_version_dialog.dart';

import 'package:hiddify/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends HookConsumerWidget {

 const  WebViewPage({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = WebViewController();

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
      ..loadRequest(Uri.parse('https://shop.hologate.pro'));
    final t = ref.watch(translationsProvider);
    final appInfo = ref.watch(appInfoProvider).requireValue;
    final appUpdate = ref.watch(appUpdateNotifierProvider);
    final TextEditingController nameController = TextEditingController();
    final  TextEditingController passwordController = TextEditingController();
    ref.listen(
      appUpdateNotifierProvider,
          (_, next) async {
        if (!context.mounted) return;
        switch (next) {
          case AppUpdateStateAvailable(:final versionInfo) ||
          AppUpdateStateIgnored(:final versionInfo):
            return NewVersionDialog(
              appInfo.presentVersion,
              versionInfo,
              canIgnore: false,
            ).show(context);
          case AppUpdateStateError(:final error):
            return CustomToast.error(t.presentShortError(error)).show(context);
          case AppUpdateStateNotAvailable():
            return CustomToast.success(t.appUpdate.notAvailableMsg)
                .show(context);
        }
      },
    );

    return Scaffold(
      body: SafeArea(
        child: AspectRatio(
            aspectRatio: 9 / 16, child: WebViewWidget(controller: controller),),
      ),
    );
  }
}
