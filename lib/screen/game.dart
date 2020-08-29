import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fiap_platform_channel/util/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WrapperCreator {
  final bool creator;
  final String nameGame;
  WrapperCreator(this.creator, this.nameGame);
}

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {

  TextStyle textStyle75 = TextStyle(
      fontSize: 75,
      color: Colors.white
  );
  TextStyle textStyle36 = TextStyle(
      fontSize: 36,
      color: Colors.white
  );

  bool minhaVez;
  WrapperCreator creator;

  // 0 = branco. 1 = eu. 2 - adversário
  List<List<int>> cells = [
    [0, 0, 0],
    [0, 0, 0],
    [0, 0, 0]
  ];

  static const platform = const MethodChannel('game/exchange');

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
        context,
        width: 700,
        height: 1400,
        allowFontScaling: false);

    return Scaffold(
      //stack: pilha de widgets, sendo que o últio colocado fica sobre os demais
      body: Stack(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Container(
                    width: ScreenUtil().setWidth(550),
                    height: ScreenUtil().setHeight(550),
                    color: colorBackBlue1,
                  ),
                  Container(
                    width: ScreenUtil().setWidth(150),
                    height: ScreenUtil().setHeight(550),
                    color: colorBackBlue2,
                  )
                ],
              ),
              Container(
                width: ScreenUtil().setWidth(700),
                height: ScreenUtil().setHeight(850),
                color: colorBackBlue3,
              )
            ],
          ),
          Container(
            height: ScreenUtil().setHeight(1400),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  creator == null ? Row(
                    children: [
                      buildButton("Criar", true),
                      SizedBox(width: 10),
                      buildButton("Entrar", false)
                    ],
                    mainAxisSize: MainAxisSize.min,
                  ) : Text(
                      minhaVez ? "Sua Vez!!" : "Aguarde Sua Vez!!!",
                      style: textStyle36
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(20),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 3,
                    children: <Widget>[
                      getCell(0, 0),
                      getCell(0, 1),
                      getCell(0, 2),
                      getCell(1, 0),
                      getCell(1, 1),
                      getCell(1, 2),
                      getCell(2, 0),
                      getCell(2, 1),
                      getCell(2, 2),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  //constrói as opções iniciais do jogo (criar jogo ou entrar em um jogo)
  Widget buildButton(String label, bool owner) => Container(
    width: ScreenUtil().setWidth(300),
    child: OutlineButton(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          label,
          style: textStyle36
        ),
      ),
      onPressed: (){
        createGame(owner);
      },
    ),
  );

  Widget getCell(int x, int y) =>
      InkWell(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Center(
              child: Text(
                  cells[x][y] == 0 ? " " : cells[x][y] == 1 ? "X" : "O",
                  style: textStyle75
              )
          ),
          color: Colors.lightBlueAccent,
        ),
      );

  Future<void> createGame(bool isCreator) async {
    TextEditingController editingController = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Qual o nome do jogo?'),
          content: TextField(
            controller: editingController,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Jogar'),
              onPressed: () {
                Navigator.of(context).pop();
                _sendAction('subscribe', {'channel': editingController.text}).then((value) {
                  setState(() {
                    creator = WrapperCreator(isCreator, editingController.text);
                    minhaVez = isCreator;
                  });
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _sendAction(String action, Map<String, dynamic> arguments) async {
    try {
      //neste exato momento estamos fazendo uma chamada ao código nativo
      //passando qual ação desejamos e quais os seus respetivos argumentos
      final bool result = await platform.invokeMethod(action, arguments);
      return result;
    } on PlatformException catch (e) {
      return false;
    }
  }


}