import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_system_proxy/flutter_system_proxy.dart';
import 'package:logger/logger.dart';
import 'package:dio/io.dart'; // For IOHttpClientAdapter

class ProxyHttpClient {
  final Dio _dio;
  final Logger _logger;

  ProxyHttpClient()
      : _dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 10), // 10 seconds
          receiveTimeout: const Duration(seconds: 10), // 10 seconds
        )),
        _logger = Logger();

  Future<Uint8List?> get(String url) async {
    _logger.i('Starting request to $url');

    // Get the system proxy for the URL
    var proxy = await FlutterSystemProxy.findProxyFromEnvironment(url);

    // Set up the proxy in Dio's HttpClientAdapter
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.findProxy = (uri) {
        return proxy;
      };
      return client;
    };

    try {
      var response = await _dio.get<Uint8List>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode == 200) {
        _logger.i('Response received successfully');
        return response.data;
      } else {
        _logger.w('Error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      _logger.e('DioException: ${e.type}, ${e.message}');
      if (e.response != null) {
        _logger.e('Response data: ${e.response?.data}');
      }
      _logger.e('Stack trace: ${e.stackTrace}');
    } catch (e, stacktrace) {
      _logger.e('Exception: $e');
      _logger.e('Stack trace: $stacktrace');
    }
    return null;
  }
}
