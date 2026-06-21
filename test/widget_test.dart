import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_spring_boot/main.dart';

void main() {
  testWidgets('Muestra pantalla de login', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Iniciar sesión'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}
