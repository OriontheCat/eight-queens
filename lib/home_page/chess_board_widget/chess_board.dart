import 'dart:math' as math;

class Queen {
  final int x;
  final int y;
  const Queen(this.x, this.y);
  factory Queen.random() {
    math.Random random = math.Random();
    int x = (random.nextDouble() * 8).toInt();
    int y = (random.nextDouble() * 8).toInt();
    return Queen(x, y);
  }

  @override
  bool operator ==(dynamic other) => other.x == x && other.y == y;

  String toString() => "{$x.$y}";
}

class ChessBoard {
  final List<Queen> queens;
  final List<List<Queen>> attackVectors;
  const ChessBoard._(this.queens,this.attackVectors);
  factory ChessBoard(List<Queen> queens) => ChessBoard._(queens,getAttackVectors(queens));
  factory ChessBoard.random() {
    List<Queen> queens = [];
    for (int i = 0; i < 8; i++) {
      Queen tempQueen;
      do {
        tempQueen = Queen.random();
      } while (queens.contains(tempQueen));
      queens.add(tempQueen);
    }
    ;
    return ChessBoard(queens);
  }

  ChessBoard procreate(ChessBoard other) {
    math.Random random = math.Random();
    List<Queen> newQueens = List<Queen>(8);
    for (int i = 0; i < queens.length; i++) {
      bool randomBool = random.nextBool();
      Queen tempQueen;
      void tryMine(){
        for(int i =0; i < queens.length && newQueens.contains(tempQueen);i++){
          tempQueen == queens[i];
        }
      }
      void tryOthers(){
        for(int i =0; i < other.queens.length && newQueens.contains(tempQueen);i++){
          tempQueen == other.queens[i];
        }
      }
      if (randomBool) {
        tryMine();
        tryOthers();
      } else {
        tryOthers();
        tryMine();
      }
      while(newQueens.contains(tempQueen)){
        tempQueen == Queen.random();
      }
      newQueens.add(tempQueen);
    }
    return ChessBoard(newQueens);
  }

  static List<List<Queen>> getAttackVectors(List<Queen> queens) {
    List<List<Queen>> attackVectors = [];
    for (int i = 0; i < queens.length; i++) {
      for (int j = i + 1; j < queens.length; j++) {
        //same column
        if (queens[i].x == queens[j].x) {
          attackVectors.add([queens[i], queens[j]]);
          print(attackVectors);
          continue;
        }
        //same row
        if (queens[i].y == queens[j].y) {
          attackVectors.add([queens[i], queens[j]]);
          print(attackVectors);
          continue;
        }
        //same diagonal
        if ((queens[i].x - queens[j].x).abs() ==
            (queens[i].y - queens[j].y).abs()) {
          attackVectors.add([queens[i], queens[j]]);
          print(attackVectors);
          continue;
        }
      }
    }
    return attackVectors;
  }
}
