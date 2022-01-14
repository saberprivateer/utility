import 'dart:convert';

import 'package:flutter/material.dart';

Widget loading() {
  return Center(
    child: CircularProgressIndicator(),
  );
}
// Future<void> getURIcr() async {
//   print('get the URI');
//   List<dynamic> tokenURI = await callFunction("tokenURI");
//   String tokenstr = tokenURI[0];
//   tokenstr = tokenstr.substring(29);
//   print('substring has a length of ' + tokenstr.length.toString());
//   String decoded = utf8.decode(base64.decode(tokenstr));
//   Map<String, dynamic> cr_json = jsonDecode(decoded);
//   print(cr_json.length);
//   var cr_attr = cr_json['attributes'];
//   print(cr_json['attributes']);
//   print(cr_json['attributes'][5]);
//   print(cr_json['attributes'][5]['value']);
//   print('--------------');
//   print('length of attributes: ' + cr_attr.length.toString());
//   print(cr_attr);
//   print(cr_attr[5]);
//   print(cr_attr[5]['value']);
// }
