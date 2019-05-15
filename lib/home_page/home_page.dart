import 'package:flutter_web/material.dart';
import 'chess_board_widget/chess_board_widget.dart';
import 'chess_board_widget/chess_board.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<ChessBoard> chessBoards = List.generate(64, (_) => ChessBoard.random());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Eight Queens'),
      ),
      body: GridView.builder(
        itemCount: 64,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8, childAspectRatio: 1),
        itemBuilder: (context, i) {
          return Card(
            child: ChessBoardWidget(chessBoard: chessBoards[i]),
          );
        },
      ),
    );
  }
}
