import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:utility/services.dart';
import 'package:web3dart/web3dart.dart';
import 'dart:math' as Math;

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
  bool isLoading = true;
  List llTags = [];
  List powerMap = [];

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(blockchainUrl, httpClient);
    getLazyLionTags();
    super.initState();
  }

  Future<void> getLazyLionTags() async {
    String getTags = await rootBundle.loadString('assets/jsons/lazyliontags.json');
    String getPower = await rootBundle.loadString('assets/jsons/powermapping.json');
    llTags = await jsonDecode(getTags);
    powerMap = await jsonDecode(getPower);
  }

  // Future<void> getLazyLionTags() async {
  //   late Client httpClient;
  //   httpClient = Client();
  //   String URL = "https://script.google.com/macros/s/AKfycbx0Vt3s67qnOaQJHdKl0EJ3-g2f_-1FWh-HuUyN3HkjnbetAhFh4Zt1q7vIKMoSTjT0Rg/exec";
  //   return await httpClient.get(Uri.parse(URL),headers: {'Content-Type': 'application/json'}).then((response) {
  //     //print(response.body);
  //     List tagString = jsonDecode(response.body);
  //     print('found tagString?');
  //     print(tagString[0]['Attribute']);
  //     llTags = tagString;
  //   });
  // }

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
      //isLoading = false;
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
  var selectedAttr = [];
  int round = 1;
  int myHealth = 10;
  int myShields = 10;
  int myAttack = 10;
  var myStats = [10, 10, 10];
  var theirStats = [12, 12, 5];
  late var myCurrentStats = List.from(myStats);
  late var theirCurrentStats = List.from(theirStats);
  int theirHealth = 12;
  int theirShields = 12;
  int theirAttack = 5;
  bool _explode = false;
  bool turn = true;
  int turns = 1;
  bool fightOver = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic> currentJson = {};

  final List<String> elements = [
    //"Loot",
    "Bored Ape Yacht Club",
    "Lazy Lions",
    //"Chain Runners"
  ];

  bool battling = false;
  bool championSelect = false;

  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text('Survive. Utility. Score.'), actions: [
        IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: 'Restart',
            onPressed: () {
              //print('lltags???');
              //print(llTags);
              getLazyLionTags();
              print('powers???');
              //print(powerMap);
              var a = powerMap.singleWhere((element) => element['Category'] == 'Food');
              print(a);
              // print(a[0]);
              print(a['Attribute']);
              // print(a[0]['Attribute']);
            }),
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
            explainer(),
            nftSelect(),
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
            if (championSelect)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: battleCard(0),
                  ),
                  Flexible(child: rightHandSide()),
                ],
              )
            else
              SizedBox(),
            SizedBox(height: 20),
            battling
                ? Text('TURN ' + turns.toString())
                : Text('Select a starting attribute.'),
            Visibility(
              visible: (championSelect && selectedAttr.length > 0 && !battling),
              child: startFight(),
            ),
            Visibility(visible: battling && !fightOver, child: continueFight()),
            Visibility(visible: battling && fightOver, child: finishFight())
          ],
        ),
      ),
    );
  }

  void fightRound() {
    print('Battle turn: ' + turns.toString());
    print('My starting stats:');
    print(myCurrentStats);
    print('Opponent starting stats:');
    print(theirCurrentStats);
    // bool turn = true;
    // while (myCurrentStats[0] > 0 && theirCurrentStats[0] > 0) {
    print('This is turn: ' + turns.toString());
    if (turn) {
      theirCurrentStats[0] = theirCurrentStats[0] - myCurrentStats[2];
    } else {
      myCurrentStats[0] = myCurrentStats[0] - theirCurrentStats[2];
    }
    setState(() {});
    turns += 1;
    // }
    setState(() {
      _explode = true;
    });
    Timer(Duration(seconds: 3), () {
      setState(() {
        _explode = false;
      });
    });
    if (myCurrentStats[0] < 1 || theirCurrentStats[0] < 1) {
      fightOver = true;
    }
    setState(() {
      print('setting some state');
      print(theirCurrentStats);
      print(theirStats);
      turn = !turn;
    });
  }

  Widget continueFight() {
    return ElevatedButton(
        onPressed: () {
          fightRound();
        },
        child: Text('Fight!'));
  }

  Widget finishFight() {
    return ElevatedButton(
        onPressed: () {
          if (myCurrentStats[0] < 0) {
            championSelect = false;
          } else {
            round += 1;
          }
          setState(() {
            myCurrentStats = List.from(myStats);
            battling = !battling;
            print('rounds = '+round.toString());
          });
        },
        child: Text(myCurrentStats[0] > 0 ? 'You Win!' : 'You Lose :('));
  }

  Widget startFight() {
    return ElevatedButton(
        onPressed: () {
          print('battle now with selectedAttr: ' + selectedAttr.toString());
          setState(() {
            theirCurrentStats = List.from(theirStats);
            turns = 1;
            fightOver = false;
            battling = true;
          });
        },
        child: Text('Start Fight!'));
  }

  void whatCategory(int i) {
    var boost;
    var checker;
    checker = llTags
        .where((element) => element['Attribute']==currentJson['attributes'][i]['trait_type'])
        .singleWhere((element) => element['Trait']==currentJson['attributes'][i]['value'],
        orElse: () => {
          "Category": "Missing"
        }
    );
    print('checker');
    print(checker);
    print(checker['Category']);
    boost = powerMap.singleWhere((element) => element['Category'] == checker['Category'], orElse: () => {
      "Attribute": 'Empty'
    });
    print('BOOST');
    print(boost['Attribute']);
    if (boost['Attribute'] == 'Shields') {
      myCurrentStats[1]+=3;
    }
    if (boost['Attribute'] == 'Health') {
      myCurrentStats[0]+=3;
    }
    if (boost['Attribute'] == 'Attack') {
      myCurrentStats[2]+=3;
    }
    if (boost['Attribute'] == 'Empty') {
      myCurrentStats[0]+=1;
      myCurrentStats[1]+=1;
      myCurrentStats[2]+=1;
    }
  }

  Widget attributesList() {
    return SizedBox(
      width: 150,
      child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            for (int i = 0; i < currentJson['attributes'].length; i++)
              InkWell(
                  onTap: () {
                    whatCategory(i);
                    if (selectedAttr.length < round) {
                      selectedAttr.add(i);
                    } else {
                      selectedAttr[round - 1] = i;
                    }
                    setState(() {});
                  },
                  child: Card(
                      color: selectedAttr.any((e) => e == i)
                          ? Colors.blue
                          : Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          '${currentJson['attributes'][i]['trait_type']}: ${currentJson['attributes'][i]['value']}',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: selectedAttr.any((e) => e == i)
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      )))
          ]),
    );
  }

  Widget battleCard(int rotate) {
    String health;
    String shields;
    String attack;
    if (rotate == 0) {
      health = myCurrentStats[0].toString();
      shields = myCurrentStats[1].toString();
      attack = myCurrentStats[2].toString();
    } else {
      health = theirCurrentStats[0].toString();
      shields = theirCurrentStats[1].toString();
      attack = theirCurrentStats[2].toString();
    }
    return Container(
      width: 150, //MediaQuery.of(context).size.width*.3,
      child: Card(
        elevation: 6,
        child: Column(mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(Math.pi * rotate),
                child: Stack(alignment: Alignment.center, children: [
                  (currentJson['image'] == null)
                      ? SizedBox()
                      : Image(
                          image: NetworkImage(currentJson['image']),
                        ),
                  (_explode && (turn == rotate.isEven))
                      ? Image(
                          height: 100,
                          image: AssetImage('assets/images/explode.gif'))
                      : SizedBox(),
                ]),
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(health, style: TextStyle(fontWeight: FontWeight.bold)),
                    Image.asset('assets/images/plus.png', width: 20),
                    SizedBox(width: 10),
                    Text(shields.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Image.asset('assets/images/shield.png', width: 20),
                    SizedBox(width: 10),
                    Text(attack, style: TextStyle(fontWeight: FontWeight.bold)),
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
            ]),
      ),
    );
  }

  Widget rightHandSide() {
    // print('rightHandSide called');
    late var item;
    if (currentJson['attributes'] == null) {
      item = 0;
    } else if (battling == false) {
      item = 1;
    } else {
      item = 2;
    }
    switch (item) {
      case 0:
        return SizedBox();
      case 1:
        return attributesList();
      case 2:
        return battleCard(1);
      default:
        return SizedBox();
    }
  }

  Widget nftSelect() {
    return Container(
      margin: EdgeInsets.all(10),
      child:
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
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
                        int a;
                        if (nftNumber.text != '') {
                          a = int.parse(nftNumber.text);
                        } else {
                          a = 9806;
                        }
                        //print(int.parse(nftNumber.text));
                        //testProvider();
                        //testInterface();

                        setState(() {
                          isLoading = true;
                          championSelect = true;
                          selectedAttr.clear();
                          round = 1;
                          battling = false;
                          fightOver = false;
                        });
                        getURIll(a);
                      },
                      child: const Text('Feeling lucky?')),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }

  Widget explainer() {
    return Card(
        elevation: 3,
        //borderOnForeground: true,
        margin: EdgeInsets.all(10),
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Reality has been fractured. Tribes must compete to earn \$utility for their survival. What tribe do you champion?',
            )));
  }
}
