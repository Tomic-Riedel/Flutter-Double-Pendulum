import 'dart:async';

import 'package:double_pendulum/pendulum_calculations.dart';
import 'package:flutter/material.dart';

class PendulumWidget extends StatefulWidget {
  const PendulumWidget({super.key});

  @override
  State<PendulumWidget> createState() => _PendulumWidgetState();
}

class _PendulumWidgetState extends State<PendulumWidget>
    with SingleTickerProviderStateMixin {
  DoublePendulum pendulum = const DoublePendulum(
    g: 9.81,
    l1: 1.0,
    l2: 1.0,
    m1: 1,
    m2: 1,
    previousStates: [
      StateOfPendulum(theta1: 1.57, theta2: 1.57, omega1: 0, omega2: 0)
    ],
    timeInterval: 0.01,
  );

  Timer? _timer;

  void tick() {
    final newState =
        pendulum.calculateNextStateOfPendulum(pendulum.previousStates.last);
    List<StateOfPendulum> newStates = pendulum.previousStates.toList();
    newStates.add(newState);

    // to prevent calling setState when the widget is not in the widget tree
    if (mounted) {
      setState(() {
        pendulum = pendulum.copyWith(previousStates: newStates);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_timer?.isActive ?? false) {
                        _timer?.cancel();
                      } else {
                        _timer = Timer.periodic(
                          Duration(
                            milliseconds:
                                (pendulum.timeInterval * 1000).toInt(),
                          ),
                          (timer) {
                            tick();
                          },
                        );
                      }
                    },
                    child: Text(
                      _timer?.isActive ?? false ? 'Stop' : 'Start',
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      _timer?.cancel();
                      var currentStates = pendulum.previousStates.toList();
                      setState(() {
                        pendulum = pendulum.copyWith(
                          previousStates: [currentStates.first],
                        );
                      });
                    },
                    child: const Text('Reset Animation'),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomPaint(
                  painter: CoordinatePainter(
                    points: pendulum.previousStates.map((e) {
                      final firstPendulumCoordinates =
                          e.calculatePointInRoomOfFirstPendulum(
                              pendulum.l1, pendulum.l2);
                      final secondPendulumCoordinates =
                          e.calculatePointInRoomOfSecondPendulum(
                              pendulum.l1, pendulum.l2);
                      return (
                        Offset(firstPendulumCoordinates.x * 100,
                            firstPendulumCoordinates.y * 100),
                        Offset(secondPendulumCoordinates.x * 100,
                            secondPendulumCoordinates.y * 100)
                      );
                    }).toList(),
                  ),
                  child: const SizedBox(
                    width: 600,
                    height: 600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CoordinatePainter extends CustomPainter {
  List<(Offset, Offset)> points;

  CoordinatePainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    // Draw x and y axis
    canvas.drawLine(
        Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
    canvas.drawLine(
        Offset(size.width / 2, 0), Offset(size.width / 2, size.height), paint);

    final Offset coordinateOrigin = Offset(size.width / 2, size.height / 2);

    // Draw points
    paint.color = Colors.red;

    Path path = Path();
    paint.style = PaintingStyle.stroke;
    path.moveTo(coordinateOrigin.dx + points[0].$2.dx,
        coordinateOrigin.dy - points[0].$2.dy);

    // Draw smooth curve between points
    for (int i = 1; i < points.length - 1; i++) {
      final Offset controlPoint = Offset(
        (coordinateOrigin.dx +
                points[i].$2.dx +
                coordinateOrigin.dx +
                points[i + 1].$2.dx) /
            2,
        (coordinateOrigin.dy -
                points[i].$2.dy +
                coordinateOrigin.dy -
                points[i + 1].$2.dy) /
            2,
      );
      path.quadraticBezierTo(
        coordinateOrigin.dx + points[i].$2.dx,
        coordinateOrigin.dy - points[i].$2.dy,
        controlPoint.dx,
        controlPoint.dy,
      );
    }
    path.lineTo(
      coordinateOrigin.dx + points[points.length - 1].$2.dx,
      coordinateOrigin.dy - points[points.length - 1].$2.dy,
    );

    // Draw the path
    canvas.drawPath(path, paint);

    // Draw line from point (0|0) to end of first pendulum
    paint.color = Colors.green;
    paint.strokeWidth = 3.5;

    canvas.drawLine(
      coordinateOrigin,
      Offset(coordinateOrigin.dx + points.last.$1.dx,
          coordinateOrigin.dy - points.last.$1.dy),
      paint,
    );
    paint.color = Colors.lightGreen;
    canvas.drawLine(
      Offset(coordinateOrigin.dx + points.last.$1.dx,
          coordinateOrigin.dy - points.last.$1.dy),
      Offset(coordinateOrigin.dx + points.last.$2.dx,
          coordinateOrigin.dy - points.last.$2.dy),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate is! CoordinatePainter || oldDelegate.points != points;
  }
}
