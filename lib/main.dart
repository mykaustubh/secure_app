import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'proxy_http_client.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  logger.d('Button Pressed');
                  var client = ProxyHttpClient();
                  client.get(
                      'http://172.20.16.10:5000/SecureApp/check-user/54321');
                },
                child: Text('Check User'),
              ),
              const SizedBox(height: 20),
              SvgImageWidget(
                url: 'https://static.qa.m2exchange.com/img/mmx.svg',
              ),
              SvgImageWidget(
                url: 'https://static.qa.m2exchange.com/img/crv.svg',
              ),
              SvgImageWidget(
                url: 'https://static.qa.m2exchange.com/img/shib.svg',
              ),
              SvgImageWidget(
                url: 'https://static.qa.m2exchange.com/img/Coin=usdt.svg',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SvgImageWidget extends StatefulWidget {
  final String url;

  const SvgImageWidget({Key? key, required this.url}) : super(key: key);

  @override
  _SvgImageWidgetState createState() => _SvgImageWidgetState();
}

class _SvgImageWidgetState extends State<SvgImageWidget> {
  Uint8List? svgData;
  final client = ProxyHttpClient();

  @override
  void initState() {
    super.initState();
    fetchSvgImage();
  }

  Future<void> fetchSvgImage() async {
    var data = await client.get(widget.url);
    if (data != null) {
      setState(() {
        svgData = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return svgData != null
        ? SvgPicture.memory(
            svgData!,
            height: 100,
            width: 100,
            placeholderBuilder: (context) => CircularProgressIndicator(),
          )
        : CircularProgressIndicator();
  }
}
