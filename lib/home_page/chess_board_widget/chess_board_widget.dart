import 'package:flutter_web/material.dart';
import 'chess_board.dart';

class ChessBoardPainter extends CustomPainter {
  final List<Queen> queens;
  final List<List<Queen>> attackVectors;
  final ThemeData themeData;

  ChessBoardPainter({
    @required this.queens,
    @required this.attackVectors,
    @required this.themeData,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    //draw background
    paint.color = themeData.cardColor;
    Rect background = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(background, paint);
    //draw board
    //rows
    paint.color = themeData.textTheme.body1.color;
    for (int i = 0; i <= 8; i++) {
      Offset p1 = Offset(
        0,
        i * (size.height / 8),
      );
      Offset p2 = Offset(
        size.width,
        i * (size.height / 8),
      );
      canvas.drawLine(p1, p2, paint);
    }
    //columns
    for (int i = 0; i <= 8; i++) {
      Offset p1 = Offset(
        i * (size.width / 8),
        0,
      );
      Offset p2 = Offset(
        i * (size.width / 8),
        size.height,
      );
      canvas.drawLine(p1, p2, paint);
    }
    //draw queens
    void drawQueen(int x, int y) {
      Offset c = Offset(x * (size.width / 8) + (size.width / 8) / 2,
          y * (size.height / 8) + (size.height / 8) / 2);
      canvas.drawCircle(c, size.width / 32, paint);
    }

    for (Queen queen in queens) {
      drawQueen(queen.x, queen.y);
    }
    //draw attack vectors
    paint.color = Colors.red;
    void drawAttackVector(List<Queen> attackVectors) {
      Offset p1 = Offset(
        attackVectors.first.x * (size.width / 8) + (size.width / 8) / 2,
        attackVectors.first.y * (size.height / 8) + (size.height / 8) / 2,
      );
      Offset p2 = Offset(
        attackVectors.last.x * (size.width / 8) + (size.width / 8) / 2,
        attackVectors.last.y * (size.height / 8) + (size.height / 8) / 2,
      );
      canvas.drawLine(p1, p2, paint);
    }

    for (List<Queen> attackVector in attackVectors) {
      drawAttackVector(attackVector);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return null;
  }
}

class ChessBoardWidget extends StatelessWidget {
  final ChessBoard chessBoard;

  ChessBoardWidget({
    @required this.chessBoard,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: ChessBoardPainter(
            queens: chessBoard.queens,
            attackVectors: chessBoard.attackVectors,
            themeData: Theme.of(context)),
      ),
    );
  }
}
