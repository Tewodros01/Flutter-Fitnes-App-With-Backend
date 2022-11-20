import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CallApi {
  final String _url = 'http://10.0.2.2:8000/api/';
  final String _imgUrl = 'http://10.0.2.2:8000/uploads/';
  getImage() {
    return _imgUrl;
  }

  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl + await _getToken();
    return await http.post(
      Uri.parse(fullUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  postLike(data, apiUrl) async {
    try {
      var fullUrl = _url + apiUrl + await _getToken();
      http.Response response = await http.post(
        Uri.parse(fullUrl),
        body: jsonEncode(data),
        headers: _setHeaders(),
      );

      if (response.statusCode == 200) {
        print("Response  ${response.body}");
        return response;
      } else {
        print("Response  ${response.body}");
        return 'failes';
      }
    } catch (e) {
      print(e);
      return 'failed';
    }
  }

  getPublicDataByRequest(apiUrl, data) async {
    var fullUrl = _url + apiUrl + await _getToken();
    final url = Uri.parse(fullUrl).replace(queryParameters: data);
    http.Response response = await http.get(
      url,
      headers: _setHeaders(),
    );
    try {
      if (response.statusCode == 200) {
        print(response.body);
        return response;
      } else {
        print(response.body);
        return 'failes';
      }
    } catch (e) {
      print(e);
      return 'failed';
    }
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl + await _getToken();
    return await http.get(
      Uri.parse(fullUrl),
      headers: _setHeaders(),
    );
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return '?token=$token';
  }

  getPublicData(apiUrl) async {
    try {
      http.Response response = await http.get(Uri.parse(_url + apiUrl));

      if (response.statusCode == 200) {
        print(response.body);
        return response;
      } else {
        print(response.body);
        return 'failes';
      }
    } catch (e) {
      print(e);
      return 'failed';
    }
  }
}
