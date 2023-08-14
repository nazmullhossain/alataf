import 'package:rxdart/rxdart.dart';

class ProductDetailsBloc {
  BehaviorSubject _counter = new BehaviorSubject<int>.seeded(1);

  Stream get streamCounter$ => _counter.stream;

  increment() {
    _counter.add(_counter.value + 1);
  }

  decrement() {
    if (_counter.value > 1) _counter.add(_counter.value - 1);
  }

  startLoading() {
    _counter.add(true);
  }

  stopLoading() {
    _counter.add(false);
  }

  int getCount(){
    return _counter.value;
  }

  dispose() {
    _counter.value = 1;
    _counter.close();
    print("Dispose called from bloc");
  }
}
