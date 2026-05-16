import 'package:bon_appetit/src/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows Bon Appetit dashboard modules', (tester) async {
    await tester.pumpWidget(const BonAppetitApp());

    expect(find.text('Bon Appetit'), findsOneWidget);
    expect(find.text('Restaurants'), findsOneWidget);
    expect(find.text('Orders'), findsOneWidget);
    expect(find.text('Delivery tracker'), findsOneWidget);
  });
}
