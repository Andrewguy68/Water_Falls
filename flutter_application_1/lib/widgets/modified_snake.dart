import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_application_1/objects/sim_state.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'package:flutter_application_1/objects/simulation.dart';


class Snake extends StatefulWidget {
  Snake({super.key, this.rows = 20, this.columns = 20, this.cellSize = 10.0}){
    assert(10 <= rows);
    assert(10 <= columns);
    assert(5.0 <= cellSize);

    state = GameState(rows, columns);
  }

  final int rows;
  final int columns;
  final double cellSize;

  late GameState state;

  // SnakeState snakestate = SnakeState(rows, columns, cellSize);
  // late SnakeState snakestate;

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => SnakeState(rows, columns, state, cellSize);
  // snakestate = SnakeState(rows, columns, cellSize);
  
  // @override
  // void altertap(Tap tap) {
  //   state(() {

  //   });
  }

class SnakeBoardPainter extends CustomPainter {
  SnakeBoardPainter(this.state, this.cellSize);

  GameState? state;
  double cellSize;

  @override
  void paint(Canvas canvas, Size size) {
    final blackLine = Paint()..color = Colors.black;
    // final blackFilled = Paint()
    //   ..color = Colors.black
    //   ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        state!.columns * cellSize,
        state!.rows * cellSize,
      ),
      blackLine,
    );
    for (int x = 0; x < state!.columns; x++) {
      for (int y = 0; y < state!.rows; y++) {
        final a = Offset(cellSize * x, cellSize * y);
        final b = Offset(cellSize * (x + 1), cellSize * (y + 1));

        final density = state!.fluid.sampleField(
          (x + 0.5) * state!.fluid.h,
          (y + 0.5) * state!.fluid.h,
          Field.S_FIELD,
        );
        int airColor = (255 * (1.0 - density)).toInt();

        final colorfilled = Paint();
          if (state!.fluid.isCellSolid(x, y)) {
            colorfilled.color = const Color.fromARGB(255, 128, 64, 0);
          }
          else {
            colorfilled.color = Color.fromARGB(255, airColor, airColor, 255);
          }
          colorfilled.style = PaintingStyle.fill;

        canvas.drawRect(Rect.fromPoints(a, b), colorfilled);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class SnakeState extends State<Snake> {
  SnakeState(int rows, int columns, this.state, this.cellSize);

  double cellSize;
  GameState? state;
  AccelerometerEvent? acceleration;
  late StreamSubscription<AccelerometerEvent> _streamSubscription;
  late Timer _timer;

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
    _timer.cancel();
  }

  @override
  void initState() {
    super.initState();
    _streamSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        acceleration = event;
      });
    });

    _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      setState(() {
        _step();
      });
    });
  }

  void _step() {
    final newDirection = acceleration == null
        ? null
        : acceleration!.x.abs() < 1.0 && acceleration!.y.abs() < 1.0
            ? null
            : (acceleration!.x.abs() < acceleration!.y.abs())
                ? math.Point<double>(0, acceleration!.y.sign.toDouble())
                : math.Point<double>(-acceleration!.x.sign.toDouble(), 0);
    state!.step(newDirection);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) {
        final gridX = event.localPosition.dx / cellSize;
        final gridY = event.localPosition.dy / cellSize;

        final fluidX = (gridX + 0.5) * state!.fluid.h;
        final fluidY = (gridY + 0.5) * state!.fluid.h;

        state!.alterterrain(fluidX, fluidY);
        setState(() {});
      },
      child: CustomPaint(
        size: Size(
          widget.columns * cellSize,
          widget.rows * cellSize,
        ),
        painter: SnakeBoardPainter(state, cellSize),
      ),
    );
  }
}