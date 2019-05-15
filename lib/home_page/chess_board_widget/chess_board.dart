import 'dart:math' as math;

import 'package:flutter_web/material.dart';

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

class ChessBoard implements Comparable<ChessBoard> {
  final List<Queen> queens;
  final List<List<Queen>> attackVectors;
  const ChessBoard._(this.queens, this.attackVectors);
  static Future<ChessBoard> generate(List<Queen> queens) async =>
      ChessBoard._(queens, await getAttackVectors(queens));
  static Future<ChessBoard> random() async {
    List<Queen> queens = await compute<Object, List<Queen>>((_) {
      List<Queen> queens = [];
      for (int i = 0; i < 8; i++) {
        Queen tempQueen;
        do {
          tempQueen = Queen.random();
        } while (queens.contains(tempQueen));
        queens.add(tempQueen);
      }
      return queens;
    }, null);
    return await ChessBoard.generate(queens);
  }

  Future<ChessBoard> procreate(ChessBoard other) async {
    return await compute<ChessBoard, Future<ChessBoard>>(
        (ChessBoard other) async {
      math.Random random = math.Random();
      List<Queen> newQueens = List<Queen>(8);
      for (int i = 0; i < newQueens.length; i++) {
        bool randomBool = random.nextBool();
        Queen newQueen;
        if (randomBool) {
          newQueen = queens[i];
        } else {
          newQueen = other.queens[i];
        }

        newQueens[i] = newQueen;
      }
      return await ChessBoard.generate(newQueens);
    }, other);
  }

  static Future<List<List<Queen>>> getAttackVectors(List<Queen> queens) async =>
      await compute<List<Queen>, List<List<Queen>>>((List<Queen> queens) {
        List<List<Queen>> attackVectors = [];
        for (int i = 0; i < queens.length; i++) {
          for (int j = i + 1; j < queens.length; j++) {
            //same column
            if (queens[i].x == queens[j].x) {
              attackVectors.add([queens[i], queens[j]]);
              continue;
            }
            //same row
            if (queens[i].y == queens[j].y) {
              attackVectors.add([queens[i], queens[j]]);
              continue;
            }
            //same diagonal
            if ((queens[i].x - queens[j].x).abs() ==
                (queens[i].y - queens[j].y).abs()) {
              attackVectors.add([queens[i], queens[j]]);
              continue;
            }
          }
        }
        return attackVectors;
      }, queens);
  int compareTo(ChessBoard other) =>
      this.attackVectors.length - other.attackVectors.length;
}
