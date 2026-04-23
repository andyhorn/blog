import 'package:flutter_test/flutter_test.dart';

import 'package:blog/models/post.dart';

void main() {
  group('PostMeta encode/decode', () {
    final date = DateTime(2025, 3, 14);

    test('round-trips all fields including image', () {
      final meta = PostMeta(
        title: 'Hello World',
        date: date,
        description: 'A test post',
        tags: ['dart', 'flutter'],
        slug: 'hello-world',
        image: '/images/posts/hello-world.jpg',
      );

      final decoded = PostMeta.decode(meta.encode());

      expect(decoded.title, meta.title);
      expect(decoded.date, meta.date);
      expect(decoded.description, meta.description);
      expect(decoded.tags, meta.tags);
      expect(decoded.slug, meta.slug);
      expect(decoded.image, meta.image);
    });

    test('round-trips with image null', () {
      final meta = PostMeta(
        title: 'No Image Post',
        date: date,
        description: 'No cover image',
        tags: ['architecture'],
        slug: 'no-image-post',
      );

      final decoded = PostMeta.decode(meta.encode());

      expect(decoded.image, isNull);
    });

    test('encode produces expected keys', () {
      final meta = PostMeta(
        title: 'Test',
        date: date,
        description: 'Desc',
        tags: [],
        slug: 'test',
      );
      final map = meta.encode();

      expect(map.keys, containsAll(['title', 'date', 'description', 'tags', 'slug', 'image']));
    });

    test('encode serializes date as ISO 8601', () {
      final meta = PostMeta(
        title: 'T',
        date: date,
        description: '',
        tags: [],
        slug: 't',
      );
      expect(meta.encode()['date'], date.toIso8601String());
    });

    test('decode preserves tag order', () {
      final tags = ['open source', 'devx', 'dart'];
      final meta = PostMeta(
        title: 'T',
        date: date,
        description: '',
        tags: tags,
        slug: 't',
      );
      expect(PostMeta.decode(meta.encode()).tags, tags);
    });
  });

  group('Post encode/decode', () {
    final meta = PostMeta(
      title: 'A Post',
      date: DateTime(2024, 6, 1),
      description: 'Summary',
      tags: ['flutter'],
      slug: 'a-post',
      image: '/images/posts/a-post.jpg',
    );

    test('round-trips all fields', () {
      final post = Post(
        meta: meta,
        htmlContent: '<p>Hello</p>',
        readingTimeMinutes: 3,
      );

      final decoded = Post.decode(post.encode());

      expect(decoded.meta.title, post.meta.title);
      expect(decoded.meta.slug, post.meta.slug);
      expect(decoded.meta.image, post.meta.image);
      expect(decoded.htmlContent, post.htmlContent);
      expect(decoded.readingTimeMinutes, post.readingTimeMinutes);
    });

    test('encode produces expected keys', () {
      final post = Post(meta: meta, htmlContent: '<p>x</p>', readingTimeMinutes: 1);
      expect(post.encode().keys, containsAll(['meta', 'htmlContent', 'readingTimeMinutes']));
    });
  });
}
