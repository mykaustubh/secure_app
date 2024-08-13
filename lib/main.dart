import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  try {
    final response = await http.get(Uri.parse(url));
    logger.d('Request completed');
    if (response.statusCode == 200) {
      logger.i('Response: ${response.body}');
    } else {
      logger.w('Error: ${response.statusCode}');
    }
  } catch (e) {
    logger.e('Exception: $e');
  }
}
