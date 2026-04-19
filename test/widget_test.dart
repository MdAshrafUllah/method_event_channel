// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:method_event_channel/main.dart';

void main() {
  group("Full app Widget test", () {
    testWidgets("App loads Successfully", (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      expect(find.byType(AppBar), findsOneWidget);

      expect(find.text("Method & Event Channel Demo"), findsOneWidget);
    });

    testWidgets("Button are clickable", (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());

      final startTime = find.text('Start Timer');
      final endTime = find.text('Stop Timer');

      expect(startTime, findsOneWidget);
      expect(endTime, findsOneWidget);

      await tester.tap(startTime);
      await tester.pump();

      expect(find.byType(MyApp), findsOneWidget);
    });
  });

  group("App unit Testing", () {
    test("Counter increases", () {
      var count = 0;
      count++;
      expect(count, 1);
    });

    test("Initial values are correct", () {
      final timer = TimerLogic();

      expect(timer.count, 0);
      expect(timer.isRunning, false);
    });

    test("Start method sets isRunning to true and counter to 0", () {
      final timer = TimerLogic();

      timer.start();

      expect(timer.isRunning, true);
      expect(timer.count, 0);
    });

    test("Timer counter check", () {
      final timer = TimerLogic();

      timer.start();

      timer.tick();
      timer.tick();
      timer.tick();

      timer.stop();

      expect(timer.count, 3);
    });

    test("Timer Reset", () {
      final timer = TimerLogic();

      timer.reset();

      expect(timer.count, 0);
      expect(timer.isRunning, false);
    });
  });
}

class TimerLogic {
  int count = 0;
  bool isRunning = false;

  void start() {
    isRunning = true;
    count = 0;
  }

  void stop() {
    isRunning = false;
  }

  void tick() {
    if (isRunning) {
      count++;
    }
  }

  void reset() {
    isRunning = false;
    count = 0;
  }
}
