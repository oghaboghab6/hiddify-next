import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hiddify/core/http_client/dio_http_client.dart';
import 'package:hiddify/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hiddify/utils/globals.dart' as globals;
import 'package:hiddify/utils/link_parsers.dart';

import '../../../core/router/routes.dart';

/*class MyHomePage extends StatefulWidget {
  @override
  ConfigDevicePage createState() => ConfigDevicePage();
}
class ConfigDevicePage extends State<MyHomePage>  with PresLogger {
  // late final List<String,dynamic> products=[{"id":1,"name":""}];
  late final List<Map<String, dynamic>> products = [{"id":1,"name":"ahmad"}];
  // const ConfigDevicePage({super.key});
  @override
  void initState() {
    super.initState();
   // RequestServer(context);
  }
  @override
  Widget build(BuildContext context) {

    // final TextEditingController nameController = TextEditingController();
    // final TextEditingController passwordController = TextEditingController();



    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'HoloGate',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
          if(products.isNotEmpty)  ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(products[index]['name'].toString()),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Does not have account?'),
                TextButton(
                  child: const Text(
                    'send',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () async {
                    await UriUtils.tryLaunch(
                      Uri.parse("https://shop.hologate.pro/register?type=android"),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> RequestServer(BuildContext context) async {
    try {
      final DioHttpClient client = DioHttpClient(
          timeout: const Duration(seconds: 10),
          userAgent:
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:123.0) Gecko/20100101 Firefox/123.0",
          debug: true);
      // final response =
      // await client.get<Map<String, dynamic>>('https://shop.hologate.pro/api/login');
      var formData = FormData.fromMap({
        // 'username': user,
        // 'password': pass,
        // 'file': await MultipartFile.fromFile('./text.txt',filename: 'upload.txt')
      });
     var deviceID= await get_unique_identifier();

      var device_model= await  get_info_device();
     var device_code=await  get_info_device();
   //  var params = "?username=${user}&password=${pass}&platform=android&token_fb=null&unique_id=${deviceID}&&device_model=${device_model}&&device_code=${device_code}";
     var params = "?platform=android&token_fb=null&unique_id=${deviceID}&&device_model=${device_model}&&device_code=${device_code}";
    //  loggy.warning('oghab @@@ params: ${params}');
      print("oghab @@@ params: ${params}");

      final response =
          await client.post('https://shop.hologate.pro/api/login'+params, formData);
      if (response.statusCode == 200) {
        globals.globalCheckGetListServer=true;

        final jsonData = response.data!;
        var access_token=jsonData['access_token']?.toString() ?? "";
        var token_type=jsonData['token_type']?.toString() ?? "";
        var loginUrl=jsonData['login_url']?.toString() ?? "";

        // loggy.debug(
        //   'oghab @@@: ${access_token}   ${token_type} ',
        // );
       final SharedPreferences prefs = await SharedPreferences.getInstance();
       var token=token_type +" "+access_token;
        globals.globalToken=token;
       await prefs.setString('token', token);
       await prefs.setString('url_login', loginUrl);
         Navigator.of(context).pop();
        // Navigator.of(context).popUntil(ModalRoute.withName('/'));
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

}*/
final isLoadingProvider = StateProvider((ref) => false);

class ConfigDevicePage extends StatefulHookConsumerWidget {
  //const ConfigDevicePage(this.child, {super.key});
  const ConfigDevicePage({super.key});

  //final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConnectionWrapperState();
}

