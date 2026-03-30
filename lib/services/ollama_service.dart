import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OllamaService {
  static const String defaultBaseUrl = 'http://localhost:11434';
  static const String defaultModel = 'llama3.2:3b';

  final String baseUrl;
  final String model;

  OllamaService({String? baseUrl, String? model})
    : baseUrl =
          baseUrl ??
          const String.fromEnvironment(
            'OLLAMA_BASE_URL',
            defaultValue: defaultBaseUrl,
          ),
      model =
          model ??
          const String.fromEnvironment(
            'OLLAMA_MODEL',
            defaultValue: defaultModel,
          );

  Future<String> getResponse(String prompt) async {
    final candidates = _candidateBaseUrls();
    final errors = <String>[];

    for (final candidate in candidates) {
      try {
        final response = await http
            .post(
              Uri.parse('$candidate/api/generate'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({
                'model': model,
                'prompt': prompt,
                'stream': false,
                'temperature': 0.7,
              }),
            )
            .timeout(const Duration(seconds: 35));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          final text = data['response']?.toString().trim();
          if (text != null && text.isNotEmpty) {
            return text;
          }
          return 'No response received from model.';
        }

        final error = _extractOllamaError(response.body);
        errors.add('$candidate -> HTTP ${response.statusCode}: $error');
      } on http.ClientException catch (e) {
        errors.add('$candidate -> ${e.message}');
      } on Exception catch (e) {
        errors.add(
          '$candidate -> ${e.toString().replaceFirst('Exception: ', '')}',
        );
      }
    }

    throw Exception(
      'Unable to reach local Ollama model. Tried: ${candidates.join(', ')}. Last errors: ${errors.join(' | ')}',
    );
  }

  Future<String> buildTroubleshootingMessage() async {
    final candidates = _candidateBaseUrls();
    final reachable = await isOllamaAvailable();

    if (!reachable) {
      return 'Cannot connect to local Ollama yet.\n\n'
          'Quick fix:\n'
          '1) Install Ollama from ollama.com\n'
          '2) Start server: ollama serve\n'
          '3) Pull model: ollama pull $model\n\n'
          'Tried endpoints: ${candidates.join(', ')}\n'
          'Android emulator should use 10.0.2.2 to access your PC.';
    }

    final models = await getAvailableModels();
    final installed = models.any((m) => m == model || m.startsWith('$model:'));

    if (!installed) {
      return 'Ollama is running but model "$model" is not installed.\n\n'
          'Run: ollama pull $model\n\n'
          'Installed models: ${models.isEmpty ? 'none' : models.take(8).join(', ')}';
    }

    return 'Local AI looks healthy.\n'
        'Model: $model\n'
        'Endpoints: ${candidates.join(', ')}';
  }

  Future<bool> isOllamaAvailable() async {
    for (final candidate in _candidateBaseUrls()) {
      try {
        final response = await http
            .get(Uri.parse('$candidate/api/tags'))
            .timeout(const Duration(seconds: 5));
        if (response.statusCode == 200) {
          return true;
        }
      } catch (_) {
        continue;
      }
    }
    return false;
  }

  Future<List<String>> getAvailableModels() async {
    for (final candidate in _candidateBaseUrls()) {
      try {
        final response = await http
            .get(Uri.parse('$candidate/api/tags'))
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body) as Map<String, dynamic>;
          final raw = data['models'];
          if (raw is! List) {
            return const [];
          }
          return raw
              .map((m) {
                if (m is Map<String, dynamic>) {
                  return m['name']?.toString() ?? '';
                }
                return '';
              })
              .where((name) => name.isNotEmpty)
              .toList();
        }
      } catch (_) {
        continue;
      }
    }
    return const [];
  }

  List<String> _candidateBaseUrls() {
    final urls = <String>[_normalizeBaseUrl(baseUrl)];

    if (kIsWeb) {
      _addIfMissing(urls, defaultBaseUrl);
      return urls;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      _addIfMissing(urls, 'http://10.0.2.2:11434');
      _addIfMissing(urls, 'http://127.0.0.1:11434');
      _addIfMissing(urls, 'http://localhost:11434');
      return urls;
    }

    _addIfMissing(urls, 'http://127.0.0.1:11434');
    _addIfMissing(urls, 'http://localhost:11434');
    return urls;
  }

  String _normalizeBaseUrl(String value) {
    final trimmed = value.trim();
    if (trimmed.endsWith('/')) {
      return trimmed.substring(0, trimmed.length - 1);
    }
    return trimmed;
  }

  void _addIfMissing(List<String> list, String url) {
    final normalized = _normalizeBaseUrl(url);
    if (!list.contains(normalized)) {
      list.add(normalized);
    }
  }

  String _extractOllamaError(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final error = decoded['error']?.toString();
        if (error != null && error.trim().isNotEmpty) {
          return error.trim();
        }
      }
    } catch (_) {
      // Ignore parse issues and return raw body.
    }
    return body.trim().isEmpty ? 'Unknown error' : body.trim();
  }
}
