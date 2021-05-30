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
  int _gridSize = 3;
  int _gridBoxNumber = 9;

  final List<int> _playerZeroSelectedIndex = <int>[];
  final List<int> _playerOneSelectedIndex = <int>[];
  final List<dynamic> _matrix = <dynamic>[
    <int>[-1, -1, -1, -1, -1],
    <int>[-1, -1, -1, -1, -1],
    <int>[-1, -1, -1, -1, -1],
    <int>[-1, -1, -1, -1, -1],
    <int>[-1, -1, -1, -1, -1]
  ];
  int _moves = 0;

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
        body: Container(
          color: Colors.grey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: .5,
                    ),
                  ),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _gridSize,
                    ),
                    itemCount: _gridBoxNumber,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            if (_moves < _gridBoxNumber) {
                              if (!_playerZeroSelectedIndex.contains(index) &&
                                  !_playerOneSelectedIndex.contains(index)) {
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
                            }

                            if (_moves >= _gridBoxNumber) {
                              playAgain(context);
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
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initialize() {
    _gridBoxNumber = _gridSize * _gridSize;
    for (int i = 0; i < _gridSize; i++) {
      for (int j = 0; j < _gridSize; j++) {
        _matrix[i][j] = -1;
      }
    }
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

  Future<void> playAgain(BuildContext context) {
    final AlertDialog alert = AlertDialog(
      title: const Center(child: Text('Play again!')),
      content: const Text(
        'Choose level',
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        FloatingActionButton(
          onPressed: () {
            setState(() {
              _gridSize = 3;
              initialize();
              Navigator.pop(context);
            });
          },
          child: const Text('3'),
          backgroundColor: Colors.red,
        ),
        FloatingActionButton(
          onPressed: () {
            setState(() {
              _gridSize = 4;
              initialize();
              Navigator.pop(context);
            });
          },
          child: const Text('4'),
          backgroundColor: Colors.green,
        ),
        FloatingActionButton(
          onPressed: () {
            setState(() {
              _gridSize = 5;
              initialize();
              Navigator.pop(context);
            });
          },
          child: const Text('5'),
          backgroundColor: Colors.red,
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            setState(() {
              initialize();
              Navigator.pop(context);
            });
          },
          iconSize: 64.0,
          color: Colors.green,
        ),
      ],
    );

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
