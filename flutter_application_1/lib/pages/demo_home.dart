import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/modified_snake.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorHomePage extends StatefulWidget {
  const SensorHomePage({super.key, this.title});

  final String? title;

  @override
  SensorHomePageState createState() => SensorHomePageState();
}

class SensorHomePageState extends State<SensorHomePage> {
  static const int _snakeRows = 100;
  static const int _snakeColumns = 100;
  static const double _snakeCellSize = 4.0;

  late final Snake _snake;

  List<double>? _accelerometerValues;
  List<double>? _userAccelerometerValues;
  List<double>? _gyroscopeValues;
  List<double>? _magnetometerValues;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  @override
  void dispose() {
    super.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _snake = Snake(
      rows: _snakeRows,
      columns: _snakeColumns,
      cellSize: _snakeCellSize,
    );
    _streamSubscriptions.add(
      accelerometerEvents.listen((AccelerometerEvent event) {
        setState(() {
          _accelerometerValues = <double>[event.x, event.y, event.z];
        });
      }),
    );
    _streamSubscriptions.add(
      gyroscopeEvents.listen((GyroscopeEvent event) {
        setState(() {
          _gyroscopeValues = <double>[event.x, event.y, event.z];
        });
      }),
    );
    _streamSubscriptions.add(
      userAccelerometerEvents.listen((UserAccelerometerEvent event) {
        setState(() {
          _userAccelerometerValues = <double>[event.x, event.y, event.z];
        });
      }),
    );
    _streamSubscriptions.add(
      magnetometerEvents.listen((MagnetometerEvent event) {
        setState(() {
          _magnetometerValues = <double>[event.x, event.y, event.z];
        });
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title!)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.black38),
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    height: _snakeRows * _snakeCellSize,
                    width: _snakeColumns * _snakeCellSize,
                    child: _snake,
                  ),
                ),
              ),
            ),
          ),
          // SensorDisplay(label: "Accelerometer", value: accelerometer),
          // SensorDisplay(label: "UserAccelerometer", value: userAccelerometer),
          // SensorDisplay(label: "Gyroscope", value: gyroscope),
          // SensorDisplay(label: "Magnetometer", value: magnetometer),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  _snake.state.changeinteraction("water");
                },
                child: Text("Water"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  _snake.state.changeinteraction("solid");
                },

                child: Text("Dirt"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  _snake.state.changeinteraction("air");
                },
                child: Text("Air"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
