import 'package:flutter_web/material.dart';
import 'chess_board_widget/chess_board_widget.dart';
import 'chess_board_widget/chess_board.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ChessBoard> chessBoards;
  bool evolving = false;
  double ratio = 0.1;
  int framerate = 10;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eight Queens'),
      ),
      body: Container(
        child: chessBoards == null ? generateGrid() : buildGrid(),
      ),
      floatingActionButton: buildFloatingActionButton(),
    );
  }

  FutureBuilder generateGrid() {
    return FutureBuilder(
        future: compute<List<ChessBoard>, Object>((_) {
          
        }, null),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          chessBoards = snapshot.data;
          chessBoards.sort();
          return buildGrid();
        });
  }

  GridView buildGrid() {
    return GridView.builder(
      itemCount: chessBoards.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, i) {
        return Card(
          child: ChessBoardWidget(chessBoard: chessBoards[i]),
        );
      },
    );
  }

  FloatingActionButton buildFloatingActionButton() {
    IconData iconData = evolving ? Icons.pause : Icons.play_arrow;
    // Function onPressed = evolving
    //     ? () {
    //         setState(() {
    //           evolving = false;
    //         });
    //       }
    //     : () async {
    //         setState(() {
    //           evolving = true;
    //         });
    //         while (evolving) {
    //           unawaited(() async {
    //             unawaited(compute<Object, Object>((_) => evolve(), null));
    //             await Future.delayed(Duration(seconds: 1));
    //           }());
    //           evolve();
    //         }
    //       };
    Function onPressed = () async {
      ChessBoard newChessBoard =
          await await chessBoards.first.procreate(chessBoards.last);
      setState(() {
        chessBoards[1] = newChessBoard;
      });
    };
    return FloatingActionButton(
      child: Icon(iconData),
      onPressed: onPressed,
    );
  }

  void evolve() {
    setState(() async {
      List<ChessBoard> oldChessBoards = [
        ...chessBoards.sublist(0, (chessBoards.length * ratio).toInt())
      ];
      List<ChessBoard> newChessBoards = [...oldChessBoards];
      List<Future<ChessBoard>> newChessBoardGenerators = [];
      while (newChessBoardGenerators.length - oldChessBoards.length <
          chessBoards.length) {
        for (int i = 0;
            i < oldChessBoards.length &&
                newChessBoardGenerators.length - oldChessBoards.length <
                    chessBoards.length;
            i++) {
          for (int j = i + 1;
              j < oldChessBoards.length &&
                  newChessBoardGenerators.length - oldChessBoards.length <
                      chessBoards.length;
              j++) {
            print(newChessBoardGenerators.length - oldChessBoards.length <
                chessBoards.length);
            newChessBoardGenerators
                .add(oldChessBoards[i].procreate(oldChessBoards[j]));
          }
        }
      }
      newChessBoards.addAll(await Future.wait(newChessBoardGenerators));
      chessBoards = newChessBoards;
    });
  }
}
