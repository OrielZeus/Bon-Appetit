import 'package:bon_appetit/src/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows Bon Appetit dashboard modules', (tester) async {
    await tester.pumpWidget(const BonAppetitApp());

    expect(find.text('Bon Appetit'), findsWidgets);
    expect(find.text('Sign in'), findsOneWidget);

    await tester.tap(find.text('Enter workspace'));
    await tester.pumpAndSettle();

    expect(find.text('Explore menu'), findsOneWidget);
    expect(find.text('Track order'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });
}
