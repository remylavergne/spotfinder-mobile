import 'dart:typed_data';

import 'dart:convert';

import 'package:http/http.dart';

class HttpClient extends Client {
  @override
  void close() {
    // TODO: implement close
  }

  @override
  Future<Response> delete(url, {Map<String, String> headers}) {
      // TODO: implement delete
      throw UnimplementedError();
    }
  
    @override
    Future<Response> get(url, {Map<String, String> headers}) {
      // TODO: implement get
      throw UnimplementedError();
    }
  
    @override
    Future<Response> head(url, {Map<String, String> headers}) {
      // TODO: implement head
      throw UnimplementedError();
    }
  
    @override
    Future<Response> patch(url, {Map<String, String> headers, body, Encoding encoding}) {
      // TODO: implement patch
      throw UnimplementedError();
    }
  
    @override
    Future<Response> post(url, {Map<String, String> headers, body, Encoding encoding}) {
      // TODO: implement post
      throw UnimplementedError();
    }
  
    @override
    Future<Response> put(url, {Map<String, String> headers, body, Encoding encoding}) {
      // TODO: implement put
      throw UnimplementedError();
    }
  
    @override
    Future<String> read(url, {Map<String, String> headers}) {
      // TODO: implement read
      throw UnimplementedError();
    }
  
    @override
    Future<Uint8List> readBytes(url, {Map<String, String> headers}) {
      // TODO: implement readBytes
      throw UnimplementedError();
    }
  
    @override
    Future<StreamedResponse> send(BaseRequest request) {
    // TODO: implement send
    throw UnimplementedError();
  }
  // HttpClient._privateConstructor();

  // static final HttpClient _instance = HttpClient._privateConstructor();

  // factory HttpClient() {
  //   return _instance;
  // }




}
