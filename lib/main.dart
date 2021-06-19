import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:wanoiro/wacolor.dart';

void main() {
  runApp(WanoiroApp());
}

class WanoiroApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wanoiro',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'NotoSerifJP'),
      home: Wanoiro(title: 'Flutter Demo Home Page'),
    );
  }
}

class Wanoiro extends StatefulWidget {
  Wanoiro({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _WanoiroState createState() => _WanoiroState();
}

class _WanoiroState extends State<Wanoiro> {
  ColorManager colorManager = ColorManager();
  late var viewColor = colorManager.randomColor(); // 最初の色

  bool searchColorError = false; // テキストフィールドで検索した結果がエラーか否かのフラグ。
  final fieldController = TextEditingController();
  final fieldFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    // 表示する色の明るさに応じて文字色等を選択する。
    Color color1 = Colors.black.withOpacity(0.8);
    Color color2 = Colors.white.withOpacity(0.8);
    if (viewColor.toColor().computeLuminance() < 0.4) {
      final c = color1;
      color1 = color2;
      color2 = c;
    }

    return Scaffold(
      body: Center(
        child: AnimatedContainer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: TextField(
                  controller: fieldController,
                  focusNode: fieldFocus,
                  style: TextStyle(
                      color: searchColorError ? Colors.red : Colors.black),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.4),
                      hintText: '色名で検索',
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: searchColorError
                                  ? Colors.red
                                  : Colors.black)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: searchColorError
                                  ? Colors.red
                                  : Colors.black))),
                  onSubmitted: (str) {
                    // すべての文字を選択する。
                    fieldController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: fieldController.text.length);
                    // フォーカスが移動しないようにする。
                    fieldFocus.requestFocus();

                    final c = colorManager.colorNamed(str);
                    if (c != null) {
                      setState(() {
                        viewColor = c;
                        searchColorError = false;
                      });
                    } else {
                      setState(() {
                        searchColorError = true;
                      });
                    }
                  },
                ),
                width: 160,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 24),
              ),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      // 色をランダムに選択し、前回と違うものが出るまでループ。
                      var color = colorManager.randomColor();
                      while (color == viewColor) {
                        color = colorManager.randomColor();
                      }
                      setState(() {
                        viewColor = color;
                      });
                    },
                    child: Text(
                      '無作為選択',
                      style: TextStyle(fontSize: 14, color: color2),
                    ),
                    style: ElevatedButton.styleFrom(primary: color1)),
              ),
              Container(
                child: Text(
                  viewColor.yomi,
                  style: TextStyle(
                    color: color1,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                margin: EdgeInsets.fromLTRB(0, 18, 0, 0),
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
          decoration: BoxDecoration(color: viewColor.toColor()),
          constraints: BoxConstraints.expand(),
          duration: Duration(milliseconds: 200),
        ),
      ),
    );
  }
}
