import 'dart:io';

import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_system_proxy/flutter_system_proxy.dart';
import 'package:logger/logger.dart';

var logger = Logger();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SecureApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('SecureApp'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              logger.d('Button Pressed');
              checkUser();
            },
            child: Text('Check User'),
          ),
        ),
      ),
    );
  }
}

Future<void> checkUser() async {
  final String url = 'http://172.20.16.10:5000/SecureApp/check-user/54321';
  logger.i('Starting request to $url');

  // Get the system proxy for the URL
  var proxy = await FlutterSystemProxy.findProxyFromEnvironment(url);

  // Initialize Dio with proxy settings
  var dio = Dio();
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (HttpClient client) {
    client.findProxy = (uri) {
      return proxy;
    };
  };

  try {
    var response = await dio.get(url);
    if (response.statusCode == 200) {
      logger.i('Response: ${response.data}');
    } else {
      logger.w('Error: ${response.statusCode}');
    }
  } catch (e) {
    logger.e('Exception: $e');
  }
}
