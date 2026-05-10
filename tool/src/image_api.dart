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

/// Generation backend. Imagen models use the `predict` endpoint; Gemini
/// image models use `generateContent` with a different request/response shape.
enum _Backend { imagen, gemini }

/// Image generation quality tier.
///
/// - `fast` / `standard` / `ultra` use Imagen 4 (painterly, slower at text).
/// - `gemini` uses Gemini 2.5 Flash Image (best at legible text in images).
enum ImageQuality {
  fast('imagen-4.0-fast-generate-001', _Backend.imagen),
  standard('imagen-4.0-generate-001', _Backend.imagen),
  ultra('imagen-4.0-ultra-generate-001', _Backend.imagen),
  gemini('gemini-2.5-flash-image', _Backend.gemini)
  ;

  const ImageQuality(this.modelId, this._backend);
  final String modelId;
  final _Backend _backend;

  static ImageQuality parse(String value) => switch (value) {
    'fast' => fast,
    'standard' => standard,
    'ultra' => ultra,
    'gemini' => gemini,
    _ => throw ArgumentError(
      'Unknown quality "$value" — '
      'expected fast, standard, ultra, or gemini.',
    ),
  };
}

/// Generates a single image and returns it, or `null` on failure
/// (errors are written to stderr).
///
/// If you get a 404, the model name may have changed since this was written.
/// Check https://ai.google.dev/api/images for the current model ID.
Future<GeneratedImage?> generateImage(
  String apiKey,
  String prompt, {
  String aspectRatio = '16:9',
  ImageQuality quality = ImageQuality.fast,
}) => switch (quality._backend) {
  _Backend.imagen => _generateImagen(apiKey, prompt, aspectRatio, quality),
  _Backend.gemini => _generateGemini(apiKey, prompt, aspectRatio, quality),
};

Future<GeneratedImage?> _generateImagen(
  String apiKey,
  String prompt,
  String aspectRatio,
  ImageQuality quality,
) async {
  final client = HttpClient();
  try {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/'
      '${quality.modelId}:predict'
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

Future<GeneratedImage?> _generateGemini(
  String apiKey,
  String prompt,
  String aspectRatio,
  ImageQuality quality,
) async {
  final client = HttpClient();
  try {
    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/'
      '${quality.modelId}:generateContent'
      '?key=$apiKey',
    );

    final request = await client.postUrl(uri);
    request.headers.contentType = ContentType.json;
    request.write(
      jsonEncode({
        'contents': [
          {
            'parts': [
              {'text': prompt},
            ],
          },
        ],
        'generationConfig': {
          'responseModalities': ['IMAGE'],
          'imageConfig': {'aspectRatio': aspectRatio},
        },
      }),
    );

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode != 200) {
      stderr.writeln('  API error ${response.statusCode}: $responseBody');
      return null;
    }

    final json = jsonDecode(responseBody) as Map<String, dynamic>;
    final candidates = json['candidates'] as List?;
    if (candidates == null || candidates.isEmpty) {
      stderr.writeln('  No candidates in response.');
      return null;
    }

    final parts = ((candidates.first as Map)['content'] as Map?)?['parts'] as List?;
    if (parts == null) {
      stderr.writeln('  No parts in candidate.');
      return null;
    }

    for (final part in parts) {
      final inline = (part as Map)['inlineData'] as Map?;
      if (inline == null) continue;
      final encoded = inline['data'] as String?;
      if (encoded == null) continue;
      final mimeType = inline['mimeType'] as String? ?? 'image/png';
      return GeneratedImage(base64Decode(encoded), mimeType);
    }

    stderr.writeln('  No inlineData image part in response.');
    return null;
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
