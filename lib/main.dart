import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:utility/services.dart';
import 'package:web3dart/web3dart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UTILITY',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final nftNumber = TextEditingController();

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(blockchainUrl, httpClient);
    super.initState();
  }

  Future<List<dynamic>> callFunction(String name,
      {int nftNumber = 9806}) async {
    final contract = await getContract();
    final function = contract.function(name);
    final result = await ethClient.call(
        contract: contract,
        function: function,
        params: [BigInt.from(nftNumber)]);
    return result;
  }

  Future<String> fetchll(String url) async {
    final response = await httpClient
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return response.body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future<void> getURIll(int nftNumber) async {
    print('get the URI');
    List<dynamic> tokenURI =
        await callFunction("tokenURI", nftNumber: nftNumber);
    String tokenstr = tokenURI[0];
    String lazylion = await fetchll(tokenstr);
    //print(lazylion);
    Map<String, dynamic> lljson = jsonDecode(lazylion);
    setState(() {
      currentJson = lljson;
    });
  }

  Future<DeployedContract> getContract() async {
    //obtain our smart contract using rootbundle to access our json file
    //String abiFile = await rootBundle.loadString("abis/chain_runners.json");
    String abiFilell = await rootBundle.loadString("abis/lazy_lions.json");
    //String contractAddress_cr = "0x97597002980134beA46250Aa0510C9B90d87A587";
    String contractAddress_ll = "0x8943C7bAC1914C9A7ABa750Bf2B6B09Fd21037E0";
    /*final contract = DeployedContract(ContractAbi.fromJson(abiFile, "ChainRunners"),
        EthereumAddress.fromHex(contractAddress));*/
    final contract = DeployedContract(
        ContractAbi.fromJson(abiFilell, "LazyLions"),
        EthereumAddress.fromHex(contractAddress_ll));
    return contract;
  }

  late Client httpClient;
  late Web3Client ethClient;
  final String blockchainUrl = "https://cloudflare-eth.com";
  int selectedAttr = 99;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic> currentJson = {};

  final List<String> elements = [
    //"Loot",
    "Bored Ape Yacht Club",
    "Lazy Lions",
    //"Chain Runners"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Survive. Utility. Score.'), actions: [
        IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: 'Restart',
            onPressed: () {}),
        IconButton(
            icon: const Icon(Icons.description),
            tooltip: 'White Paper',
            onPressed: () {}),
/*
        PopupMenuButton<int>(
          onSelected: (int result) {
            print('result: $result');
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
            PopupMenuItem(
              value: 0,
              child: Text('Name'),
            ),
            PopupMenuItem(
              value: 1,
              child: Text('Size'),
            ),
            // PopupMenuItem(
            //   value: 2,
            //   child: Text('Image'),
            // ),
            PopupMenuItem(
              value: 3,
              child: Text('Delete'),
            ),
          ],
        ),
*/
      ]),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Card(
                elevation: 3,
                //borderOnForeground: true,
                margin: EdgeInsets.all(10),
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Reality has been fractured. Tribes must compete to earn \$utility for their survival. What tribe do you champion?',
                    ))),
            SizedBox(
                //height: 300,
                //fit: FlexFit.tight,
/*
              child: GridView.extent(
                  maxCrossAxisExtent: 130.0,
                  crossAxisSpacing: 20.0,
                  mainAxisSpacing: 20.0,
                  children: elements
                      .map((el) => Card(
                          color: Colors.blue,
                          child: InkWell(
                            onTap: () {},
                            child: Center(
                                child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(el))),
                          )))
                      .toList()),
*/
                ),
            //Text("The NFT's description"),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: <
                Widget>[
              Image(
                  height: 100,
                  width: 100,
                  image: NetworkImage('https://www.loot.exchange/lootbag.png')),
              SizedBox(
                width: 200,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          textInputAction: TextInputAction.go,
                          decoration: const InputDecoration(
                            hintText: 'Input An Address / TokenID',
                          ),
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          controller: nftNumber,
                          keyboardType: TextInputType.number,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              print('testing');
                              print(nftNumber.text);
                              int a;
                              if (nftNumber.text != '') {
                                a = int.parse(nftNumber.text);
                              } else {
                                a = 9806;
                              }
                              //print(int.parse(nftNumber.text));
                              getURIll(a);

                              //testProvider();
                              //testInterface();
                              setState(() {
                                selectedAttr = 99;
                              });
                            },
                            child: const Text('Feeling lucky?')),
                      ],
                    ),
                  ),
                ),
              )
            ]),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: true,
                  child: (currentJson['image'] == null)
                      ? SizedBox()
                      :
                      // Image(
                      //         width: 150,
                      //         //height: 50,
                      //         image: NetworkImage(currentJson['image']))
                      Expanded(child: battleCard()),
                ),
                (currentJson['attributes'] == null)
                    ? SizedBox()
                    : Expanded(child: attributesList()),
                SizedBox(
                  width: 20,
                )
              ],
            ),
            SizedBox(height: 20),
            Card(child: Text('Select a starting attribute.')),
            ElevatedButton(
                onPressed: () {
                  print('battle now with selectedAttr: ' +
                      selectedAttr.toString());
                  print(currentJson['attributes'].length);
                  if (selectedAttr > currentJson['attributes'].length) {
                    print('select an attribute');
                  } else {
                    print('go for launch');
                  }
                  setState(() {});
                },
                child: const Text('Begin Battle!')),
          ],
        ),
      ),
    );
  }

  Widget attributesList() {
    return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (int i = 0; i < currentJson['attributes'].length; i++)
            InkWell(
                onTap: () {
                  selectedAttr = i;
                  setState(() {});
                },
                child: Card(
                    color: (i == selectedAttr) ? Colors.blue : Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        '${currentJson['attributes'][i]['trait_type']}: ${currentJson['attributes'][i]['value']}',
                        style: TextStyle(
                          fontSize: 12,
                            fontWeight: (i == selectedAttr)
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    )))
        ]);
  }

  Widget battleCard() {
    print('battleCard called');
    if (currentJson['image'] != null) {
      return Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image(
                width: 150,
                //height: 50,
                image: NetworkImage(currentJson['image'])),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Text('10', style: TextStyle(fontWeight: FontWeight.bold)),
                  Image.asset('assets/images/plus.png', width: 20),
                  SizedBox(width: 10),
                  Text('10', style: TextStyle(fontWeight: FontWeight.bold)),
                  Image.asset('assets/images/shield.png', width: 20),
                  SizedBox(width: 10),
                  Text('10', style: TextStyle(fontWeight: FontWeight.bold)),
                  Image.asset('assets/images/magic.png', width: 20),
                  // Positioned(
                  // bottom: 0, left: 0, width: 20, child: Image.asset('assets/images/plus.png')),
                  // Positioned(
                  // bottom: 0, left: 50, width: 20, child: Image.asset('assets/images/shield.png')),
                  // Positioned(
                  // bottom: 0, left: 100, width: 20, child: Image.asset('assets/images/magic.png')),
                ])
            // Positioned(
            //     top: 0, left: 100, width: 20, child: Image.asset('assets/images/plus.png')),
          ]);
    } else {
      return SizedBox();
    }
  }
}
