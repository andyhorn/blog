// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

/// Result of a successful image generation call.
class GeneratedImage {
  GeneratedImage(this.bytes, this.mimeType);

  final List<int> bytes;
  final String mimeType;

  String get extension => switch (mimeType) {
    'image/jpeg' || 'image/jpg' => 'jpg',
    'image/webp' => 'webp',
    _ => 'png',
  };
}

/// Calls the Imagen `predict` endpoint and returns the generated image,
/// or `null` on failure (errors are written to stderr).
///
/// If you get a 404, the model name may have changed since this was written.
/// Check https://ai.google.dev/api/images for the current model ID.
Future<GeneratedImage?> generateImage(
  String apiKey,
  String prompt, {
  String aspectRatio = '16:9',
}) async {
  final client = HttpClient();
  try {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/'
      'imagen-4.0-fast-generate-001:predict'
      '?key=$apiKey',
    );

    final request = await client.postUrl(uri);
    request.headers.contentType = ContentType.json;
    request.write(
      jsonEncode({
        'instances': [
          {'prompt': prompt},
        ],
        'parameters': {'sampleCount': 1, 'aspectRatio': aspectRatio},
      }),
    );

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode != 200) {
      stderr.writeln('  API error ${response.statusCode}: $responseBody');
      return null;
    }

    final json = jsonDecode(responseBody) as Map<String, dynamic>;
    final predictions = json['predictions'] as List?;
    if (predictions == null || predictions.isEmpty) {
      stderr.writeln('  No predictions in response.');
      return null;
    }

    final prediction = predictions.first as Map;
    final encoded = prediction['bytesBase64Encoded'] as String?;
    if (encoded == null) {
      stderr.writeln('  No image data in response.');
      return null;
    }

    final mimeType = prediction['mimeType'] as String? ?? 'image/png';
    return GeneratedImage(base64Decode(encoded), mimeType);
  } finally {
    client.close();
  }
}

/// Reads `GEMINI_API_KEY` from the environment, exiting with a helpful
/// message if it's missing.
String requireApiKey() {
  final apiKey = Platform.environment['GEMINI_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    stderr.writeln(
      'Error: GEMINI_API_KEY environment variable not set.\n'
      'Run: source bin/get-gemini-api-key.sh',
    );
    exit(1);
  }
  return apiKey;
}
