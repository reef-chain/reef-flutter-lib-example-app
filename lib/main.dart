import 'dart:convert';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reef Flutter Lib Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'Reef Flutter Lib Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /*final JsApiService reefJsApiService = JsApiService.reefAppJsApi(onErrorCb: () {
    debugPrint('JS CONNECTION ERROR - RESET');
  });*/
  final ReefChainApi reefChain = ReefChainApi();

  bool isInitialized = false;
  List<ReefAccount> accounts = [
    ReefAccount('Account 1', '5EnY9eFwEDcEJ62dJWrTXhTucJ4pzGym4WZ2xcDKiT3eJecP', true)
  ];
  String? selectedAccount;

  void _initReef() async {
   /* try {
      // await reefJsApiService.jsCall("window.isJsConn()");
      await reefChain.reefState.metadataApi.isJsConn();
    } catch (e) {
      debugPrint("isJsConn error: $e");
    }*/

    reefChain.reefState.accountApi.accountsStatus$.listen((val) {
      setState(() {
        accounts = (val['data'] as List).map((acc) =>
            ReefAccount(acc['data']['name'], acc['data']['address'], acc['data']['isEvmClaimed'])).toList();
      });
    });

    reefChain.reefState.accountApi.selectedAddressStream.listen((selected) {
      setState(() {
        selectedAccount = selected;
      });
    });

    try {
      await reefChain.reefState.init(ReefNetowrk.mainnet, accounts);
    } catch (e) {
      debugPrint("init error: $e");
    }


    setState(() {
      isInitialized = true;
    });
  }

  @override
  void initState() {
    super.initState();
    // Future.delayed(const Duration(seconds: 4), _initReef);
    _initReef();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("Accounts"),
                SizedBox(width: 4,),
                Container(
                  decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(accounts.length.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12,color: Colors.black),),
                  ),
                )
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                var generatedAccount = await reefChain.reefState.accountApi.generateAccount();
                var newAccount = ReefAccount(
                  "Account-${accounts.length + 1}",
                  jsonDecode(generatedAccount)["address"],
                  false);
                setState(() => accounts.add(newAccount));
              },
              child: const Text("+ Account"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                textStyle: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.purple,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: 
          // isInitialized
          //     ? 
              ListView.builder(
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    final account = accounts[index];
                    bool isSelected = account.address == selectedAccount;
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: isSelected
                          ? RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.purpleAccent, width: 2.0),
                            )
                          : null,
                      child: ListTile(
                        title: Text(account.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(account.address, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        trailing: isSelected
                            ? null
                            : ElevatedButton(
                                onPressed: () {
                                  reefChain.reefState.accountApi.setSelectedAddress(account.address);
                                },
                                child: const Text("Select"),
                              ),
                      ),
                    );
                  },
                )
              // : const CircularProgressIndicator(color: Colors.purple),
        ),
      ),
    );
  }
}