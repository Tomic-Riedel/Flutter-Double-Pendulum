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

  // Time interval for calculation. Can be used to calculate next point but also
  // to calculate how much time has already passed by looking at the length
  //of previousIterations. We will only use it to calculate the next point
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

  //TODO: Implement Calculation

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

  //TODO: Implement Point Calculation
}
