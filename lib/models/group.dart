import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
//import 'package:nero_mob_app/styles/images_paths.dart';

part 'group.g.dart';

@HiveType(typeId: 4)
class Group extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String imagePath;
  @HiveField(3)
  List<int> deviceIds;
  @HiveField(4)
  final String mac;

  Group(
      {this.id,
      this.name,
      //this.imagePath = Images.ic_select_group,
      this.deviceIds,
      this.mac});

  @override
  String toString() {
    return 'Group{name: $name, id: $id, hostMac = $mac}';
  }

  @override
  List<Object> get props => [id, mac];
}
