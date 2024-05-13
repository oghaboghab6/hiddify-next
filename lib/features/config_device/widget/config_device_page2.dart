import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hiddify/core/http_client/dio_http_client.dart';
import 'package:hiddify/core/router/router.dart';
import 'package:hiddify/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hiddify/utils/globals.dart' as globals;
import 'package:hiddify/utils/link_parsers.dart';

final TextEditingController nameController = TextEditingController();

/*class MyHomePage extends StatefulWidget {
  @override
  ConfigDevicePage2 createState() => ConfigDevicePage2();
}
class ConfigDevicePage2 extends State<MyHomePage>  with PresLogger {
  // late final List<String,dynamic> products=[{"id":1,"name":""}];
  late final List<Map<String, dynamic>> products = [{"id":1,"name":"ahmad"}];
  // const ConfigDevicePage2({super.key});
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

class ConfigDevicePage2 extends StatefulHookConsumerWidget {
  //const ConfigDevicePage2(this.child, {super.key});
  const ConfigDevicePage2({super.key});

  //final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConnectionWrapperState();
}

class _ConnectionWrapperState extends ConsumerState<ConfigDevicePage2>
    with AppLogger {
  // late final List<Map<String, dynamic>> products = [
  //   // {"id": 1, "name": "hologate256997"},
  //   // {"id": 2, "name": "hologate005781"}
  // ];
  late List products2 = [
    // {"id": 1, "name": "hologate256997"},
    // {"id": 2, "name": "hologate005781"}
  ];

  // late final List<Map<String, dynamic>> products2 = [
  //   // {"id": 1, "name": "g1.hologate.pro", "type": "ssh"},
  //   // {"id": 2, "name": "g25.hologate.com", "type": "v2ray"}
  // ];
  int _check = 1;
  bool _checkFrom = false;
  String device_id = "0";
  // final isLoading.value = useState(false);
  bool isLoading = false;
  bool checkLoading = true;

  @override
  // Widget build(BuildContext context) {
  //   // ref.listen(connectionNotifierProvider, (_, __) {});
  //
  //   return widget.child;
  // }
  @override
  Widget build(BuildContext context) {
    final isLoading = useState(false);
    Future<void> GetRequestServer(BuildContext context) async {

      if(   checkLoading ==true) {
        checkLoading = false;
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
            'account_id': globals.global_account_id,
            'unique_id': deviceID,
            'is_plus_device': true,

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
            // 'https://shop.hologate.pro/api/accounts/get-devices' , formData);
              globals.global_url + '/api/accounts/get-devices',
              formData);
          isLoading.value = false;

          if (response.statusCode == 200) {
            final jsonData = response.data!;

            if (jsonData['success'] == true) {
              //  globals.globalCheckGetListServer = true;

              setState(() {
                products2 = jsonData['connections'] as List;
                // products=[
                //   {"id": 1, "name": "hologate256997"},
                //   {"id": 2, "name": "hologate005781"}
                // ];
              });
              //   Navigator.of(context).popUntil((route) => false);
              //    Navigator.of(context).pop();
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
            CustomToast.error("سرور با خطا مواجه شد!!").show(context);
            loggy.warning('Request failed with status: ${response.statusCode}');
          }
        } catch (e) {
          isLoading.value = false;

          CustomToast.error("سرور با خطا مواجه شد!!").show(context);
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
          'name': nameController.text,
          'subscription_id': device_id,
          'unique_id': deviceID,
          'is_plus_device': true,

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
        if (response.statusCode == 200) {
          final jsonData = response.data!;
          isLoading.value =false;

          if (jsonData['success'] == true) {
            if ((jsonData['subscription'].toString()) != 'null') {
              globals.globalCheckGetListServer = true;
              globals.globalWaitingGetListServer = true;
              final SharedPreferences prefs =
              await SharedPreferences.getInstance();
              globals.globalToken = globals.globalTokenTemporary;
              await prefs.setString('token', globals.globalTokenTemporary);
              print(
                  "oghab @@@ subscriptionrrrrr: ${jsonData['subscription'].toString()}");
              await prefs.setString(
                  'subscription', jsonData['subscription'].toString());
              // Navigator.of(context).pop();
              //  Navigator.of(context).popUntil((route) => route.isFirst);
              // if(_checkFrom==true)
              // Navigator.of(context)..pop()..pop();
              // else
              // Navigator.of(context)..pop()..pop()..pop();
              Navigator.of(context).popUntil((route) => route.isFirst);
            } else
              CustomToast.error(
                  jsonData['message']?.toString() ?? "سروری موجود نیست مجداد تلاش نمایید ")
                  .show(context);
            //   Navigator.of(context).popUntil((route) => false);
            // Navigator.of(context).pop();
            //   Navigator.of(context).popUntil((route) => route.isFirst);
            // Navigator.of(context)..pop()..pop()..pop();
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
          CustomToast.error("سرور با خطا مواجه شد!!").show(context);
          loggy.warning('Request failed with status: ${response.statusCode}');
        }
      } catch (e) {
        isLoading.value =false;

        CustomToast.error("سرور با خطا مواجه شد!!").show(context);
        loggy.warning('Could not get the local country code from ip');
      }
    }

    Future<void> SetRequestServer(BuildContext context) async {
      isLoading.value = true;
      // return;
      try {
        var deviceID = await get_unique_identifier();
        print("oghab @@@ globalToken " +
            globals.globalToken +
            "  -   " +
            device_id);
        final DioHttpClient client = DioHttpClient(
            timeout: const Duration(seconds: 10),
            userAgent:
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:123.0) Gecko/20100101 Firefox/123.0",
            debug: true,
            Authorization: globals.globalTokenTemporary);
        // final response =
        // await client.get<Map<String, dynamic>>('https://shop.hologate.pro/api/login');
        var formData = FormData.fromMap({
          'name': nameController.text,
          'subscription_id': device_id,
          'unique_id': deviceID,
          'is_plus_device': true,

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
        print("oghab @@@ account_id: ${device_id}");

        final response = await client.post(
          // 'https://shop.hologate.pro/api/login' + params, formData);
            globals.global_url + '/api/accounts/get-mc-group',
            formData);
        print("oghab @@@ response" + response.toString());
        final jsonData = response.data!;
        isLoading.value =false;

        if (response.statusCode == 200) {
          if (jsonData['success'] == true) {
            // globals.globalCheckGetListServer = true;
            //
            globals.global_account_id = device_id;
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
              if ((jsonData['state'].toString()) == "get_mc_group") {
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
              Navigator.of(context).popUntil((route) => route.isFirst);
              // Navigator.of(context)
              //   ..pop()
              //   ..pop();
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
        isLoading.value =false;

        CustomToast.error("سرور با خطا مواجه شد!").show(context);

        loggy.warning(
            'Could not get the local country code from ip 6666' + e.toString());
      }
    }

    print("@@@@@"+isLoading.toString());
    // final TextEditingController nameController = TextEditingController();
    // final TextEditingController passwordController = TextEditingController();
/*    useOnAppLifecycleStateChange((pref, state) {
      print("@@@@@ state" +state.toString());
      if (state == AppLifecycleState.resumed) {
        isLoading.value =false;
        //make a request
      }

    });*/
    GetRequestServer(context);

    return Scaffold(
        body: Stack(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                child: (device_id != "0")
                    ? Text(
                        'لطفا نام این دستگاه را اصلاح فرمایید:',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      )
                    : Text(
                        'این اشتراک شما چند اتصال همزمان دارد کدام اتصال را قطع و در پلاس استفاده می نمایید؟',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
              ),
              if (device_id == "0")
                ListView.builder(
                  itemCount: products2.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 4),
                      child: Card(
                        child: ListTile(
                            //tileColor: Colors.black12,
                            dense: true,
                            contentPadding:
                                EdgeInsets.only(left: 0.0, right: 0.0),
                            title: Text(
                              // products2[index]['name']!.toString() +" "+
                                  products2[index]['server']!.toString(),
                              style: const TextStyle(
                                // color: Colors.black,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            onTap: () async {
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setString('device_id',
                                  products2[index]['id'].toString());
                              setState(() {
                                device_id = products2[index]['id'].toString();
                              });
                              nameController.text =
                                  products2[index]['name'].toString();
                              //SetRequestServer(context);
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
              if (device_id != "0")
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'نام دستگاه',
                    ),
                  ),
                ),
              if (device_id != "0")
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28.0, vertical: 6.0),
                  child: FilledButton(
                    onPressed: () {
                      SetRequestServer(context);
                    },
                    child: const Text(
                      "تایید",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor:
                          Color(0xffea5555), // This is what you need!
                    ),
                    // style: ButtonStyle( ),
                  ),
                  // child: FilledButton.icon(
                  //   onPressed: () {
                  //     SetRequestServer(context);
                  //   },
                  //   icon: const Icon(FluentIcons.send_16_filled),
                  //   label: const Text(
                  //     "تایید",
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   style: FilledButton.styleFrom(
                  //     backgroundColor:   Color(0xffea5555), // This is what you need!
                  //   ),
                  //   // style: ButtonStyle( ),
                  // ),
                ),
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

  @override
  void initState() {
    super.initState();
    _checkFrom = globals.globalCheckDevice;
    globals.globalCheckDevice = false;
    //  RequestServer(context);
  }


}