class _ConnectionWrapperState extends ConsumerState<ConfigDevicePage>
    with PresLogger {
  late List products = [
    // {"id": 1, "name": "hologate256997"},
    // {"id": 2, "name": "hologate005781"}
  ];

  // late  List<Map<String, dynamic>> products = [
  //   // {"id": 1, "name": "hologate256997"},
  //   // {"id": 2, "name": "hologate005781"}
  // ];
  late final List<Map<String, dynamic>> products2 = [
    // {"id": 1, "name": "g1.hologate.pro", "type": "ssh"},
    // {"id": 2, "name": "g25.hologate.com", "type": "v2ray"}
  ];
  int _check = 1;
  String account_id = "0";
  bool checkLoading = true;

  //final isLoading.value = useState(false);
 // bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // final isLoading.value = useState(false);

    //   RequestServer(context);
  }



  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    Future<void> GetRequestServer(BuildContext context) async {

      if(   checkLoading ==true){
        checkLoading =false;
        isLoading.value = true;

        try {
          final DioHttpClient client = DioHttpClient(
              timeout: const Duration(seconds: 10),
              userAgent:
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:123.0) Gecko/20100101 Firefox/123.0",
              debug: true,
              Authorization: globals.globalTokenTemporary);
          // final response =
          // await client.get<Map<String, dynamic>>('https://shop.hologate.pro/api/login');

          var deviceID = await get_unique_identifier();

          var device_model = await get_info_device();
          var device_code = await get_info_device();
          //  var params = "?username=${user}&password=${pass}&platform=android&token_fb=null&unique_id=${deviceID}&&device_model=${device_model}&&device_code=${device_code}";
          // var params =
          //     "?platform=android&token_fb=null&unique_id=${deviceID}&&device_model=${device_model}&&device_code=${device_code}";
          // //  loggy.warning('oghab @@@ params: ${params}');
          // print("oghab @@@ params: ${params}");
          var formData = FormData.fromMap({
            'unique_id': deviceID,
            'is_plus_device': true,
            'platform': Platform.operatingSystem,
            // 'username': user,
            // 'password': pass,
            // 'file': await MultipartFile.fromFile('./text.txt',filename: 'upload.txt')
          });
          final response = await client.post(
            // 'https://shop.hologate.pro/api/accounts' + params, formData);
              globals.global_url + '/api/accounts',
              formData);
          final jsonData = response.data!;
          isLoading.value = false;

          if (response.statusCode == 200) {
            if (jsonData['success'] == true) {
              var access_token = jsonData['access_token']?.toString() ?? "";
              setState(() {
                products = jsonData['accounts'] as List;
                // products=[
                //   {"id": 1, "name": "hologate256997"},
                //   {"id": 2, "name": "hologate005781"}
                // ];
              });
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
          isLoading.value = false;

          CustomToast.error("سرور با خطا مواجه شد!!!").show(context);
          loggy.warning('Could not get the local country code from ip');
        }
      }

    }
    Future<void> SetRequestServer_subScription(BuildContext context) async {
      isLoading.value = true;

      try {
        var deviceID = await get_unique_identifier();

        final DioHttpClient client = DioHttpClient(
            timeout: const Duration(seconds: 10),
            userAgent:
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:123.0) Gecko/20100101 Firefox/123.0",
            debug: true,
            Authorization: globals.globalTokenTemporary);
        // final response =
        // await client.get<Map<String, dynamic>>('https://shop.hologate.pro/api/login');
        var formData = FormData.fromMap({
          'device_id': null,
          'unique_id': deviceID,
          'is_plus_device': true,
          'platform': Platform.operatingSystem,
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
        // print("oghab @@@ params: ${params}");

        final response = await client.post(
            globals.global_url + '/api/accounts/get-subscription', formData);
        isLoading.value = false;

        if (response.statusCode == 200) {
          final jsonData = response.data!;

          if (jsonData['success'] == true) {
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            globals.globalToken = globals.globalTokenTemporary;
            await prefs.setString('token', globals.globalTokenTemporary);
            globals.globalCheckGetListServer = true;
            globals.globalWaitingGetListServer = true;
            if (jsonData['subscription'].toString() != 'null') {
              print(
                  "oghab @@@ subscriptionrrrrr: ${jsonData['subscription'].toString()}");
              final SharedPreferences prefs =
              await SharedPreferences.getInstance();
              await prefs.setString(
                  'subscription', jsonData['subscription'].toString());
              // Navigator.of(context).pop();
              // Navigator.of(context).popUntil((route) => route.isFirst);
              // Navigator.of(context)
              //   ..pop()
              //   ..pop();
              Navigator.of(context).popUntil((route) => route.isFirst);
            } else
              CustomToast.error(jsonData['message']?.toString() ??
                  "سروری موجود نیست مجداد تلاش نمایید ")
                  .show(context);
            //   Navigator.of(context).popUntil((route) => false);
            // Navigator.of(context).pop();
            // Navigator.of(context).popUntil((route) => route.isFirst);
            // Navigator.of(context)
            //   ..pop()
            //   ..pop();
            // Navigator.of(context).popUntil((route) => route.isFirst);

            // Navigator.of(context).popUntil(ModalRoute.withName('/'));
            // final regionLocale =
            // _getRegionLocale(jsonData['country_code']?.toString() ?? "");
            //
            // loggy.debug(
            //   'Region: ${regionLocale.region} Locale: ${regionLocale.locale}',
            // );
          } else {
            // CustomToast.error(((jsonData['message']?.toString())!.length > 0)
            //         ? jsonData['message'].toString()
            //         : "سرور با خطا مواجه شد!!")
            //     .show(context);
            CustomToast.error(
                jsonData['message']?.toString() ?? "سرور با خطا مواجه شد!!")
                .show(context);
          }
        } else {
          CustomToast.error("سرور با خطا مواجه شد!").show(context);

          loggy.warning('Request failed with status: ${response.statusCode}');
        }
      } catch (e) {
        isLoading.value = false;

        CustomToast.error("سرور با خطا مواجه شد!!!").show(context);

        loggy.warning('Could not get the local country code from ip');
      }
    }

    Future<void> SetRequestServer(BuildContext context) async {
      isLoading.value = true;

      try {
        var deviceID = await get_unique_identifier();
        print("oghab @@@ globalToken " +
            globals.globalToken +
            "  -   " +
            account_id);
        final DioHttpClient client = DioHttpClient(
            timeout: const Duration(seconds: 10),
            userAgent:
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:123.0) Gecko/20100101 Firefox/123.0",
            debug: true,
            Authorization: globals.globalTokenTemporary);
        // final response =
        // await client.get<Map<String, dynamic>>('https://shop.hologate.pro/api/login');
        var formData = FormData.fromMap({
          'account_id': account_id,
          'is_plus_device': true,
          'unique_id': deviceID,
          'platform': Platform.operatingSystem,
          // 'password': pass,
          // 'file': await MultipartFile.fromFile('./text.txt',filename: 'upload.txt')
        });

        // var device_model = await get_info_device();
        // var device_code = await get_info_device();
        //  var params = "?username=${user}&password=${pass}&platform=android&token_fb=null&unique_id=${deviceID}&&device_model=${device_model}&&device_code=${device_code}";
        // var params =
        //     "?platform=android&token_fb=null&unique_id=${deviceID}&&device_model=${device_model}&&device_code=${device_code}";
        // //  loggy.warning('oghab @@@ params: ${params}');
        // print("oghab @@@ params: ${params}");
        print("oghab @@@ account_id: ${account_id}");

        final response = await client.post(
          // 'https://shop.hologate.pro/api/login' + params, formData);
            globals.global_url + '/api/accounts/get-devices',
            formData);
        print("oghab @@@ response" + response.toString());
        final jsonData = response.data!;
        isLoading.value = false;

        if (response.statusCode == 200) {
          if (jsonData['success'] == true) {
            // globals.globalCheckGetListServer = true;
            //
            globals.global_account_id = account_id;
            // var access_token = jsonData['access_token']?.toString() ?? "";
            // var token_type = jsonData['token_type']?.toString() ?? "";
            // var loginUrl = jsonData['login_url']?.toString() ?? "";
            //
            // // loggy.debug(
            // //   'oghab @@@: ${access_token}   ${token_type} ',
            // // );
            // final SharedPreferences prefs = await SharedPreferences.getInstance();
            // var token = token_type + " " + access_token;
            // globals.globalToken = token;
            // await prefs.setString('token', token);
            // await prefs.setString('url_login', loginUrl);
            // Navigator.of(context).pop();

            if ((jsonData['subscription'].toString()) != "null") {
              SetRequestServer_subScription(context);
              // final SharedPreferences prefs = await SharedPreferences.getInstance();
              // await prefs.setString(
              //     'subscription', jsonData['subscription'].toString());
              // // Navigator.of(context).pop();
              // //Navigator.of(context).popUntil((route) => route.isFirst);
              // Navigator.of(context)
              //   ..pop()
              //   ..pop();
            } else if ((jsonData['connections'].toString()) != "null") {
              const ConfigDeviceRoute2().push(context).then((data) {
                isLoading.value = false;
              });
            } else if ((jsonData['state'].toString()) != 'null') {
              if (jsonData['state'].toString() == "get-devices") {
                const ConfigDeviceRoute2().push(context).then((data) {
                  isLoading.value = false;
                });
              } else if ((jsonData['state'].toString()) == "get_mc_group") {
                globals.global_subscription_id =
                    jsonData['subscription_id'].toString();
                const ConfigLocationRoute().push(context).then((data) {
                  isLoading.value = false;
                });
              } else if ((jsonData['state'].toString()) == "get_subscription") {
                SetRequestServer_subScription(context);

                // Navigator.of(context).popUntil((route) => false);
                //  Navigator.of(context).pop();
              } else {
                CustomToast.error(jsonData['message']?.toString() ??
                    "سرور با خطا مواجه شد!!")
                    .show(context);
              }
            } else {
              //  Navigator.of(context).popUntil((route) => false);
              // Navigator.of(context).pop();
              // Navigator.of(context).popUntil((route) => route.isFirst);
              // Navigator.of(context)
              //   ..pop()
              //   ..pop();
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
            // Navigator.of(context).popUntil(ModalRoute.withName('/'));
            // final regionLocale =
            // _getRegionLocale(jsonData['country_code']?.toString() ?? "");
            //
            // loggy.debug(
            //   'Region: ${regionLocale.region} Locale: ${regionLocale.locale}',
            // );
          } else {
            // CustomToast.error(((jsonData['message']?.toString())!.length > 0)
            //         ? jsonData['message'].toString()
            //         : "سرور با خطا مواجه شد!!")
            //     .show(context);
            CustomToast.error(
                jsonData['message']?.toString() ?? "سرور با خطا مواجه شد!!")
                .show(context);
          }
        } else {
          CustomToast.error("سرور با خطا مواجه شد!!!").show(context);

          loggy.warning('Request failed with status: ${response.statusCode}');
        }
      } catch (e) {
        isLoading.value = false;

        CustomToast.error("سرور با خطا مواجه شد!!!").show(context);

        loggy.warning(
            'Could not get the local country code from ip 6666' + e.toString());
      }
    }


    GetRequestServer(context);

    // final isLoading.value = ref.watch(isLoadingProvider);
    // ref.listen(
    //   counterProvider,
    //       (previous, next) {
    //     print("The new value is $next");
    //     if (next == 5) {
    //       print("I just reached 5");
    //     }
    //   },
    // );
    // ref.read(counterProvider.state).state += 1;

    // final TextEditingController nameController = TextEditingController();
    // final TextEditingController passwordController = TextEditingController();
    useOnAppLifecycleStateChange((pref, state) {
      if (state == AppLifecycleState.resumed) {
        isLoading.value = false;
        //make a request
      }
    });
    return Scaffold(
        appBar: AppBar(title: const Text('')),

        body: Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: ListView(
            children: [
              Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                child: const Column(
                  children: <Widget>[
                    Text(
                      'شما اکانت فعال در هلوگیت دارید. کدام اشتراک را در پلاس استفاده می کنید ؟',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 20),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
              ListView.builder(
                itemCount: products.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Card(
                      child: ListTile(
                          //  tileColor: Colors.black12,
                          dense: true,
                          contentPadding:
                              EdgeInsets.only(left: 0.0, right: 0.0),
                          title: Text(
                            products[index]['username'].toString() +
                                " - " +
                                products[index]['name'].toString(),
                            style: const TextStyle(
                              // color: Colors.black,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          onTap: () {
                            setState(() {
                              account_id = products[index]['id'].toString();
                              print("oghab @@@ account_id  " + account_id);
                            });
                            SetRequestServer(context);
                          }
                          // title:  Text(products[index]['name']),
                          ),
                    ),
                  );
                },
              ),

              /*           if(products.isNotEmpty)  ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return const ListTile(

                 // title: Text(products[index]['name'].toString()),
                  title:  Text('Title', style: TextStyle(color: Colors.orange),),
                );
              },
            ),*/
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     const Text('Does not have account?'),
              //     TextButton(
              //       child: const Text(
              //         'send',
              //         style: TextStyle(fontSize: 20),
              //       ),
              //       onPressed: () async {
              //         await UriUtils.tryLaunch(
              //           Uri.parse("https://shop.hologate.pro/register?type=android"),
              //         );
              //       },
              //     )
              //   ],
              // ),
              /*      Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28.0, vertical: 6.0),
              child: FilledButton.icon(
                onPressed: () {
                  SetRequestServer(context);
                  //  const ConfigDeviceRoute2().push(context);
                  // setState(() {
                  //   // This call to setState tells the Flutter framework that something has
                  //   // changed in this State, which causes it to rerun the build method below
                  //   // so that the display can reflect the updated values. If we changed
                  //   // _counter without calling setState(), then the build method would not be
                  //   // called again, and so nothing would appear to happen.
                  //   _check=2;
                  // });
                },
                icon: const Icon(FluentIcons.send_16_filled),
                label: const Text(
                  "ارسال",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                // style: ButtonStyle( ),
              ),
            ),*/
            ],
          ),
        ),
        if (isLoading.value)
          Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              top: 0.0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.black.withOpacity(0.6),
                //  color: Colors.pink,
                padding: const EdgeInsets.all(10),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text('لطفا صبر نمایید ...')),
                    CircularProgressIndicator()
                  ],
                ),
              ))
      ],
    ));
  }
}
