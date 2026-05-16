import 'package:bon_appetit/src/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows Bon Appetit dashboard modules', (tester) async {
    await tester.pumpWidget(const BonAppetitApp());

    expect(find.text('Bon Appetit'), findsWidgets);
    expect(find.text('Iniciar sesión'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.login_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Menú'), findsWidgets);
    expect(find.text('Ruta'), findsWidgets);
    expect(find.text('Inicio'), findsOneWidget);
  });
}
