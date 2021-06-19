import 'package:flutter_test/flutter_test.dart';
import 'package:wanoiro/wacolor.dart';

void main() {
  group('WaColor.isEqualName()', () {
    test('萌葱色', () {
      final c = WaColor('萌葱色', 'もえぎいろ', '#006e54');
      expect(c.isEqualName('萌葱色色'), false);
      expect(c.isEqualName('萌葱色'), true);
      expect(c.isEqualName('萌葱'), true);
      expect(c.isEqualName('萌'), false);
      expect(c.isEqualName('もえぎいろいろ'), false);
      expect(c.isEqualName('もえぎいろ'), true);
      expect(c.isEqualName('もえぎ'), true);
      expect(c.isEqualName('もえ'), false);
      expect(c.isEqualName('も'), false);
    });
    test('百入茶', () {
      final c = WaColor('百入茶', 'ももしおちゃ', '#1f3134');
      expect(c.isEqualName('百入茶色色'), false);
      expect(c.isEqualName('百入茶色'), true);
      expect(c.isEqualName('百入茶'), true);
      expect(c.isEqualName('百入'), false);
      expect(c.isEqualName('ももしおちゃいろいろ'), false);
      expect(c.isEqualName('ももしおちゃいろ'), true);
      expect(c.isEqualName('ももしおちゃ'), true);
      expect(c.isEqualName('ももしお'), false);
    });
  });

  // -------------------------------------------------------
  group('ColorManager', () {
    test(' test', () {
      final m = ColorManager();
      expect(m.colorNamed('小豆')?.kanji, '小豆色');
      expect(m.colorNamed('未存在'), null);
    });
  });
}
