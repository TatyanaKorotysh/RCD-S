import 'package:hive/hive.dart';
import 'package:rcd_s/models/settings_8767.dart';

class Settings8767Storage {
  final _store = Hive.box<Settings8767>("settings");

  Future<void> updateSettings(Settings8767 settings8767) {
    return _store.put(0, settings8767);
  }

  Future<void> updateMac(String mac) {
    Settings8767 settings8767 = getSettings();
    settings8767.mac = mac;

    return _store.put(0, settings8767);
  }

  Future<int> clear() {
    return _store.clear();
  }

  Settings8767 getSettings() {
    if (_store.containsKey(0))
      return _store.get(0);
    else
      return Settings8767(null, null, null, null, null, null, null, null, null,
          null, null, null, null, null, null, null);
  }
}
