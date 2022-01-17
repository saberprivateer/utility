import 'dart:convert';
import 'package:http/http.dart';


import 'package:flutter/material.dart';

Future<Map<String, dynamic>> getLazyLionTags() async {
  late Client httpClient;
  httpClient = Client();
  String URL = "https://script.google.com/macros/s/AKfycbx0Vt3s67qnOaQJHdKl0EJ3-g2f_-1FWh-HuUyN3HkjnbetAhFh4Zt1q7vIKMoSTjT0Rg/exec";
  return await httpClient.get(Uri.parse(URL)).then((response) {
    Map<String, dynamic> tagString = jsonDecode(response.body);
    print('found tagString?');
    print(tagString);
    return tagString;
  });
}

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
