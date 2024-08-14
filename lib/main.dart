import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'proxy_http_client.dart'; // Import the class

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
              var client = ProxyHttpClient();
              client.get('http://172.20.16.10:5000/SecureApp/check-user/54321');
            },
            child: Text('Check User'),
          ),
        ),
      ),
    );
  }
}
