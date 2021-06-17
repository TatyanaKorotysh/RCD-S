import 'dart:async';

import 'package:hive/hive.dart';
import 'package:rcd_s/models/group.dart';
import 'package:rcd_s/storage/settings_storage.dart';

class GroupLocalStorage {
  //var _groupStream = GroupItemsStream();
  StreamController<List> _groupStreamController;
  Stream<List> groupListStream;
  StreamController<List> _groupDeviceStreamController;
  Stream<List> groupDeviceListStream;

  final _store = Hive.box<Group>("groups");
  Settings8767Storage _settings8767storage;

  List<Group> _tempList = List();

  // Stream<List<Group>> get groupItemsStream => _groupStream.groupItemsStream;

  GroupLocalStorage(this._settings8767storage) {
    _groupStreamController = StreamController.broadcast();
    _groupDeviceStreamController = StreamController.broadcast();
    groupListStream = _groupStreamController.stream;
    groupDeviceListStream = _groupDeviceStreamController.stream;
  }

  storeGroup(Group group) {
    if (!getGroupListForCurrent8767().contains(group)) {
      _store.add(group).then((t) {
        // _groupStream.add(getGroupListForCurrent8767());
      });
    }

    //_groupStream.add(getGroupListForCurrent8767());
    _groupStreamController.add(getGroupListForCurrent8767());
  }

  removeGroupWithStream(Group group) {
    if (getAllGroupList().contains(group)) {
      _store.deleteAt(getAllGroupList().indexOf(group)).then((t) {
        // _groupStream.add(getGroupListForCurrent8767());
      });
    }
  }

  List<Group> getGroupListForCurrent8767() {
    return _store.values
        .toList()
        .where(
            (element) => element.mac == _settings8767storage.getSettings().mac)
        .toList();
  }

  List<Group> getAllGroupList() {
    _groupStreamController.add(_store.values.toList());
    return _store.values.toList();
  }

  int getFreeGroupId() {
    var freeId = -1;
    var groups = getGroupListForCurrent8767();

    for (int idForCheck = 1; idForCheck < 240; idForCheck++) {
      if (_isFreeGroupId(groups, idForCheck)) {
        freeId = idForCheck;
        break;
      }
    }

    return freeId;
  }

  bool _isFreeGroupId(List<Group> groups, idForCheck) {
    var isFree = true;

    groups.forEach((element) {
      if (element.id == idForCheck) {
        isFree = false;
      }
    });

    return isFree;
  }

  List<int> getDevicesIds(Group group) {
    _groupDeviceStreamController.add(group.deviceIds);
    return group.deviceIds;
  }

  Group getGroupById(int id) {
    return getGroupListForCurrent8767().firstWhere((group) {
      return group.id == id;
    }, orElse: () => null);
  }

  storeToTemp(List<Group> groups) {
    _tempList.addAll(groups);
  }

  storeAllGroups() {
    var groups = _tempList;

    List<Group> oldGroupList = getGroupListForCurrent8767();

    if (groups.isEmpty) {
      oldGroupList.forEach((group) {
        if (!groups.contains(group)) {
          removeGroupWithStream(group);
        }
      });

      // _groupStream.add(List());
      return;
    }

    oldGroupList.forEach((group) {
      if (!groups.contains(group)) {
        removeGroupWithStream(group);
      }
    });
    groups.forEach((group) {
      storeGroup(group);
    });

    _tempList.clear();
  }

  Future<void> updateGroup(Group group) {
    _groupDeviceStreamController.add(group.deviceIds);
    return _store.putAt(getAllGroupList().indexOf(group), group);
  }
}
