import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wanoiro/wacolor.dart';

final colorProvider =
    StateNotifierProvider<ColorState, ColorData>((_) => ColorState());

// ------------------------------------------------------------------------
void main() {
  runApp(const ProviderScope(child: WanoiroApp()));
}

// ------------------------------------------------------------------------
class WanoiroApp extends StatelessWidget {
  const WanoiroApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wanoiro(和の色)',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'NotoSerifJP'),
      home: MainWindow(),
    );
  }
}

// ------------------------------------------------------------------------
// 色のデータを管理するクラス。
class ColorState extends StateNotifier<ColorData> {
  ColorState() : super(ColorData());

  // 色をランダムに選択する。前回と違う色。
  void randomColor() {
    var c = ColorManager().randomColor();
    while (c == state.color) {
      c = ColorManager().randomColor();
    }

    state = state.copyWith(color: c);
  }

  // 渡された色名で検索し、その色に切り替える。見付からなかったときはエラーフラグを立てる。
  void searchColor(String name) {
    final c = ColorManager().colorNamed(name);

    if (c == null) {
      state = state.copyWith(searchError: true);
    } else {
      state = ColorData(color: c);
    }
  }
}

// ------------------------------------------------------------------------
// 色のデータを扱う不変データクラス。
@immutable
class ColorData {
  // コンストラクタ。引数で色が与えられなかったときはランダムな色で初期化する。
  ColorData({
    WaColor? color,
    bool? searchError,
  })  : color = color ?? ColorManager().randomColor(),
        searchError = searchError ?? false;

  final WaColor color; // 表示する色。
  final bool searchError; // テキストフィールドで検索した結果がエラーか否かのフラグ。

  ColorData copyWith({
    WaColor? color,
    bool? searchError,
  }) {
    return ColorData(
      color: color ?? this.color,
      searchError: searchError ?? this.searchError,
    );
  }
}

// ------------------------------------------------------------------------
class MainWindow extends ConsumerWidget {
  MainWindow({Key? key}) : super(key: key);

  final fieldController = TextEditingController();
  final fieldFocus = FocusNode();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(body: Center(
      // 全体の背景色を変更する関係上、Consumer で大きな範囲を括る。
      child: Consumer(
        builder: (context, ref, _) {
          final viewColor = ref.watch(colorProvider).color;
          final searchError = ref.watch(colorProvider).searchError;

          // 表示する色の明るさに応じて文字色等を選択する。ボタンの文字色と背景色があるので交換。
          var color1 = Colors.black.withOpacity(0.8);
          var color2 = Colors.white.withOpacity(0.8);
          if (viewColor.toColor().computeLuminance() < 0.4) {
            final c = color1;
            color1 = color2;
            color2 = c;
          }

          return AnimatedContainer(
            decoration: BoxDecoration(color: viewColor.toColor()),
            constraints: const BoxConstraints.expand(),
            duration: const Duration(milliseconds: 200),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // 検索フィールド - - - - - - - - - - - - - - - - -
                Container(
                  width: 160,
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 24),
                  child: TextField(
                    controller: fieldController,
                    focusNode: fieldFocus,
                    style: TextStyle(
                        color: searchError ? Colors.red : Colors.black),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.4),
                        hintText: '色名で検索',
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    searchError ? Colors.red : Colors.black)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    searchError ? Colors.red : Colors.black))),
                    onSubmitted: (str) {
                      // すべての文字を選択する。
                      fieldController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: fieldController.text.length);
                      // フォーカスが移動しないようにする。
                      fieldFocus.requestFocus();
                      // 検索して変更。
                      ref.read(colorProvider.notifier).searchColor(str);
                    },
                  ),
                ),
                // ランダム選択ボタン - - - - - - - - - - - - - - - - -
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        ref.read(colorProvider.notifier).randomColor();
                      },
                      style: ElevatedButton.styleFrom(primary: color1),
                      child: Text(
                        '無作為選択',
                        style: TextStyle(fontSize: 14, color: color2),
                      )),
                ),
                // 色名表示 - - - - - - - - - - - - - - - - -
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 18, 0, 0),
                  child: Text(
                    viewColor.yomi,
                    style: TextStyle(
                      color: color1,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  viewColor.kanji,
                  style: TextStyle(
                    color: color1,
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  viewColor.colorCode,
                  style: TextStyle(
                    color: color1,
                    fontSize: 18,
                  ),
                ),
                Text(
                  viewColor.rgbString(),
                  style: TextStyle(
                    color: color1,
                    fontSize: 18,
                  ),
                ),
                Text(
                  viewColor.hslString(),
                  style: TextStyle(
                    color: color1,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ));
  }
}
