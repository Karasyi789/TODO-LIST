import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_app/main.dart'; // Pastikan path-nya benar

void main() {
  testWidgets('ToDoApp test', (WidgetTester tester) async {
    // Memastikan aplikasi dimulai dengan benar
    await tester.pumpWidget(
      TodoListApp(),
    ); // Sesuaikan nama kelas yang ada di main.dart
  });
}
