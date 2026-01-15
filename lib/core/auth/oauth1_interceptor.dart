import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';

class OAuth1Interceptor extends Interceptor {
  final String consumerKey;
  final String consumerSecret;

  OAuth1Interceptor({required this.consumerKey, required this.consumerSecret});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final timestamp =
        (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();
    final nonce = _generateNonce();

    final parameters = {
      'oauth_consumer_key': consumerKey,
      'oauth_nonce': nonce,
      'oauth_signature_method': 'HMAC-SHA1',
      'oauth_timestamp': timestamp,
      'oauth_version': '1.0',
    };

    final method = options.method.toUpperCase();
    final baseUrl = options.uri.origin + options.uri.path;
    final allParams = {...parameters, ...options.queryParameters};
    final paramString = _normalizeParams(
      allParams.map((key, value) => MapEntry(key, value.toString())),
    );
    final signatureBase =
        '$method&${Uri.encodeComponent(baseUrl)}&${Uri.encodeComponent(paramString)}';
    final signingKey = '${Uri.encodeComponent(consumerSecret)}&';
    final signature = _generateSignature(signatureBase, signingKey);

    parameters['oauth_signature'] = signature;

    final authHeader =
        'OAuth ' +
        parameters.entries
            .map(
              (e) =>
                  '${Uri.encodeComponent(e.key)}="${Uri.encodeComponent(e.value)}"',
            )
            .join(', ');

    options.headers['Authorization'] = authHeader;
    return handler.next(options);
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz';
    final rand = Random();
    return List.generate(
      length,
      (_) => charset[rand.nextInt(charset.length)],
    ).join();
  }

  String _normalizeParams(Map<String, String> params) {
    final sorted =
        params.entries.toList()..sort((a, b) => a.key.compareTo(b.key));
    return sorted
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  String _generateSignature(String base, String key) {
    final hmac = Hmac(sha1, utf8.encode(key));
    final digest = hmac.convert(utf8.encode(base));
    return base64Encode(digest.bytes);
  }
}
