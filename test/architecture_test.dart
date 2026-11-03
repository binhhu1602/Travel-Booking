import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

const packagePrefix = 'package:travel_booking/';
final importPattern = RegExp(
  r'''^(?:import|export)\s+'([^']+)'.*''',
  multiLine: true,
);

/// Đường dẫn trong lib/ của mọi file mà [file] import, dạng 'modules/a/a.dart'.
Iterable<String> libImports(File file) sync* {
  final path = file.path.replaceAll(r'\', '/');
  final base = Uri.parse(path.substring(path.indexOf('lib/') + 4));
  for (final match in importPattern.allMatches(file.readAsStringSync())) {
    final target = match.group(1)!;
    if (target.startsWith(packagePrefix)) {
      yield target.substring(packagePrefix.length);
    } else if (!target.contains(':')) {
      yield base.resolve(target).path;
    }
  }
}

List<File> dartFilesIn(String dir) => Directory(dir)
    .listSync(recursive: true)
    .whereType<File>()
    .where((file) => file.path.endsWith('.dart'))
    .toList();

void main() {
  test('module chỉ gọi module khác qua cổng công khai', () {
    final violations = <String>[];
    for (final file in dartFilesIn('lib/modules')) {
      final path = file.path.replaceAll(r'\', '/');
      final module = path.split('/modules/').last.split('/').first;
      for (final target in libImports(file)) {
        if (!target.startsWith('modules/')) continue;
        final other = target.split('/')[1];
        final isBarrel = target == 'modules/$other/$other.dart';
        if (other != module && !isBarrel) violations.add('$path -> $target');
      }
    }
    expect(violations, isEmpty);
  });

  test('hotel_detail không phụ thuộc ngược vào layout_lab', () {
    final violations = <String>[
      for (final file in dartFilesIn('lib/modules/hotel_detail'))
        for (final target in libImports(file))
          if (target.startsWith('modules/layout_lab/'))
            '${file.path} -> $target',
    ];
    expect(violations, isEmpty);
  });

  test('core không phụ thuộc vào module nào', () {
    final violations = <String>[
      for (final file in dartFilesIn('lib/core'))
        for (final target in libImports(file))
          if (target.startsWith('modules/')) '${file.path} -> $target',
    ];
    expect(violations, isEmpty);
  });
}
