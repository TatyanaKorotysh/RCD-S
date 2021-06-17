const PKG_PREFIX = 0x7e; // ~
const BYTE_STUFF = 0x7d; // }
const BYTE_STUFF2 = 0x5e; // ^
const BYTE_STUFF3 = 0x5d; // ]
const PKG_ACK_FLAG = 0x80;

extension StaffBytes on List<int> {
  List<int> staffBytes() {
    var list = <int>[];

    for (var i = 0; i < this.length; i++) {
      var c = this[i];

      if (c == PKG_PREFIX) {
        list.add(BYTE_STUFF);
        list.add(BYTE_STUFF2);
      } else if (c == BYTE_STUFF) {
        list.add(BYTE_STUFF);
        list.add(BYTE_STUFF3);
      } else
        list.add(c);
    }

    return list;
  }

  List<int> unstaffBytes() {
    var list = <int>[];

    for (var i = 0; i < this.length - 1; i++) {
      var byteValue = this[i];
      var nextByteValue = this[i + 1];

      if (byteValue == BYTE_STUFF && nextByteValue == BYTE_STUFF2) {
        list.add(PKG_PREFIX);
        i++;
      } else if (byteValue == BYTE_STUFF && nextByteValue == BYTE_STUFF3) {
        list.add(BYTE_STUFF);
        i++;
      } else {
        list.add(byteValue);

        if (i + 1 == length - 1) list.add(nextByteValue);
      }
    }

    return list;
  }

  int calcCrc() {
    int crc = 0xff;

    for (var element in this) {
      crc = crc ^ element;

      for (var j = 0; j < 8; j++) {
        var t = crc;
        t = t << 1;
        t = t & 0xff;

        if (crc & 0x80 != 0) {
          crc = t ^ 0x31;
        } else {
          crc = t;
        }
      }
    }

    return crc;
  }
}

extension CollectionExtensions<T> on List<T> {
  List<T> dropLast(int n) {
    return take((length - n).coerceAtLeast(0));
  }

  List<T> take(int n) {
    assert(n >= 0, "Requested element count $n is less than zero.");
    if (n == 0) return [];

    if (n >= length) return this;
    if (n == 1) return [this.first];

    var count = 0;
    var list = <T>[];
    for (var item in this) {
      list.add(item);
      if (++count == n) break;
    }

    return list;
  }
}

extension IntExtensions on int {
  int coerceAtLeast(int minimumValue) {
    if (this < minimumValue)
      return minimumValue;
    else
      return this;
  }
}
