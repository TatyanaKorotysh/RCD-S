import 'dart:async';

import 'package:hive/hive.dart';
import 'package:rcd_s/devices/command_manager.dart';
import 'package:rcd_s/models/device.dart';
import 'package:rcd_s/storage/settings_storage.dart';

class DeviceLocalStorage {
  //var _deviceStream = DeviceItemsStream();
  StreamController<List> _deviceStreamController;
  Stream<List> deviceListStream;

  final _store = Hive.box<Device>("devices");

  Settings8767Storage _settings8767storage;
  DeviceLocalStorage(this._settings8767storage) {
    _deviceStreamController = StreamController.broadcast();
    deviceListStream = _deviceStreamController.stream;
  }
  List<Device> _tempList = List();

  List<Device> getAllDeviceList() {
    _deviceStreamController.add(_store.values.toList());
    return _store.values.toList();
  }

  storeToTemp(List<Device> devices) {
    _tempList.addAll(devices);
  }

  storeAllDevices() {
    //_store.deleteFromDisk();
    List<Device> devices = _tempList;
    List<Device> oldDevicesList = getDeviceListForCurrent8767();

    if (devices.isEmpty) {
      oldDevicesList.forEach((device) {
        if (!devices.contains(device)) {
          removeDeviceWithStream(device);
        }
      });

      //.add(List());
      return;
    }

    /*oldDevicesList.forEach((oldDevice) {
      if (!devices.contains(oldDevice)) {
        removeDeviceWithStream(oldDevice);
      }
    });
    devices.forEach((device) {
      storeDevice(device);
    });*/

    devices.forEach((newDevice) {
      if (!oldDevicesList.contains(newDevice)) storeDevice(newDevice);
    });

    //_deviceStreamController.add(_store.values.toList());
    _tempList.clear();
  }

  storeDevice(Device device) {
    //if (!getDeviceListForCurrent8767().contains(device)) {
    _store.add(device).then((t) {
      _deviceStreamController.add(getDeviceListForCurrent8767());
      // _deviceStream.add(getDeviceListForCurrent8767());
    });
  }
  //_deviceStream.add(getDeviceListForCurrent8767());

  removeDeviceWithStream(Device device) {
    _store.deleteAt(getAllDeviceList().indexOf(device)).then((t) {
      return _store;
    });
  }

  Device getDeviceById(int id, {bool withoutNull = false}) {
    return getDeviceListForCurrent8767().firstWhere((device) {
      return (device.id == id &&
          device.mac == _settings8767storage.getSettings().mac);
    }, orElse: () {
      if (withoutNull) {
        return Device(
            "Radio 8113",
            [0, 0, 0, 0],
            id,
            RadioDevices.RADIO3_DEVICE_8113_NB.value,
            "Неизвестное устройство",
            _settings8767storage.getSettings().mac);
      } else {
        return null;
      }
    });
  }

  List<Device> getDeviceListForCurrent8767() {
    return _store.values
        .toList()
        .where(
            (element) => element.mac == _settings8767storage.getSettings().mac)
        .toList();
  }

  Future<void> updateDevice(Device device) {
    return _store.putAt(_store.values.toList().indexOf(device), device);
  }

  removeDevice(Device device) {
    _store.deleteAt(getAllDeviceList().indexOf(device));
  }
}


  /* 
  

  Stream<List<Device>> get deviceItemsStream => _deviceStream.deviceItemsStream;

  storeDevice(Device device) {
    if (!getDeviceListForCurrent8767().contains(device)) {
      _store.add(device).then((t) {
        _deviceStream.add(getDeviceListForCurrent8767());
      });
    }
    _deviceStream.add(getDeviceListForCurrent8767());
  }

  removeDeviceWithStream(Device device) {
    _store.deleteAt(getAllDeviceList().indexOf(device)).then((t) {
      _deviceStream.add(getDeviceListForCurrent8767());
    });
  }

  removeDevice(Device device) {
    _store.deleteAt(getAllDeviceList().indexOf(device));
  }

  List<Device> getDeviceListForCurrent8767() {
    return _store.values
        .toList()
        .where(
            (element) => element.mac == _settings8767storage.getSettings().mac)
        .toList();
  }

  List<Device> getAllDeviceList() {
    return _store.values.toList();
  }

  Device getDeviceById(String id, {bool withoutNull = false}) {
    /*return getDeviceListForCurrent8767().firstWhere((device) {
      return (device.id == id &&
          device.mac == _settings8767storage.getSettings().mac);
    }, orElse: () {
      if (withoutNull) {
        return Device(
            "Radio 8113",
            [0, 0, 0, 0],
            id,
            RadioDevices.RADIO3_DEVICE_8113_NB.value,
            "Неизвестное устройство",
            _settings8767storage.getSettings().mac);
      } else {
        return null;
      }
    });*/
  }

  List<Device> getDevisesByListOfDeviceId(List<String> listOfDeviceId) {
    List<Device> devices = List();
    listOfDeviceId.forEach((deviceId) {
      if (getDeviceById(deviceId) != null) {
        devices.add(getDeviceById(deviceId));
      }
    });

    return devices;
  }

  storeToTemp(List<Device> devices) {
    _tempList.addAll(devices);
  }

  storeAllDevices() {
    List<Device> devices = _tempList;

    List<Device> oldDevicesList = getDeviceListForCurrent8767();

    if (devices.isEmpty) {
      oldDevicesList.forEach((device) {
        if (!devices.contains(device)) {
          removeDeviceWithStream(device);
        }
      });

      _deviceStream.add(List());
      return;
    }

    oldDevicesList.forEach((device) {
      if (!devices.contains(device)) {
        removeDeviceWithStream(device);
      }
    });
    devices.forEach((device) {
      storeDevice(device);
    });

    _tempList.clear();
  }

  Future<void> updateDevice(Device device) {
    return _store.putAt(_store.values.toList().indexOf(device), device);
  }*/

