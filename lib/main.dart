import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
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

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final nftNumber = TextEditingController();
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )
    ..repeat(reverse: true);
  late Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: Offset(1.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ));
  List llTags = [];
  List powerMap = [];
  double slider = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(blockchainUrl, httpClient);
    getLazyLionTags();
    super.initState();
  }

  Future<void> getLazyLionTags() async {
    String getTags =
    await rootBundle.loadString('assets/jsons/lazyliontags.json');
    String getPower =
    await rootBundle.loadString('assets/jsons/powermapping.json');
    llTags = await jsonDecode(getTags);
    powerMap = await jsonDecode(getPower);
  }

  Future<List<dynamic>> callFunction(String name,
      {int nftNumber = 9806}) async {
    print('call function');
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
    print('didnt get here?');
    String tokenstr = tokenURI[0];
    String lazylion = await fetchll(tokenstr);
    //print(lazylion);
    Map<String, dynamic> lljson = jsonDecode(lazylion);
    // return lljson;
    setState(() {
      charJson = lljson;
    });
  }

  Future<DeployedContract> getContract() async {
    print('getting that contract');
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
  var enemyAttr = [];
  int round = 1;
  int myHealth = 10;
  int myShields = 10;
  int myAttack = 10;
  var myStartingStats = [10, 10, 10];
  var myStats = [10, 10, 10];
  var theirStats = [12, 12, 5];
  var tempStats = [0, 0, 0];
  late var myCurrentStats = List.from(myStats);
  late var theirCurrentStats = List.from(theirStats);
  int theirHealth = 12;
  int theirShields = 12;
  int theirAttack = 5;
  bool _explode = false;
  bool turn = true;
  int turns = 1;
  bool fightOver = false;
  bool newChallengerLoaded = false;
  bool winner = false;
  bool loser = false;
  bool tribeSelected = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic> currentJson = {};
  Map<String, dynamic> enemy = {};
  Map<String, dynamic> charJson = {};

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
                resetGame();
                championSelect = false;
                setState(() {

                });
            }),
        IconButton(
            icon: const Icon(Icons.description),
            tooltip: 'White Paper',
            onPressed: () {
              _controller.reset();
            }),
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
            if(!championSelect) tribeSelect(),
            if(tribeSelected) nftSelect(),
            (!winner && !loser && championSelect)
                ? Text('ROUND $round',
                style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Horizon',
                    fontWeight: FontWeight.bold))
                : SizedBox(),
            if (championSelect)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: battleCard(0, currentJson['image'] ?? ''),
                  ),
                  Flexible(child: rightHandSide()),
                ],
              )
            else
              SizedBox(),
            SizedBox(height: 20),
            if (battling)
              Text('TURN ' + turns.toString())
            else
              if (round == 1 && championSelect)
                Text('Select a starting attribute.')
              else
                if (!winner && !loser && championSelect)
                  Text('Select another attribute...grow stronger.'),
            SizedBox(height: 20),
            Visibility(
              visible: (championSelect &&
                  (selectedAttr.length == round) &&
                  !battling &&
                  !winner &&
                  !loser),
              child: startFight(),
            ),
            Visibility(
                visible: battling && !fightOver && newChallengerLoaded,
                child: continueFight()),
            Visibility(visible: battling && fightOver, child: finishFight()),
            if (winner) triumph()
            // if (winner) ElevatedButton(onPressed: () {resetGame(); setState(() {
            //   championSelect = false;
            // });}, child: triumph())
            // //Text('You have Play again')),
          ],
        ),
      ),
    );
  }

  void challengerAttributes() {
    int l = enemy['attributes'].length;
    enemyAttr = List.generate(l, (i) => i);
    enemyAttr.shuffle();
    int j;
    for (int i = 0; i < round; i++) {
      j = enemyAttr[i] + 1;
      print(enemy['attributes'][j]);
      //TODO: grab the info and add it to stats.
    }
    print(enemyAttr);
  }

  void newChallenger() {
    print('A new challenger approaches!');
    Random random = new Random();
    int randomNumber = random.nextInt(10000);
    print(randomNumber);
    getURIll(randomNumber).then((_) {
      setState(() {
        enemy = charJson;
        newChallengerLoaded = true;
        challengerAttributes();
      });
    });
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
    // return MaterialButton(
    //   color: Colors.blue,
    //     shape: CircleBorder(),
    //     onPressed: () {});
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          // primary: Colors.red
        ),
        onPressed: () {
          print('next round of fighting!');
          fightRound();
        },
        child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: DefaultTextStyle(
              style: const TextStyle(fontSize: 24.0),
              child: AnimatedTextKit(
                animatedTexts: [WavyAnimatedText('Fight!')],
                onTap: () {
                  print('next round of fighting!');
                  fightRound();
                },
              ),
            )
          // Text('Fight!',
          //     style: TextStyle(color: Colors.white, fontSize: 24)),
        ));
  }

  Widget finishFight() {
    return ElevatedButton(
        onPressed: () {
          print('The fight is over...going back to management');
          if (myCurrentStats[0] < 0) {
            loser = true;
            championSelect = false;
          } else {
            round += 1;
            if (round == 4) {
              winner = true;
            }
          }
          setState(() {
            myCurrentStats = List.from(myStats);
            battling = !battling;
            newChallengerLoaded = false;
            enemy['image'] = '';
          });
        },
        child: Text(myCurrentStats[0] > 0 ? 'You Win!' : 'You Lose :('));
  }

  Widget startFight() {
    return ElevatedButton(
        onPressed: () {
          print('Selected an attribute and starting the fight!');
          //TODO: make this generalizable
          myStats[0] += tempStats[0];
          myStats[1] += tempStats[1];
          myStats[2] += tempStats[2];
          myCurrentStats = List.from(myStats);
          setState(() {
            //TODO: Function for picking a random fighter and assigning stats.
            theirCurrentStats = List.from(theirStats);
            turns = 1;
            turn = true;
            fightOver = false;
            battling = true;
            tempStats = [0, 0, 0];
          });
          newChallenger();
        },
        child: Text('Start Fight!'));
  }

  void whatCategory(int i) {
    //TODO: grab info for enemy too
    var boost;
    var checker;
    checker = llTags
        .where((element) =>
    element['Attribute'] == currentJson['attributes'][i]['trait_type'])
        .singleWhere(
            (element) =>
        element['Trait'] == currentJson['attributes'][i]['value'],
        orElse: () => {"Category": "Missing"});
    // print('checker');
    // print(checker);
    // print(checker['Category']);
    boost = powerMap.singleWhere(
            (element) => element['Category'] == checker['Category'],
        orElse: () => {"Attribute": 'Empty'});
    // print('BOOST');
    // print(boost['Attribute']);
    tempStats = [0, 0, 0];
    if (boost['Attribute'] == 'Shields') {
      tempStats[1] = 3;
    }
    if (boost['Attribute'] == 'Health') {
      tempStats[0] += 3;
    }
    if (boost['Attribute'] == 'Attack') {
      tempStats[2] += 3;
    }
    if (boost['Attribute'] == 'Empty') {
      tempStats[0] += 1;
      tempStats[1] += 1;
      tempStats[2] += 1;
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
                    if (selectedAttr.contains(i)) {
                      return;
                    } else if (!winner && !loser) {
                      whatCategory(i);
                      if (selectedAttr.length < round) {
                        selectedAttr.add(i);
                      } else {
                        selectedAttr[round - 1] = i;
                      }
                      setState(() {});
                    }
                  },
                  child: Card(
                      color: selectedAttr.any((e) => e == i)
                          ? (selectedAttr.indexOf(i) == (round - 1))
                          ? Colors.blue
                          : Colors.grey
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

  Widget battleCard(int rotate, String url) {
    String health;
    String shields;
    String attack;
    //TODO: parameter?
    if (rotate == 0) {
      health = (myCurrentStats[0] + tempStats[0]).toString();
      shields = (myCurrentStats[1] + tempStats[1]).toString();
      attack = (myCurrentStats[2] + tempStats[2]).toString();
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
                // transform: Matrix4.translation(),
                child: Stack(alignment: Alignment.center, children: [
                  CachedNetworkImage(
                    imageUrl: url,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) =>
                        CircularProgressIndicator(
                            value: downloadProgress.progress),
                    errorWidget: (context, url, error) =>
                    // Icon(Icons.error),
                    SizedBox(),
                  ),
                  // Image(
                  //         image: NetworkImage(currentJson['image']),
                  //       ),
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
        return battleCard(1, enemy['image'] ?? '');
      default:
        return SizedBox();
    }
  }

  Widget nftSelect() {
    //(kIsWeb) ? print('k is totally web') : print('k is NOT web');
    return Container(
      margin: EdgeInsets.all(10),
      child:
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        (!kIsWeb)
            ? CachedNetworkImage(
          width: 100,
          height: 100,
          imageUrl: "https://www.loot.exchange/lootbag.png",
          // errorWidget: (context, url, error) => Icon(Icons.error),
          fadeOutDuration: const Duration(milliseconds: 500),
          fadeInDuration: const Duration(seconds: 1),
        )
            : Image.network('https://www.loot.exchange/lootbag.png',
            width: 100, height: 100),
        // Image(
        // height: 100,
        // width: 100,
        // image: NetworkImage('https://www.loot.exchange/lootbag.png')),
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
                        print('selected an NFT #');
                        int a;
                        if (nftNumber.text != '') {
                          a = int.parse(nftNumber.text);
                        } else {
                          a = 9806;
                        }
                        resetGame();
                        setState(() {
                          championSelect = true;
                        });
                        //print(int.parse(nftNumber.text));
                        //testProvider();
                        //testInterface();
                        getURIll(a).then((_) {
                          setState(() {
                            currentJson = charJson;
                          });
                        });
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

  void resetGame() {
    setState(() {
      tribeSelected = false;
      winner = false;
      loser = false;
      selectedAttr.clear();
      round = 1;
      battling = false;
      fightOver = false;
      //TODO: Different starting stats based on stuff?
      myStats = List.from(myStartingStats);
      myCurrentStats = List.from(myStats);
      tempStats = [0, 0, 0];
      newChallengerLoaded = false;
    });
  }

  Widget explainer() {
    return Card(
        elevation: 3,
        //borderOnForeground: true,
        margin: EdgeInsets.all(10),
        child: Padding(
            padding: EdgeInsets.all(20),
            child:
            // AnimatedTextKit(
            //   animatedTexts: [
            //     TyperAnimatedText('Reality has been fractured.'),
            //     TyperAnimatedText(
            //         'Tribes must compete to earn \$utility for their survival.'),
            //     TyperAnimatedText('What tribe do you champion?')
            //   ],
            // )
            Text(
              'Reality has been fractured. Tribes must compete to earn \$utility for their survival. What tribe do you champion?',
            )));
  }

  Widget triumph() {
    const colorizeColors = [
      Colors.purple,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ];

    const colorizeTextStyle = TextStyle(
        fontSize: 20.0, fontFamily: 'Horizon', fontWeight: FontWeight.bold);

    return SizedBox(
      // width: 250.0,
      child: AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(
              'You have triumphed! Play again?',
              textStyle: colorizeTextStyle,
              colors: colorizeColors,
            ),
          ],
          isRepeatingAnimation: true,
          totalRepeatCount: 20,
          onTap: () {
            resetGame();
            setState(() {
              championSelect = false;
            });
          }),
    );
  }

  Widget tribeSelect() {
    return Column(
        children: [
          GridView.extent(
            shrinkWrap: true,
              maxCrossAxisExtent: 130.0,
              crossAxisSpacing: 0.0,
              mainAxisSpacing: 0.0,
              children: elements
                  .map((el) =>
                  Card(
                      color: Colors.lightBlue[100],
                      child: InkWell(
                        onTap: () {
                          tribeSelected = true;
                          setState(() {

                          });
                        },
                        child: Center(
                            child: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(el,
                                textAlign: TextAlign.center))),
                      )
                  ))
                  .toList()),
          Text('The NFT\'s description')
        ]
    );
  }

}
