// Widget test for the Notes SQFlite CRUD app.
// Runs against the sqflite_common_ffi backend so the real database
// layer (open + read) is exercised without needing a device.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:notes_sqflite_app/main.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('App renders home page title and add button', (WidgetTester tester) async {
    await tester.pumpWidget(const NotesApp());

    // The home page shows an indeterminate CircularProgressIndicator while
    // loading, which schedules frames forever, so pumpAndSettle() never
    // settles. Pump a fixed number of frames instead.
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(find.text('My Notes (SQFlite CRUD)'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
