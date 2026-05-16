import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

void main() async {
  final host = InternetAddress.anyIPv4;
  final port = int.tryParse(Platform.environment['API_PORT'] ?? '') ?? 8080;
  final router = Router()
    ..get('/health', _health)
    ..get('/restaurants', _restaurants)
    ..get('/orders', _orders);

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_jsonHeaders())
      .addHandler(router.call);

  final server = await serve(handler, host, port);
  stdout
      .writeln('Baker server running on ${server.address.host}:${server.port}');
}

Response _health(Request request) {
  return _json({
    'status': 'ok',
    'service': 'baker-server',
    'databaseUrlConfigured':
        (Platform.environment['DATABASE_URL'] ?? '').isNotEmpty,
  });
}

Response _restaurants(Request request) {
  return _json({
    'data': [
      {
        'name': 'Bon Bakery',
        'category': 'Bakery and desserts',
        'rating': 4.8,
        'deliveryMinutes': 25,
      },
      {
        'name': 'Meal Monkey Legacy',
        'category': 'Food delivery reference',
        'rating': 4.6,
        'deliveryMinutes': 32,
      },
    ],
  });
}

Response _orders(Request request) {
  return _json({
    'data': [
      {
        'code': 'BA-0001',
        'customer': 'Internal QA',
        'total': 42.50,
        'status': 'Draft',
      },
      {
        'code': 'BA-0002',
        'customer': 'Kitchen test',
        'total': 18.90,
        'status': 'Queued',
      },
    ],
  });
}

Middleware _jsonHeaders() {
  return (innerHandler) {
    return (request) async {
      final response = await innerHandler(request);
      return response.change(
        headers: {
          ...response.headers,
          HttpHeaders.contentTypeHeader: ContentType.json.mimeType,
        },
      );
    };
  };
}

Response _json(Map<String, Object?> body, {int statusCode = 200}) {
  return Response(statusCode, body: jsonEncode(body));
}
