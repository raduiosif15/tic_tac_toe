import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToe());
}

class TicTacToe extends StatefulWidget {
  const TicTacToe({Key? key}) : super(key: key);

  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  static const Color _freeBoxColor = Colors.grey;
  static const Color _playerZeroColor = Colors.red;
  static const Color _playerOneColor = Colors.green;
  static const int _gridSize = 3;
  static const int _gridBoxNumber = 9;

  final List<int> _playerZeroSelectedIndex = <int>[];
  final List<int> _playerOneSelectedIndex = <int>[];
  List<dynamic> _matrix = <dynamic>[];
  int _moves = 0;

  void initialize() {
    _matrix = <dynamic>[
      <int>[-1, -1, -1],
      <int>[-1, -1, -1],
      <int>[-1, -1, -1]
    ];
    _playerZeroSelectedIndex.clear();
    _playerOneSelectedIndex.clear();
    _moves = 0;
  }

  bool isValidMatrix(int index, int player) {
    final int x = index ~/ _gridSize;
    final int y = index % _gridSize;

    // check col
    for (int i = 0; i < _gridSize; i++) {
      if (_matrix[x][i] != player) {
        break;
      }
      if (i == _gridSize - 1) {
        return true;
      }
    }

    //check row
    for (int i = 0; i < _gridSize; i++) {
      if (_matrix[i][y] != player) {
        break;
      }
      if (i == _gridSize - 1) {
        return true;
      }
    }

    //check diag
    if (x == y) {
      for (int i = 0; i < _gridSize; i++) {
        if (_matrix[i][i] != player) {
          break;
        }
        if (i == _gridSize - 1) {
          return true;
        }
      }
    }

    //check anti diag
    if (x + y == _gridSize - 1) {
      for (int i = 0; i < _gridSize; i++) {
        if (_matrix[i][(_gridSize - 1) - i] != player) {
          break;
        }
        if (i == _gridSize - 1) {
          return true;
        }
      }
    }

    // otherwise
    return false;
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Tic Tac Toe',
            style: TextStyle(
              color: Colors.amberAccent,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.grey[800],
          shadowColor: Colors.amberAccent,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _gridSize,
                  ),
                  itemCount: _gridBoxNumber,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (_moves < _gridBoxNumber) {
                            // moves % 2 == 0 => player zero
                            if (_moves.isEven) {
                              _playerZeroSelectedIndex.add(index);
                              _matrix[index ~/ _gridSize][index % _gridSize] = 0;
                            } else {
                              _playerOneSelectedIndex.add(index);
                              _matrix[index ~/ _gridSize][index % _gridSize] = 1;
                            }

                            if (isValidMatrix(index, _matrix[index ~/ _gridSize][index % _gridSize] as int)) {
                              if (_moves.isEven) {
                                // clear player one
                                _playerOneSelectedIndex.clear();
                              } else {
                                // clear player zero
                                _playerZeroSelectedIndex.clear();
                              }
                              _moves = _gridBoxNumber;
                            }

                            _moves++;
                          }
                        });
                      },
                      child: AnimatedContainer(
                        padding: const EdgeInsets.all(1.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: .5,
                          ),
                          color: (_playerZeroSelectedIndex.contains(index))
                              ? _playerZeroColor
                              : ((_playerOneSelectedIndex.contains(index)) ? _playerOneColor : _freeBoxColor),
                        ),
                        duration: const Duration(milliseconds: 250),
                      ),
                    );
                  }),
            ),
            Expanded(
              flex: 2,
              child: (_moves >= _gridBoxNumber)
                  ? IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        setState(() {
                          initialize();
                        });
                      },
                      iconSize: 128.0,
                    )
                  : const Text(''),
            ),
          ],
        ),
      ),
    );
  }
}
