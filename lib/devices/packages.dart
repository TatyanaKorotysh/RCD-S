import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:rcd_s/devices/package_unwrapper.dart';

class HeaderTypePackage extends PackageDefault {
  int type;
  Uint8List seqId;

//  ByteData type
  HeaderTypePackage({List<int> values}) {
    if (values != null) {
      type = values[0];
      seqId = Uint8List.fromList([values[1], values[2]]);
    }
  }
}

class AnswerPackage extends HeaderTypePackage {
  List<int> cmd;
  List<int> payload;

  AnswerPackage({List<int> values}) : super(values: values) {
    if (values != null) {
      cmd = Uint8List.fromList([values[3], values[4]]);
      payload = values.sublist(5, values.length - 1);
    }
  }
}

class ModemAnswerStatusCode extends Equatable {
  static const ModemAnswerStatusCode MODEM_ANS_IDLE =
      const ModemAnswerStatusCode._(0);
  static const ModemAnswerStatusCode MODEM_ANS_STARTED =
      const ModemAnswerStatusCode._(1);
  static const ModemAnswerStatusCode MODEM_ANS_IN_PROGRESS =
      const ModemAnswerStatusCode._(2);
  static const ModemAnswerStatusCode MODEM_ANS_COMPLETED =
      const ModemAnswerStatusCode._(3);

  final value;

  static const values = [
    MODEM_ANS_IDLE,
    MODEM_ANS_STARTED,
    MODEM_ANS_IN_PROGRESS,
    MODEM_ANS_COMPLETED
  ];

  const ModemAnswerStatusCode._(this.value);

  @override
  List<Object> get props => [value];
}
