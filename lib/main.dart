import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:reef_chain_flutter/js_api_service.dart';
import 'package:reef_chain_flutter/network/network.dart';
import 'package:reef_chain_flutter/reef_api.dart';
import 'package:reef_chain_flutter/reef_state/account/account.dart';

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


    // logs currencies from stealthex
    widget.reefChain.reefState.stealthexApi.listCurrencies().then((val) {
      debugPrint("listCurrencies===$val");
    });

    // logs pool reserves
    widget.reefChain.reefState.swapApi
        .getPoolReserves("0x70A82e21ec223c8691a0e44BEDC4790976Ea530c",
            "0x0000000000000000000000000000000001000000")
        .then((val) {
      debugPrint("getPoolReserves===$val");
    });

    // generateAccount
    widget.reefChain.reefState.accountApi.generateAccount().then((val) {
      debugPrint("generateAccount===$val");
    });

    setState(() {
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
            if(jsResult.length>0)Text("${jsResult.toString()}"),
            ElevatedButton(onPressed: _initReef, child: Text("init Reef")),
            ElevatedButton(
                onPressed: () {
                  widget.reefJsApiService
                      .jsCall("window.getReefJsVer()")
                      .then((v) {
                        setState(() {
                          jsResult=v.toString();
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
                      jsResult=v.data.toString();
                    });
                    debugPrint("tokens len=${v.data}");
                  });
                },
                child: Text("Get Tokens")),
            ElevatedButton(
                onPressed: () {
                     // logs pools
                    widget.reefChain.reefState.poolsApi.fetchPools().then((val) {
                      setState(() {
                        jsResult=val.toString();
                      });
                      debugPrint("pools===$val");
                    });
                },
                child: Text("Get Pools")),
            ElevatedButton(
                onPressed: () {
                  // logs network
                  widget.reefChain.reefState.networkApi.selectedNetwork().listen((val) {
                    setState(() {
                      jsResult=val.toString();
                    });
                    debugPrint("selectedNetwork===$val");
                  });
                },
                child: Text("Get Selected Network")),
            
            // widget.reefJsApiService.widget,
            // const Text(
            //   'test js integration',
            // ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
