import 'dart:convert';

import 'package:http/http.dart' as http;

class GeminiService {
  static const String _manualApiKey = 'PASTE_GEMINI_API_KEY';
  static const String model = 'gemini-2.5-flash';
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  final String apiKey;

  GeminiService({String? apiKey})
    : apiKey =
          apiKey ??
          const String.fromEnvironment(
            'GEMINI_API_KEY',
            defaultValue: _manualApiKey,
          );

  bool get isConfigured {
    final token = apiKey.trim();
    return token.isNotEmpty && !token.startsWith('PASTE_');
  }

  Future<String> getResponse(String prompt) async {
    if (!isConfigured) {
      throw Exception('Gemini API key is missing.');
    }

    final uri = Uri.parse('$_baseUrl/$model:generateContent?key=$apiKey');
    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'systemInstruction': {
              'parts': [
                {
                  'text':
                      'You are a professional, evidence-based clinical assistant for a health app. '
                      'Use a calm, concise bedside manner. Do not mention model names, AI, prompts, '
                      'or internal limitations unless the user directly asks. '
                      'Give practical next steps, red-flag warnings, and when needed suggest seeking in-person care. '
                      'Never claim to have performed a physical exam, tests, or a confirmed diagnosis. '
                      'Always structure your answer with exactly these section titles in this order: '
                      'Assessment, Possible causes, What to do now, Red flags. '
                      'Under each section, use short bullet points. Keep language simple and direct. '
                      'If information is missing, ask up to 3 targeted follow-up questions at the end. '
                      'Do not provide medication doses for prescription-only drugs. '
                      'When symptoms could be urgent (for example chest pain, breathing difficulty, stroke signs, '
                      'severe bleeding, fainting, suicidal thoughts), advise immediate emergency care.',
                },
              ],
            },
            'contents': [
              {
                'role': 'user',
                'parts': [
                  {'text': prompt},
                ],
              },
            ],
            'generationConfig': {'temperature': 0.7, 'maxOutputTokens': 700},
          }),
        )
        .timeout(const Duration(seconds: 40));

    if (response.statusCode != 200) {
      final message = _extractErrorMessage(response.body);
      throw Exception(
        'Gemini request failed (${response.statusCode}): $message',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = data['candidates'];
    if (candidates is List && candidates.isNotEmpty) {
      final first = candidates.first;
      if (first is Map<String, dynamic>) {
        final content = first['content'];
        if (content is Map<String, dynamic>) {
          final parts = content['parts'];
          if (parts is List && parts.isNotEmpty) {
            final text = (parts.first as Map<String, dynamic>)['text']
                ?.toString()
                .trim();
            if (text != null && text.isNotEmpty) {
              return text;
            }
          }
        }
      }
    }

    throw Exception('Gemini returned an empty response.');
  }

  String buildTroubleshootingMessage() {
    if (!isConfigured) {
      return 'Gemini API key is not configured.\n\n'
          'Paste your key in:\n'
          'lib/services/gemini_service.dart -> _manualApiKey\n\n'
          'Then run:\n'
          'flutter run';
    }

    return 'Gemini is configured.\n'
        'Model: $model\n'
        'Endpoint: $_baseUrl/$model:generateContent';
  }

  String _extractErrorMessage(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final error = decoded['error'];
        if (error is Map<String, dynamic>) {
          final message = error['message']?.toString();
          if (message != null && message.trim().isNotEmpty) {
            return message.trim();
          }
        }
      }
    } catch (_) {
      // Ignore parse issues and fall back to body.
    }
    return body.trim().isEmpty ? 'Unknown error' : body.trim();
  }
}
