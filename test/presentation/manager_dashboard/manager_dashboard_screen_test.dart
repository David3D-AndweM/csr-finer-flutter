import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:csr_finer_flutter/presentation/screens/manager_dashboard/manager_dashboard_screen.dart';

void main() {
  group('ManagerDashboardScreen Tests', () {
    testWidgets('should render without crashing', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        const MaterialApp(
          home: ManagerDashboardScreen(),
        ),
      );

      // Verify that the screen renders without throwing an exception
      expect(find.byType(ManagerDashboardScreen), findsOneWidget);
    });

    testWidgets('should display AppBar with title', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ManagerDashboardScreen(),
        ),
      );

      // Verify that the AppBar is present
      expect(find.byType(AppBar), findsOneWidget);
      
      // Verify that the title is displayed
      expect(find.text('CSR Manager Dashboard'), findsOneWidget);
    });

    testWidgets('should have scrollable body', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ManagerDashboardScreen(),
        ),
      );

      // Verify that SingleChildScrollView is present
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('should display welcome message', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: ManagerDashboardScreen(),
        ),
      );

      // Verify that welcome message is displayed
      expect(find.textContaining('Welcome'), findsOneWidget);
    });
  });
}
