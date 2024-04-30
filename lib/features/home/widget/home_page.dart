import 'package:dartx/dartx.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
  Future<String> _loadPreferences(BuildContext context,
      WidgetRef ref,
      AutoDisposeNotifierProvider<AddProfile, AsyncValue<Unit?>>
      addProfileProvider,
      dynamic deleteProfileMutation) async {
    final prefs = await SharedPreferences.getInstance();
    globals.urlLink = prefs.getString('url_login') ?? globals.global_url;
    globals.globalToken = prefs.getString('token') ?? '';
    // print("oghab @@@@ 0 token " + globals.globalToken.toString());
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

  void exit(BuildContext context,
      WidgetRef ref,
      AutoDisposeNotifierProvider<AddProfile, AsyncValue<Unit?>>
      addProfileProvider,
      deleteProfileMutation) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', '');
    globals.globalToken = "";
    deleteProfileMutation.setFuture(
      ref.read(profilesOverviewNotifierProvider.notifier).deleteAllProfile(),
    );
    const LoginRoute().push(context).then((data) {
      // print("oghab @@@@ ppppppp2 " + globals.globalToken.toString());
      if (globals.globalCheckGetListServer)
        GetListAccountServer(
            context, ref, addProfileProvider, deleteProfileMutation);
      // then will return value when the loginscreen's pop is called.
    });

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

  void initHook(BuildContext context) {
    // WidgetsBinding.instance.addObserver(this);
  }

  // @override
  // void dispose() {
  //   WidgetsBinding.instance.removeObserver(this);
  // }
  //
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   print("app state now is $state");
  // }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children:  [
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
                  IconButton(
                    onPressed: () =>
                        const AddProfileRoute().push(context),
                    icon: const Icon(FluentIcons.add_circle_24_filled),
                    tooltip: t.profile.add.buttonText,
                  ),
                  IconButton(
                    onPressed: () =>
                        GetListAccountServer(context, ref,
                            addProfileProvider, deleteProfileMutation),
                    icon: const Icon(FluentIcons.server_12_filled),
                    tooltip: t.profile.add.buttonText,
                  ),
                  IconButton(
                    onPressed: () =>
                    {
                      if (globals.globalToken != "")
                        const WebViewRoute().push(context)
                      else
                        const LoginRoute().push(context).then((data) {
                          //  print("oghab @@@@ ppppppp2 ${globals.globalToken}");
                          if (globals.globalCheckGetListServer) {
                            GetListAccountServer(
                                context,
                                ref,
                                addProfileProvider,
                                deleteProfileMutation);
                          }
                          // then will return value when the loginscreen's pop is called.
                        }),
                    },
                    icon: const Icon(FluentIcons.cart_16_filled),
                    tooltip: t.profile.add.buttonText,
                  ),
                  IconButton(
                    onPressed: () =>
                    {
                      if (globals.globalToken != "")
                        exit(context, ref, addProfileProvider,
                            deleteProfileMutation)
                      else
                        const LoginRoute().push(context).then((data) {
                          //print("oghab @@@@ ppppppp2 ${globals.globalToken}");
                          if (globals.globalCheckGetListServer) {
                            GetListAccountServer(
                              context,
                              ref,
                              addProfileProvider,
                              deleteProfileMutation,
                            );
                            CustomToast.error(
                                "در حال ساختن  اکانت لطفا صبر نمایید")
                                .show(context);
                            Future.delayed(
                              const Duration(seconds: 30),
                                  () => 100,
                            ).then((value) {
                              GetListAccountServer(
                                  context,
                                  ref,
                                  addProfileProvider,
                                  deleteProfileMutation);
                              print(
                                  'The value is $value.'); // Prints later, after 3 seconds.

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
                        }),
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
                        icon:
                        const Icon(FluentIcons.arrow_sync_24_filled),
                        label: const Text("بروزرسانی اپلیکیسشن"),
                        // style: ButtonStyle( ),
                      ),
                    ),
                  ],
                ),
              switch (activeProfile) {
                AsyncData(value: final profile?) =>
                    MultiSliver(
                      children: [
                        ProfileTile(profile: profile, isMain: true),
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
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
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    ConnectionButton(),
                                    ActiveProxyDelayIndicator(),
                                  ],
                                ),
                              ),
                              if (MediaQuery
                                  .sizeOf(context)
                                  .width < 840)
                                const ActiveProxyFooter(),
                            ],
                          ),
                        ),
                      ],
                    ),
                AsyncData() =>
                switch (hasAnyProfile) {
                  AsyncData(value: true) =>
                  const EmptyActiveProfileHomeBody(),
                  _ => const EmptyProfilesHomeBody(),
                },
                AsyncError(:final error) =>
                    SliverErrorBodyPlaceholder(t.presentShortError(error)),
                _ => const SliverToBoxAdapter(),
              },
            ],
          ),
        ],
      ),
    );
  }

  Future<void> GetListAccountServer2233(BuildContext context,
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

  Future<void> GetListAccountServer(BuildContext context,
      WidgetRef ref,
      AutoDisposeNotifierProvider<AddProfile, AsyncValue<Unit?>>
      addProfileProvider,
      dynamic deleteProfileMutation) async {
    final prefs = await SharedPreferences.getInstance();
    var id_device = prefs.getString('id_device') ?? '';
    var subscription = prefs.getString('subscription') ?? '';
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

    final version = ref
        .watch(appInfoProvider)
        .requireValue
        .presentVersion;
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
