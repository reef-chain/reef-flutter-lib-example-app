import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:reef_chain_flutter/js_api_service.dart';
import 'package:reef_chain_flutter/network/network.dart';
import 'package:reef_chain_flutter/reef_api.dart';
import 'package:reef_chain_flutter/reef_state/account/account.dart';
import 'package:reef_chain_flutter/reef_state/network/network.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final JsApiService reefJsApiService =
      JsApiService.reefAppJsApi(onErrorCb: () {
    debugPrint('JS CONNECTION ERRORORRRRR - RESET');
  });

  final ReefChainApi reefChain = ReefChainApi();

  MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String jsResult = "";
  bool isInitialized = false;

  void _initReef() async {
    widget.reefJsApiService
        .jsCall("window.isJsConn()")
        .then((v) => debugPrint(v.toString()));
    // widget.reefJsApiService.jsCall("window.test()").then((v)=>debugPrint(v.toString()));
    widget.reefJsApiService
        .jsPromise("window.futureFn(\"fltrrr\")")
        .then((v) => debugPrint(v.toString()));
    // widget.reefJsApiService.jsObservable("window.testObs()").listen((v)=>debugPrint(v.toString()));

    await widget.reefChain.reefState.init(ReefNetowrk.testnet, [
      ReefAccount(
          'name_acc1', '5EnY9eFwEDcEJ62dJWrTXhTucJ4pzGym4WZ2xcDKiT3eJecP', true)
    ]);

    setState(() {
      jsResult = "Initialized Reef App";
      isInitialized = true;
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 8.0,
            ),
            if (jsResult.isNotEmpty)
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      jsResult.toString(),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              ),
            SizedBox(
              height: 8.0,
            ),
              ElevatedButton(onPressed: _initReef, child: Text("init Reef")),
            if (isInitialized)
              Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        widget.reefJsApiService
                            .jsCall("window.getReefJsVer()")
                            .then((v) {
                          setState(() {
                            jsResult = v.toString();
                          });
                        });
                      },
                      child: Text("get reef.js version")),

                  ElevatedButton(
                      onPressed: () {
                        // logs tokens
                        widget.reefChain.reefState.tokenApi.tokens.listen((v) {
                          var len = v.data.length.toString();
                          setState(() {
                            jsResult = v.data.toString();
                          });
                          debugPrint("tokens len=${v.data}");
                        });
                      },
                      child: Text("Get Tokens")),
                  ElevatedButton(
                      onPressed: () {
                        // logs pools
                        widget.reefChain.reefState.poolsApi
                            .fetchPools()
                            .then((val) {
                          setState(() {
                            jsResult = val.toString();
                          });
                          debugPrint("pools===$val");
                        });
                      },
                      child: Text("Get Pools")),
                  ElevatedButton(
                      onPressed: () {
                        // logs network
                        widget.reefChain.reefState.networkApi
                            .selectedNetwork()
                            .listen((val) {
                          setState(() {
                            jsResult = val.toString();
                          });
                          debugPrint("selectedNetwork===$val");
                        });
                      },
                      child: Text("Get Selected Network")),
                  ElevatedButton(
                      onPressed: () {
                        // logs pool reserves
                        widget.reefChain.reefState.swapApi
                            .getPoolReserves(
                                "0x70A82e21ec223c8691a0e44BEDC4790976Ea530c",
                                "0x0000000000000000000000000000000001000000")
                            .then((val) {
                          setState(() {
                            jsResult = val.toString();
                          });
                          debugPrint("getPoolReserves===$val");
                        });
                      },
                      child: Text("Get Pool Reserves")),
                  ElevatedButton(
                      onPressed: () {
                        // generateAccount
                        widget.reefChain.reefState.accountApi
                            .generateAccount()
                            .then((val) {
                          setState(() {
                            jsResult = val.toString();
                          });
                          debugPrint("generateAccount===$val");
                        });
                      },
                      child: Text("Generate Account")),
                  ElevatedButton(
                      onPressed: () {
                        // generateAccount
                        widget.reefChain.reefState.accountApi
                            .resolveEvmAddress("5EnY9eFwEDcEJ62dJWrTXhTucJ4pzGym4WZ2xcDKiT3eJecP")
                            .then((val) {
                          setState(() {
                            jsResult = val.toString();
                          });
                          debugPrint("resolve evm address===$val");
                        });
                      },
                      child: Text("Resolve Evm address")),
                  ElevatedButton(
                      onPressed: () {
                        // generateAccount
                        widget.reefChain.reefState.accountApi
                            .accountFromMnemonic("insect tired exit please budget pole eyebrow estate six arrow legal album")
                            .then((val) {
                          setState(() {
                            jsResult = val.toString();
                          });
                          debugPrint("accountFromMnemonic===$val");
                        });
                      },
                      child: Text("Account from Mnemonic")),
                  ElevatedButton(
                      onPressed: () {
                        // bindEvmAccount
                        widget.reefChain.reefState.accountApi
                            .bindEvmAccount("0x7Ca7886e0b851e6458770BC1d85Feb6A5307b9a2")
                            .then((val) {
                          setState(() {
                            jsResult = "BIND EVM:"+ val.toString();
                          });
                          debugPrint("bindEvmAccount===$val");
                        });
                      },
                      child: Text("Bind EVM Address")),
                  ElevatedButton(
                      onPressed: () {
                        // isValidEvmAddress
                        widget.reefChain.reefState.accountApi
                            .isValidEvmAddress("0x7Ca7886e0b851e6458770BC1d85Feb6A5307b9a2")
                            .then((val) {
                          setState(() {
                            jsResult = "0x7Ca7886....A5307b9a2 IS VALID EVM ADDRESS:"+ val.toString();
                          });
                          debugPrint("isValidEvmAddress===$val");
                        });
                      },
                      child: Text("Is valid EVM Address")),
                  ElevatedButton(
                      onPressed: () {
                        // isValidEvmAddress
                        widget.reefChain.reefState.accountApi
                            .resolveToNativeAddress("0x7Ca7886e0b851e6458770BC1d85Feb6A5307b9a2")
                            .then((val) {
                          setState(() {
                            jsResult = val.toString();
                          });
                          debugPrint("resolveToNativeAddress===$val");
                        });
                      },
                      child: Text("Resolve Native address")),
                  ElevatedButton(
                      onPressed: () {
                        // toReefEVMAddressWithNotificationString
                        widget.reefChain.reefState.accountApi
                            .toReefEVMAddressWithNotificationString("0x7Ca7886e0b851e6458770BC1d85Feb6A5307b9a2")
                            .then((val) {
                          setState(() {
                            jsResult = val.toString();
                          });
                          debugPrint("toReefEVMAddressWithNotificationString===$val");
                        });
                      },
                      child: Text("Notification String")),
                  ElevatedButton(
                      onPressed: () {
                        // isValidEvmAddress
                        widget.reefChain.reefState.accountApi
                            .isValidSubstrateAddress("0x7Ca7886e0b851e6458770BC1d85Feb6A5307b9a2")
                            .then((val) {
                          setState(() {
                            jsResult = "0x7Ca7....7b9a2 IS VALID EVM ADDRESS:"+ val.toString();
                          });
                          debugPrint("isValidSubstrateAddress===$val");
                        });
                      },
                      child: Text("Is valid Substrate Address")),
                  ElevatedButton(
                      onPressed: () {
                        // isValidEvmAddress
                        widget.reefChain.reefState.networkApi
                            .setNetwork(Network.testnet)
                            .then((val) {
                          setState(() {
                            jsResult = "switched network to testnet";
                          });
                        });
                      },
                      child: Text("Switch to testnet")),
                  ElevatedButton(
                      onPressed: () {
                        // signRaw
                        widget.reefChain.reefState.signingApi
                            .signRaw("5EnY9eFwEDcEJ62dJWrTXhTucJ4pzGym4WZ2xcDKiT3eJecP","this is test")
                            .then((val) {
                          setState(() {
                            jsResult = "signed raw"+val.toString();
                          });
                        });
                      },
                      child: Text("Sign Raw")),
                  ElevatedButton(
                      onPressed: () {
                            // logs currencies from stealthex
                    widget.reefChain.reefState.stealthexApi.listCurrencies().then((val) {
                      setState(() {
                        jsResult=val.toString();
                      });
                      debugPrint("listCurrencies===$val");
                    });

                      },
                      child: Text("List Currencies")),
                  ElevatedButton(
                      onPressed: () {
                            // logs currencies from stealthex
                    widget.reefChain.reefState.accountApi.formatBalance("121121121121121121121",3).then((val) {
                      setState(() {
                        jsResult=val.toString();
                      });
                      debugPrint("formatBalance===$val");
                    });

                      },
                      child: Text("Format Balance")),

                  // widget.reefJsApiService.widget,
                  // const Text(
                  //   'test js integration',
                  // ),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
