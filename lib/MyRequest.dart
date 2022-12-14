import 'Values.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode, utf8;

class MyRequest {
  String pwd = Values.pwd;
  String url = Values.url;
  late String _sql;
  late Uri uri;
  late String requestURL;
  var queryParameters;


  MyRequest(String sql) {
    _sql = sql.toLowerCase();
    _sql = Uri.encodeQueryComponent(_sql);
    //for some reason there will be Error 503 when including this words
    _sql = _sql.replaceAll("into", "in!to")
               .replaceAll("values", "va!lues");
    this.requestURL = "$url?pwd=$pwd&sql=$_sql&json=true";
    print (requestURL);
  }

  Future<String> httpPost() async {
    //funktioniert nicht. gibt XMLHttpRequest error. Hat wohl was mit CORS zu tun
    var myHeaders = {
      'Content-Type': 'text/plain',
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "GET,PUT,PATCH,POST,DELETE",
      "Access-Control-Allow-Headers": "Origin, X-Requested-With, Content-Type, Accept"
    };
    final response = await http.get(
        Uri.parse(Values.url +
            "?pwd=" +
            pwd +
            "&sql=" +
            _sql.replaceAll(" ", "+").replaceAll(",", "%2C") +
            "&json=true"),
        headers: myHeaders);
    //final response = await http.post(Values.uri, body: queryParameters);
    print("response-len: " + response.body.length.toString());
    return response.body;
  }

  Future<String> getResponse() async {
    final response = await http.get(Uri.parse(requestURL));
    if (response.statusCode == 200) {
      print("got response");
      return response.body;
    }
    int responseCode = response.statusCode;
    return "failed:$responseCode";
  }
}
