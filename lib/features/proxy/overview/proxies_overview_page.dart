import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hiddify/core/localization/translations.dart';
import 'package:hiddify/core/model/failures.dart';
import 'package:hiddify/features/common/nested_app_bar.dart';
import 'package:hiddify/features/proxy/overview/proxies_overview_notifier.dart';
import 'package:hiddify/features/proxy/widget/proxy_tile.dart';
import 'package:hiddify/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/http_client/dio_http_client.dart';
import 'package:hiddify/utils/globals.dart' as globals;

import '../../../core/router/app_router.dart';
import '../../connection/notifier/connection_notifier.dart';

class ProxiesOverviewPage extends HookConsumerWidget with PresLogger {
  const ProxiesOverviewPage({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(translationsProvider);

    final asyncProxies = ref.watch(proxiesOverviewNotifierProvider);
    final notifier = ref.watch(proxiesOverviewNotifierProvider.notifier);
    final sortBy = ref.watch(proxiesSortNotifierProvider);

    final selectActiveProxyMutation = useMutation(
      initialOnFailure: (error) =>
          CustomToast.error(t.presentShortError(error)).show(context),
    );

    final appBar = NestedAppBar(
      title: Text(t.proxies.pageTitle),
      actions: [
        PopupMenuButton<ProxiesSort>(
          initialValue: sortBy,
          onSelected: ref.read(proxiesSortNotifierProvider.notifier).update,
          icon: const Icon(FluentIcons.arrow_sort_24_regular),
          tooltip: t.proxies.sortTooltip,
          itemBuilder: (context) {
            return [
              ...ProxiesSort.values.map(
                (e) => PopupMenuItem(
                  value: e,
                  child: Text(e.present(t)),
                ),
              ),
            ];
          },
        ),
      ],
    );

    switch (asyncProxies) {
      case AsyncData(value: final groups):
        if (groups.isEmpty) {
          return Scaffold(
            body: CustomScrollView(
              slivers: [
                appBar,
                SliverFillRemaining(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(t.proxies.emptyProxiesMsg),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {}

        final group = groups.first;



        useEffect(
              () {
                if(globals.globalIsAdmin){
                  loggy.warning('oghab @@@ proxy121' + group.toString());

                 Future.delayed(
                const Duration(seconds: 10),
                () => 100,
                ).then((value) async{
                 await  ref
                       .read(connectionNotifierProvider.notifier)
                       .toggleConnection();
                  setLogSpeedServer(context, groups.first.items);});
              }

            return null;

            // return () {
            //   print("oghab @@@@ @@@@@@@@ token " + globals.globalToken.toString());
            //
            //   // your dispose code
            // };
          } ,
          [],
        );

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              appBar,
              SliverLayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.crossAxisExtent;
                  if (!PlatformUtils.isDesktop && width < 648) {
                    return SliverPadding(
                      padding: const EdgeInsets.only(bottom: 86),
                      sliver: SliverList.builder(
                        itemBuilder: (_, index) {
                          final proxy = group.items[index];
                          return ProxyTile(
                            proxy,
                            selected: group.selected == proxy.tag,
                            onSelect: () async {
                              if (selectActiveProxyMutation
                                  .state.isInProgress) {
                                return;
                              }
                              selectActiveProxyMutation.setFuture(
                                notifier.changeProxy(group.tag, proxy.tag),
                              );
                            },
                          );
                        },
                        itemCount: group.items.length,
                      ),
                    );
                  }

                  return SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (width / 268).floor(),
                      mainAxisExtent: 68,
                    ),
                    itemBuilder: (context, index) {
                      final proxy = group.items[index];
                      return ProxyTile(
                        proxy,
                        selected: group.selected == proxy.tag,
                        onSelect: () async {
                          if (selectActiveProxyMutation.state.isInProgress) {
                            return;
                          }
                          selectActiveProxyMutation.setFuture(
                            notifier.changeProxy(
                              group.tag,
                              proxy.tag,
                            ),
                          );
                        },
                      );
                    },
                    itemCount: group.items.length,
                  );
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async => {
              if(globals.globalIsAdmin){
                loggy.warning('oghab @@@ proxy' + group.toString()),
                await ref
                    .read(connectionNotifierProvider.notifier)
                    .toggleConnection(),
                await Future.delayed(
                  const Duration(seconds: 1),
                      () => 100,
                ).then((value) {  setLogSpeedServer(context, groups.first.items);}),
              },


              notifier.urlTest(group.tag)
            },
            tooltip: t.proxies.delayTestTooltip,
            //  child: const Icon(FluentIcons.flash_24_filled),
            label: Text("تست پینگ سرورها"),

            //   child: const Text("تست پینگ سرورها"),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );

      case AsyncError(:final error):
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              appBar,
              SliverErrorBodyPlaceholder(
                t.presentShortError(error),
                icon: null,
              ),
            ],
          ),
        );

      case AsyncLoading():
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              appBar,
              const SliverLoadingBodyPlaceholder(),
            ],
          ),
        );

      // TODO: remove
      default:
        return const Scaffold();
    }
  }

  Future<void> setLogSpeedServer(
      BuildContext context, List<dynamic> items) async {
    loggy.warning('oghab @@@ proxy setLogSpeedServer');

    List<dynamic> ListData = [];
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      loggy.warning('oghab @@@ proxy group.items' + item.toString());
      // add the ListTile to an array
      //  ListData.add(new ListTile(title: new Text(value[i].name));
      ListData.add({
        "name": item.tag,
        "urlTestDelay": item.urlTestDelay,
        "ping": (item.urlTestDelay != 65535),
      });
    }
    /* await  items.map((item) => {
  loggy.warning('oghab @@@ proxy group.items' + item.toString()),

      ListData.add({
        "name":item.selectedTag,
        "urlTestDelay":item.urlTestDelay,
        "ping":(item.urlTestDelay>0),
      })
    });*/
    try {
      var deviceID = await get_unique_identifier();

      final DioHttpClient client = DioHttpClient(
          timeout: const Duration(seconds: 10),
          userAgent:
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:123.0) Gecko/20100101 Firefox/123.0",
          debug: true,
          Authorization: globals.globalToken);

      var formData = FormData.fromMap({
        'unique_id': deviceID,
        'is_plus_device': true,
        'token_fb': globals.globalTokenFB,
        'platform': Platform.operatingSystem,
        'listConfig': json.encode(ListData)
      });
      loggy.warning('oghab @@@ proxy formData' + formData.fields.toString());

      final response = await client.post(
          globals.global_url + '/api/v2ray-server-ping', formData);
      if (response.statusCode == 200) {
        final jsonData = response.data!;

        //if (jsonData['success'] == true) {
        if (jsonData['success'] == true) {
          print('oghab @@@ response' + jsonData.toString());
        //  Navigator.of(context).pop();
          //  context.pop();
        } else {

          loggy.warning('Request failed with status2: ${response.statusCode}');
        }

      } else {

        loggy.warning('Request failed with status: ${response.statusCode}');
      }
      globals.globalCheckGetListServer=true;
      switchTab(0, context);
    } catch (e) {
      globals.globalCheckGetListServer=true;
      switchTab(0, context);
      loggy.warning('Could not get the local country code from ip');
    }
  }
}
