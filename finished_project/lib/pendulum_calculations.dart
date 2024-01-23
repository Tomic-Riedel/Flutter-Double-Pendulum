import 'dart:math';

class DoublePendulum {
  // Gravitation constant. E.g. on earth around 9.81
  final double g;

  // Length of first and second pendulum in meters
  final double l1;
  final double l2;

  // Mass of first and second pendulum in kg
  final double m1;
  final double m2;

  final List<StateOfPendulum> previousStates;

  // Time interval for calculation. Can be used to Calculate next point but also
  // to calculate how much time has already passed by looking at the length
  //of previousIterations
  final double timeInterval;

  const DoublePendulum({
    required this.g,
    required this.l1,
    required this.l2,
    required this.m1,
    required this.m2,
    required this.previousStates,
    required this.timeInterval,
  });

  StateOfPendulum calculateNextStateOfPendulum(StateOfPendulum previousState) {
    // Helper function to calculate derivatives
    List<double> derivatives(
        double theta1, double theta2, double omega1, double omega2) {
      final denominator = (2 * m1 + m2 - m2 * cos(2 * theta1 - 2 * theta2));

      final theta1Dot = omega1;
      final theta2Dot = omega2;

      // Our first equation we looked at translated into Dart code
      final omega1Dot = (-g * (2 * m1 + m2) * sin(theta1) -
              m2 * g * sin(theta1 - 2 * theta2) -
              2 *
                  sin(theta1 - theta2) *
                  m2 *
                  (pow(omega2, 2) * l2 +
                      pow(omega1, 2) * l1 * cos(theta1 - theta2))) /
          (l1 * denominator);

      // Our second equation we looked at translated into Dart code
      final omega2Dot = (2 *
              sin(theta1 - theta2) *
              (pow(omega1, 2) * l1 * (m1 + m2) +
                  g * (m1 + m2) * cos(theta1) +
                  pow(omega2, 2) * l2 * m2 * cos(theta1 - theta2))) /
          (l2 * denominator);

      return [theta1Dot, theta2Dot, omega1Dot, omega2Dot];
    }

    // Runge-Kutta 4th order method
    final k1 = derivatives(previousState.theta1, previousState.theta2,
        previousState.omega1, previousState.omega2);
    final k2 = derivatives(
        previousState.theta1 + 0.5 * timeInterval * k1[0],
        previousState.theta2 + 0.5 * timeInterval * k1[1],
        previousState.omega1 + 0.5 * timeInterval * k1[2],
        previousState.omega2 + 0.5 * timeInterval * k1[3]);
    final k3 = derivatives(
        previousState.theta1 + 0.5 * timeInterval * k2[0],
        previousState.theta2 + 0.5 * timeInterval * k2[1],
        previousState.omega1 + 0.5 * timeInterval * k2[2],
        previousState.omega2 + 0.5 * timeInterval * k2[3]);
    final k4 = derivatives(
        previousState.theta1 + timeInterval * k3[0],
        previousState.theta2 + timeInterval * k3[1],
        previousState.omega1 + timeInterval * k3[2],
        previousState.omega2 + timeInterval * k3[3]);

    final nextTheta1 = previousState.theta1 +
        (timeInterval / 6.0) * (k1[0] + 2 * k2[0] + 2 * k3[0] + k4[0]);
    final nextTheta2 = previousState.theta2 +
        (timeInterval / 6.0) * (k1[1] + 2 * k2[1] + 2 * k3[1] + k4[1]);
    final nextOmega1 = previousState.omega1 +
        (timeInterval / 6.0) * (k1[2] + 2 * k2[2] + 2 * k3[2] + k4[2]);
    final nextOmega2 = previousState.omega2 +
        (timeInterval / 6.0) * (k1[3] + 2 * k2[3] + 2 * k3[3] + k4[3]);

    return StateOfPendulum(
      theta1: nextTheta1,
      theta2: nextTheta2,
      omega1: nextOmega1,
      omega2: nextOmega2,
    );
  }

  DoublePendulum copyWith({
    double? g,
    double? l1,
    double? l2,
    double? m1,
    double? m2,
    List<StateOfPendulum>? previousStates,
    double? timeInterval,
  }) {
    return DoublePendulum(
      g: g ?? this.g,
      l1: l1 ?? this.l1,
      l2: l2 ?? this.l2,
      m1: m1 ?? this.m1,
      m2: m2 ?? this.m2,
      previousStates: previousStates ?? this.previousStates,
      timeInterval: timeInterval ?? this.timeInterval,
    );
  }
}

class StateOfPendulum {
  // Angle of first and second pendulum from the x-axes in rad
  final double theta1;
  final double theta2;

  // Starting speed of the first and second pendulum in m/s
  final double omega1;
  final double omega2;

  const StateOfPendulum({
    required this.theta1,
    required this.theta2,
    required this.omega1,
    required this.omega2,
  });

  StateOfPendulum copyWith({
    double? theta1,
    double? theta2,
    double? omega1,
    double? omega2,
  }) {
    return StateOfPendulum(
      theta1: theta1 ?? this.theta1,
      theta2: theta2 ?? this.theta2,
      omega1: omega1 ?? this.omega1,
      omega2: omega2 ?? this.omega2,
    );
  }

  ({double x, double y}) calculatePointInRoomOfFirstPendulum(
      double l1, double l2) {
    final x = l1 * sin(theta1);
    final y = -l1 * cos(theta1);

    return (x: x, y: y);
  }

  ({double x, double y}) calculatePointInRoomOfSecondPendulum(
      double l1, double l2) {
    final x = l1 * sin(theta1) + l2 * sin(theta2);
    final y = -l1 * cos(theta1) - l2 * cos(theta2);

    return (x: x, y: y);
  }
}
