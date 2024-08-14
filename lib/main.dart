import 'package:flutter/material.dart';

void main() {
  runApp(TicTacToeApp());
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TicTacToeHomePage(),
    );
  }
}

class TicTacToeHomePage extends StatefulWidget {
  @override
  _TicTacToeHomePageState createState() => _TicTacToeHomePageState();
}

class _TicTacToeHomePageState extends State<TicTacToeHomePage> {
  static const int gridSize = 3;
  late List<List<String>> board; // Initialize as late
  late String currentPlayer; // Initialize as late

  @override
  void initState() {
    super.initState();
    resetGame();
  }

  void resetGame() {
    board = List.generate(gridSize, (_) => List.filled(gridSize, ''));
    currentPlayer = 'X';
  }

  void handleTap(int row, int col) {
    if (board[row][col] == '' && !checkWinner()) {
      setState(() {
        board[row][col] = currentPlayer;
        if (!checkWinner()) {
          currentPlayer = currentPlayer == 'X' ? 'O' : 'X';
        }
      });
    }
  }

  bool checkWinner() {
    // Check rows and columns
    for (int i = 0; i < gridSize; i++) {
      if (board[i].every((cell) => cell == currentPlayer) ||
          List.generate(gridSize, (j) => board[j][i])
              .every((cell) => cell == currentPlayer)) {
        showWinnerDialog();
        return true;
      }
    }

    // Check diagonals
    if (List.generate(gridSize, (i) => board[i][i])
            .every((cell) => cell == currentPlayer) ||
        List.generate(gridSize, (i) => board[i][gridSize - i - 1])
            .every((cell) => cell == currentPlayer)) {
      showWinnerDialog();
      return true;
    }

    // Check for a draw
    if (board.every((row) => row.every((cell) => cell.isNotEmpty))) {
      showDrawDialog();
      return true;
    }

    return false;
  }

  void showWinnerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Player $currentPlayer Wins!',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        actions: [
          TextButton(
            child: Text('Play Again',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20)),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                resetGame();
              });
            },
          ),
        ],
      ),
    );
  }

  void showDrawDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('It\'s a Draw!'),
        actions: [
          TextButton(
            child: Text('Play Again'),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                resetGame();
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tic Tac Toe',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
        ),
        backgroundColor: Colors.blueGrey.shade800,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          gridSize,
          (row) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              gridSize,
              (col) => GestureDetector(
                onTap: () => handleTap(row, col),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1),
                    color: Colors.blueGrey.shade800,
                  ),
                  child: Center(
                    child: Text(
                      board[row][col],
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
