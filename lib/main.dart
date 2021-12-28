import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      title: 'Flutter Demo',
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
    //getTotalVotes();
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

  Future<void> getURIcr() async {
    print('get the URI');
    List<dynamic> tokenURI = await callFunction("tokenURI");
    String tokenstr = tokenURI[0];
    tokenstr = tokenstr.substring(29);
    print('substring has a length of ' + tokenstr.length.toString());
    String decoded = utf8.decode(base64.decode(tokenstr));
    Map<String, dynamic> cr_json = jsonDecode(decoded);
    print(cr_json.length);
    var cr_attr = cr_json['attributes'];
    print(cr_json['attributes']);
    print(cr_json['attributes'][5]);
    print(cr_json['attributes'][5]['value']);
    print('--------------');
    print('length of attributes: ' + cr_attr.length.toString());
    print(cr_attr);
    print(cr_attr[5]);
    print(cr_attr[5]['value']);
  }

  Future<String> fetchll(String url) async {
    final response = await httpClient.get(Uri.parse(url),
    //headers: {'Access-Control-Allow-Origin': '*', 'method': 'GET', "origin": 'http://localhost:49824/'}
    headers: {'Content-Type': 'application/json'}
    );

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
    //print("tokenstr:");
    //print(tokenstr);
    //print("tokenURI:");
    //print(tokenURI);
    String lazylion = await fetchll(tokenstr);
    //print("lazylion = ");
    print(lazylion);
    Map<String, dynamic> lljson = jsonDecode(lazylion);
    //print(lljson['attributes']);
    setState(() {
      currentJson = lljson;
    });
    // Map<String, dynamic> cr_json = tokenURI[0];
    // print(cr_json.length);
    // var cr_attr = cr_json['attributes'];
    // print(cr_json['attributes']);
    // print(cr_json['attributes'][5]);
    // print(cr_json['attributes'][5]['value']);
    // print('--------------');
    // print('length of attributes: '+cr_attr.length.toString());
    // print(cr_attr);
    // print(cr_attr[5]);
    // print(cr_attr[5]['value']);
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic> currentJson = {};

  //var rpcProvider = JsonRpcProvider("https://cloudflare-eth.com");
  /*testProvider() async {
    var rpcProvider = JsonRpcProvider("https://cloudflare-eth.com");
    print(rpcProvider);
    print(await rpcProvider.getNetwork());
  }*/
  /*testInterface() async {
    final jsonInterface = Interface(jsonAbi);
    final busd = Contract(
      busdAddress,
      Interface(jsonAbi),
      rpcProvider,
    );
    print(await busd.call<String>('name'));
  }*/
  //final jsonAbi_cr = '''[{"inputs":[],"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"inputs":[],"name":"NUM_COLORS","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"NUM_LAYERS","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes1","name":"b","type":"bytes1"}],"name":"byteToHexString","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"pure","type":"function"},{"inputs":[{"internalType":"bytes1","name":"b","type":"bytes1"}],"name":"byteToUint","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"pure","type":"function"},{"inputs":[{"internalType":"uint8","name":"layerIndex","type":"uint8"},{"internalType":"uint8","name":"itemIndex","type":"uint8"}],"name":"getLayer","outputs":[{"components":[{"internalType":"string","name":"name","type":"string"},{"internalType":"bytes","name":"hexString","type":"bytes"}],"internalType":"struct ChainRunnersBaseRenderer.Layer","name":"","type":"tuple"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint16","name":"_dna","type":"uint16"},{"internalType":"uint8","name":"_index","type":"uint8"},{"internalType":"uint16","name":"_raceIndex","type":"uint16"}],"name":"getLayerIndex","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint16","name":"_dna","type":"uint16"}],"name":"getRaceIndex","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"_dna","type":"uint256"}],"name":"getTokenData","outputs":[{"components":[{"internalType":"string","name":"name","type":"string"},{"internalType":"bytes","name":"hexString","type":"bytes"}],"internalType":"struct ChainRunnersBaseRenderer.Layer[13]","name":"tokenLayers","type":"tuple[13]"},{"components":[{"internalType":"string","name":"hexString","type":"string"},{"internalType":"uint256","name":"alpha","type":"uint256"},{"internalType":"uint256","name":"red","type":"uint256"},{"internalType":"uint256","name":"green","type":"uint256"},{"internalType":"uint256","name":"blue","type":"uint256"}],"internalType":"struct ChainRunnersBaseRenderer.Color[8][13]","name":"tokenPalettes","type":"tuple[8][13]"},{"internalType":"uint8","name":"numTokenLayers","type":"uint8"},{"internalType":"string[13]","name":"traitTypes","type":"string[13]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"renounceOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"components":[{"internalType":"string","name":"name","type":"string"},{"internalType":"bytes","name":"hexString","type":"bytes"},{"internalType":"uint8","name":"layerIndex","type":"uint8"},{"internalType":"uint8","name":"itemIndex","type":"uint8"}],"internalType":"struct ChainRunnersBaseRenderer.LayerInput[]","name":"toSet","type":"tuple[]"}],"name":"setLayers","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_dna","type":"uint256"}],"name":"tokenSVG","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"components":[{"internalType":"string","name":"name","type":"string"},{"internalType":"bytes","name":"hexString","type":"bytes"}],"internalType":"struct ChainRunnersBaseRenderer.Layer[13]","name":"tokenLayers","type":"tuple[13]"},{"components":[{"internalType":"string","name":"hexString","type":"string"},{"internalType":"uint256","name":"alpha","type":"uint256"},{"internalType":"uint256","name":"red","type":"uint256"},{"internalType":"uint256","name":"green","type":"uint256"},{"internalType":"uint256","name":"blue","type":"uint256"}],"internalType":"struct ChainRunnersBaseRenderer.Color[8][13]","name":"tokenPalettes","type":"tuple[8][13]"},{"internalType":"uint8","name":"numTokenLayers","type":"uint8"}],"name":"tokenSVGBuffer","outputs":[{"internalType":"string[4]","name":"","type":"string[4]"}],"stateMutability":"pure","type":"function"},{"inputs":[{"internalType":"uint256","name":"tokenId","type":"uint256"},{"components":[{"internalType":"uint256","name":"dna","type":"uint256"}],"internalType":"struct ChainRunnersTypes.ChainRunner","name":"runnerData","type":"tuple"}],"name":"tokenURI","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint8","name":"d","type":"uint8"}],"name":"uintToHexDigit","outputs":[{"internalType":"bytes1","name":"","type":"bytes1"}],"stateMutability":"pure","type":"function"},{"inputs":[{"internalType":"uint256","name":"a","type":"uint256"}],"name":"uintToHexString2","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"pure","type":"function"},{"inputs":[{"internalType":"uint256","name":"a","type":"uint256"}],"name":"uintToHexString6","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"pure","type":"function"}]''';
  //final busdAddress_cr = '0x97597002980134beA46250Aa0510C9B90d87A587';
  //final busdAddress = '0x8943C7bAC1914C9A7ABa750Bf2B6B09Fd21037E0';

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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
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
              Expanded(
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
                              int a = int.parse(nftNumber.text);
                              print(a);
                              //print(int.parse(nftNumber.text));
                              getURIll(a);
                              //testProvider();
                              //testInterface();
                              setState(() {});
                            },
                            child: const Text('Feeling lucky?')),
                      ],
                    ),
                  ),
                ),
              )
            ]),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: true,
                  child: details(),
                ),
                (currentJson['attributes'] == null)
                    ? SizedBox(
                        //height: 50,
                        width: 100,
                        child: const DecoratedBox(
                          decoration: const BoxDecoration(color: Colors.blue),
                        ))
                    : Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.all(10),
                          itemCount: currentJson['attributes'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return Text(
                                '${currentJson['attributes'][index]['trait_type']}: ${currentJson['attributes'][index]['value']}');
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        ),
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget details() {
    print('details');
    if (currentJson['image'] != null) {
      return Image(
          width: 150,
          //height: 50,
          image: NetworkImage(currentJson['image']));
    } else {
      return SizedBox(
          height: 50,
          width: 50,
          child: const DecoratedBox(
            decoration: const BoxDecoration(color: Colors.red),
          ));
    }
  }
}
