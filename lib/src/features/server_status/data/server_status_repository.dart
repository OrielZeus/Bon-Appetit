import 'package:bon_appetit/src/core/network/api_client.dart';

class ServerStatusRepository {
  ServerStatusRepository({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  final ApiClient _apiClient;

  Future<ServerStatus> fetchStatus() async {
    final response = await _apiClient.getJson('/health');
    return ServerStatus(
      status: response['status'] as String? ?? 'unknown',
      service: response['service'] as String? ?? 'baker-server',
      databaseUrlConfigured:
          response['databaseUrlConfigured'] as bool? ?? false,
    );
  }
}

class ServerStatus {
  const ServerStatus({
    required this.status,
    required this.service,
    required this.databaseUrlConfigured,
  });

  final String status;
  final String service;
  final bool databaseUrlConfigured;
}
