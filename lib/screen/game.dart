import 'package:flutter/material.dart';
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

  TextStyle textStyle = TextStyle(
      fontSize: 75,
      color: Colors.white
  );
  TextStyle textStyle36 = TextStyle(
      fontSize: 36,
      color: Colors.white
  );

  bool minhaVez;
  WrapperCreator creator;

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
    ),
  );

}