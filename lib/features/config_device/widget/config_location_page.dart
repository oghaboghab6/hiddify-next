import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hiddify/core/http_client/dio_http_client.dart';
import 'package:hiddify/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hiddify/utils/globals.dart' as globals;
import 'package:hiddify/utils/link_parsers.dart';

/*class MyHomePage extends StatefulWidget {
  @override
  ConfigLocationPage createState() => ConfigLocationPage();
}
class ConfigLocationPage extends State<MyHomePage>  with PresLogger {
  // late final List<String,dynamic> products=[{"id":1,"name":""}];
  late final List<Map<String, dynamic>> products = [{"id":1,"name":"ahmad"}];
  // const ConfigLocationPage({super.key});
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
          timeout: const Duration(seconds: 30),
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

class ConfigLocationPage extends StatefulHookConsumerWidget {
  //const ConfigLocationPage(this.child, {super.key});
  const ConfigLocationPage({super.key});

  //final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConnectionWrapperState();
}

class _ConnectionWrapperState extends ConsumerState<ConfigLocationPage>
    with PresLogger {
  late UniqueKey keyTile;
  bool isExpanded = false;

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
  String mc_group_id = "0";

  //final isLoading = useState(false);
  bool isLoading = false;

  @override
  // Widget build(BuildContext context) {
  //   // ref.listen(connectionNotifierProvider, (_, __) {});
  //
  //   return widget.child;
  // }
  void expandTile() {
    setState(() {
      isExpanded = true;
      keyTile = UniqueKey();
    });
  }

  void shrinkTile() {
    setState(() {
      isExpanded = false;
      keyTile = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    keyTile = UniqueKey();
    // final TextEditingController nameController = TextEditingController();
    // final TextEditingController passwordController = TextEditingController();
    useOnAppLifecycleStateChange((pref, state) {
      if (state == AppLifecycleState.resumed) {
        isLoading = false;
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
                    padding: const EdgeInsets.symmetric(
                        vertical: 40, horizontal: 16),
                    child: const Column(
                      children: <Widget>[
                        Text(
                          'لوکیشن مورد نظر خود را انتخاب نمایید',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  /*           ListView.builder(
                itemCount: products2.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        side: BorderSide(
                          color:  Color(0xffea5555),
                          width: 1.0,
                        ),
                      ),
                      child: ListTile(
                          //tileColor: Colors.black12,
                          dense: true,
                          contentPadding:
                              EdgeInsets.only(left: 0.0, right: 0.0),
                          title: Text(
                            products2[index]['name']!.toString(),
                            style: const TextStyle(
                              // color: Colors.black,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          onTap: () async {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setString('location_id',
                                products2[index]['id'].toString());
                            setState(() {
                              mc_group_id = products2[index]['id'].toString();
                            });
                            SetRequestServer(context);
                          }
                          // title:  Text(products[index]['name']),
                          ),
                    ),
                  );
                },
              ),*/
                  ListView.builder(
                    itemCount: products2.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 4),
                        child: Card(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            side: BorderSide(
                              color: Color(0xffea5555),
                              width: 1.0,
                            ),
                          ),
                          child: ExpansionTile(
                            key: keyTile,
                            initiallyExpanded: false,
                            childrenPadding:
                                EdgeInsets.all(16).copyWith(top: 0),
                            title: Text(
                              products2[index]['name']!.toString(),
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w500),
                            ),
                            children: [
                                for (var item in products2[index]['servers'] as List)
                                  ListTile(
                                    //tileColor: Colors.black12,
                                      dense: true,
                                      contentPadding:
                                      EdgeInsets.only(left: 0.0, right: 0.0),
                                      title: Text(
                                        item['name']!.toString(),
                                        style: const TextStyle(
                                          // color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      //  textAlign: TextAlign.center,
                                      ),
                                      onTap: () async {
                                        final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                        await prefs.setString('location_id',
                                            item['id'].toString());
                                        setState(() {
                                          mc_group_id = item['id'].toString();
                                        });
                                        SetRequestServer(context);
                                      }
                                    // title:  Text(products[index]['name']),
                                  ),

                            ],
                            onExpansionChanged: (isExpanded) =>
                                print(isExpanded),
                          ),
                       /*   child: ExpansionTile(
                            key: keyTile,
                            initiallyExpanded: true,
                            childrenPadding:
                                EdgeInsets.all(16).copyWith(top: 0),
                            title: Text(
                              '👩 Sarah Pepperstone',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w500),
                            ),
                            children: [
                              Text(
                                'My name is Sarah and I am a New York City based Flutter developer. I help entrepreneurs & businesses figure out how to build scalable applications.\n\nWith over 7 years experience spanning across many industries from B2B to B2C, I live and breath Flutter.',
                                style: TextStyle(fontSize: 18, height: 1.4),
                              ),
                            ],
                            onExpansionChanged: (isExpanded) =>
                                print(isExpanded),
                          ),*/
                        ),
                      );
                    },
                  ),
                  /*   ExpansionTile(
                key: keyTile,
                initiallyExpanded: true,
                childrenPadding: EdgeInsets.all(16).copyWith(top: 0),
                title: Text(
                  '👩 Sarah Pepperstone',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
                children: [
                  Text(
                    'My name is Sarah and I am a New York City based Flutter developer. I help entrepreneurs & businesses figure out how to build scalable applications.\n\nWith over 7 years experience spanning across many industries from B2B to B2C, I live and breath Flutter.',
                    style: TextStyle(fontSize: 18, height: 1.4),
                  ),
                ],
                onExpansionChanged: (isExpanded) => print(isExpanded),
              ),*/

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
                  /*     Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28.0, vertical: 6.0),
              child: FilledButton.icon(
                onPressed: () {
                  SetRequestServer(context);
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
            if (isLoading)
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
    GetRequestServer(context);
    //  RequestServer(context);
  }

  Future<void> GetRequestServer(BuildContext context) async {
    isLoading = true;
    print("oghab @@@@@@2 global_account_id  " + globals.global_account_id);
    print("oghab @@@@@@2  global_account_name  " +
        globals.global_account_name +
        "  ");
    print("oghab @@@@@@2 global_subscription_id  " +
        globals.global_subscription_id);
    print("oghab @@@@@@2 token  " +
        (globals.globalTokenTemporary == ''
            ? globals.globalToken
            : globals.globalTokenTemporary));
    try {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      final String version = packageInfo.version;
      final String code = packageInfo.buildNumber;
      var deviceID = await get_unique_identifier();

      final DioHttpClient client = DioHttpClient(
          timeout: const Duration(seconds: 60),

          userAgent:
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:123.0) Gecko/20100101 Firefox/123.0",
          debug: true,
          Authorization: globals.globalTokenTemporary == ''
              ? globals.globalToken
              : globals.globalTokenTemporary);
      print("oghab @@@@@@2 version???  " + version+"    "+ code);

      // final response =
      // await client.get<Map<String, dynamic>>('https://shop.hologate.pro/api/login');
      var formData = FormData.fromMap({
        'name': globals.global_account_name,
        'account_id': globals.global_account_id,
        'subscription_id': globals.global_subscription_id,
        'unique_id': deviceID,
        'is_plus_device': true,
        'is_change_mc': globals.globalCheckMcGroup,
        'platform': Platform.operatingSystem,
        'version': version,
        'code': code,
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

      final response = await client.post(
          // 'https://shop.hologate.pro/api/accounts/get-devices' , formData);
          globals.global_url + '/api/accounts/get-mc-group',
          formData);
      print("oghab @@@ params: ${response}");
      isLoading = false;

      if (response.statusCode == 200) {
        final jsonData = response.data!;

        if (jsonData['success'] == true) {
          // globals.globalCheckGetListServer = true;

          setState(() {
            products2 = jsonData['mc-group'] as List;
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
      isLoading = false;

      CustomToast.error("سرور با خطا مواجه شد!!").show(context);
      loggy.warning('Could not get the local country code from ip'+e.toString());
    }
  }

  Future<void> SetRequestServer(BuildContext context) async {
    isLoading = true;

    try {
      var deviceID = await get_unique_identifier();

      final DioHttpClient client = DioHttpClient(
          timeout: const Duration(seconds: 30),
          userAgent:
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:123.0) Gecko/20100101 Firefox/123.0",
          debug: true,
          Authorization: globals.globalTokenTemporary == ''
              ? globals.globalToken
              : globals.globalTokenTemporary);
      // final response =
      // await client.get<Map<String, dynamic>>('https://shop.hologate.pro/api/login');
      var formData = FormData.fromMap({
      //  'mc_group_id': mc_group_id,
        'server_id': mc_group_id,
        'subscription_id': globals.global_subscription_id,
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
      print("oghab @@@ params: ${formData}");

      final response = await client.post(
          globals.global_url + '/api/accounts/get-subscription', formData);
      if (response.statusCode == 200) {
        final jsonData = response.data!;
        isLoading = false;

        if (jsonData['success'] == true) {
          if ((jsonData['subscription'].toString()) != 'null') {
            // globals.globalCheckMcGroup=true;
            // SetRequestServer_subScription(context);
            print(
                "oghab @@@ subscriptionrrrrr: ${jsonData['subscription'].toString()}");
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            await prefs.setString(
                'subscription', jsonData['subscription'].toString());

            globals.globalCheckGetListServer = true;
            globals.globalWaitingGetListServer = true;
            if (globals.globalCheckMcGroup == false) {
              globals.globalToken = globals.globalTokenTemporary;
              await prefs.setString('token', globals.globalTokenTemporary);
            }

            // Navigator.of(context).pop();
            //  Navigator.of(context).popUntil((route) => route.isFirst);
            // if(_checkFrom==true)
            // Navigator.of(context)..pop()..pop();
            // else
            // Navigator.of(context)..pop()..pop()..pop();
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else
            CustomToast.error(jsonData['message']?.toString() ??
                    "سروری موجود نیست مجداد تلاش نمایید ")
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
        isLoading = false;

        CustomToast.error("سرور با خطا مواجه شد!!").show(context);
        loggy.warning('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      isLoading = false;

      CustomToast.error("سرور با خطا مواجه شد!!").show(context);
      loggy.warning('Could not get the local country code from ip');
    }
  }
}
