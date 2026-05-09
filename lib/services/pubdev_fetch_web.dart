import 'dart:convert';
import 'dart:js_interop';

extension type _FetchResponse._(JSObject _) implements JSObject {
  external bool get ok;
  external int get status;
  external JSPromise<JSString> text();
}

@JS('fetch')
external JSPromise<_FetchResponse> _fetch(String url);

Future<Map<String, dynamic>> fetchJson(String url) async {
  final response = await _fetch(url).toDart;
  if (!response.ok) {
    throw StateError('HTTP ${response.status} for $url');
  }
  final text = (await response.text().toDart).toDart;
  return jsonDecode(text) as Map<String, dynamic>;
}
