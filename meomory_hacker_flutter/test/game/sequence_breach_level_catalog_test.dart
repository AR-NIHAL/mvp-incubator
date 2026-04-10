import 'package:flutter_test/flutter_test.dart';
import 'package:memory_hacker_flutter/game/providers/sequence_breach_level_catalog.dart';

void main() {
  test('catalog exposes at least ten handcrafted levels', () {
    expect(allSequenceBreachLevels.length, greaterThanOrEqualTo(10));
    expect(allSequenceBreachLevels.first.id, 'boot-sequence');
    expect(allSequenceBreachLevels.last.id, 'core-breach');
  });

  test('lookup returns exact level and no unknown fallback', () {
    final level = sequenceBreachLevelById('packet-drift');

    expect(level, isNotNull);
    expect(level?.title, 'Packet Drift');
    expect(sequenceBreachLevelById('unknown-level'), isNull);
  });
}
