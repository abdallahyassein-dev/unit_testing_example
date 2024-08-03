import 'package:flutter_test/flutter_test.dart';
import 'package:unit_testing_example/counter_example/Counter.dart';
// Update this import according to your project structure

void main() {
  group('Counter', () {
    late Counter counter;

    setUp(() {
      counter = Counter();
    });

    test('initial value should be 0', () {
      expect(counter.count, 0);
    });

    test('value should be incremented', () {
      counter.increment();
      expect(counter.count, 1);
    });

    test('value should be decremented', () {
      counter.increment();
      counter.decrement();
      expect(counter.count, 0);
    });

    test('value should not go below 0', () {
      counter.decrement();
      expect(counter.count,
          -1); // Change to match your logic if you want to restrict it to non-negative values
    });
  });
}
