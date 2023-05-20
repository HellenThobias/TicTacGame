import 'package:flutter/material.dart';
import 'package:tic_tac_game/ui/theme/color.dart';
import 'package:tic_tac_game/utils/game_logic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //this is how to remove the debug ribon

      title: 'A Tic Tac Game',
     
      home: GameScreen(),
    );
  }
}


class GameScreen extends StatefulWidget{
  const GameScreen({ Key? key }) : super(key:key);

  @override
  _GameScreenState createState() =>_GameScreenState();  
}
  
class _GameScreenState extends State<GameScreen> {
  //adding necessary variables.
  String lastValue = "X";
  bool gameOver = false;
  int turn =0; // to check the draw
  String result = "";
  List<int> scoreboard = [0,0,0,0,0,0,0,0]; // score for raw1,2,3, column1,2,3 and diagonal
  
  //declaring a new Game components
  Game game = Game();
  //here we initiate the game board
  @override
  void initState(){
    super.initState();
    game.board = Game.initGameBoard();
    print(game.board);
  }

  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MainColor.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "It's ${lastValue} turn".toUpperCase(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 58,
            ) 
          ),
          SizedBox(
            height: 20.0,
          ),

          //here goes the game board. First we will create a Game class that will contain all the data and method that we will need
          Container(
            width: boardWidth,
            height: boardWidth,
            child: GridView.count(
              crossAxisCount: Game.boardLenth ~/3, 
              // the ~/ operator allows you to evide to interger and return an int as a result
              padding: EdgeInsets.all(16.0),
              //here is where we gonna draw the blocks inside the board
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              children: List.generate(Game.boardLenth, (index){
              return InkWell(
                onTap: gameOver ? null : (){
                  //when we click we need to add new value to the board and refresh the screen.
                  
                  if (game.board![index] == ""){
                    setState(() { 
                    game.board![index] = lastValue;
                    turn++;
                    gameOver = game.winnerCheck(lastValue, index, scoreboard, 3);

                    if(gameOver){
                      result = "$lastValue is the Winner";
                    }else if(!gameOver && turn ==9){
                      result = "It's a Draw!";
                      gameOver = true;
                    }
                    if (lastValue == "X")
                      lastValue = "O";
                    else
                      lastValue = "X"; 
                    });             
                  }
                  
                },
                  child: Container(
                  width: Game.blocSize,
                  height: Game.blocSize,
                  decoration: BoxDecoration(
                    color: MainColor.secondaryColor,
                    borderRadius: BorderRadius.circular(16.0)
                     ),
                  child: Center(
                    child: Text(game.board![index], style: TextStyle(color: game.board![index] == "X" ?Colors.blue:Colors.pink, fontSize: 64.0))
                  ),   
                ),
              );
            }),)
          ),

          SizedBox(height: 25.0,),
          Text(result, style:TextStyle(color: Colors.white, fontSize: 46.0)),

          //the refresh or replay button
          ElevatedButton.icon(
            onPressed: (){
              setState(() {
                //here we erase the board
                game.board = Game.initGameBoard();
                lastValue = "X";
                gameOver = false;
                turn = 0;
                result = "";
                scoreboard = [0,0,0,0,0,0,0,0];
                              
              });
            }, 
            icon: Icon(Icons.replay),
            label: Text("New Game"),
            ),
            
        ],
      ),
    );
    //the first step is to organize our project folder structure.
  }
}
