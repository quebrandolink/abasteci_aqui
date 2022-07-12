import 'objectbox.g.dart';

class ObjectBoxDatabase {
  Store? _store;

  Future<Store> getStore() async {
    return _store ??= await openStore();
  }

  void closeStore() {
    if (!_store!.isClosed()) {
      _store!.close();
    }
  }
}
