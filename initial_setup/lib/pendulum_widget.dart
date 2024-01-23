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
    //TODO: Calculate Points in Time
    throw UnimplementedError();
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
                      //TODO: Implement Calculation Start
                    },
                    child: Text(
                      _timer?.isActive ?? false ? 'Stop' : 'Start',
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      //TODO: Implement Animation Reset
                    },
                    child: const Text('Reset Animation'),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomPaint(
                  painter: CoordinatePainter(
                    // TODO: Pass Points
                    points: [],
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

    //TODO: Implement point painting
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate is! CoordinatePainter || oldDelegate.points != points;
  }
}
