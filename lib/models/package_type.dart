class PackageStructureType {
  int espTypeVerMask;
  int reserved;
  int espTypeErrFlag;
  int espTypePartFlag;
  int espTypeWrFlag;
  int pkgTypeAskFlag;

  PackageStructureType.parse(int byte) {
    var parsedByte = byte.toRadixString(2).padLeft(8, "0");
    pkgTypeAskFlag = int.parse(parsedByte.substring(0, 1), radix: 2);
    espTypeWrFlag = int.parse(parsedByte.substring(1, 2), radix: 2);
    espTypePartFlag = int.parse(parsedByte.substring(2, 3), radix: 2);
    espTypeErrFlag = int.parse(parsedByte.substring(3, 4), radix: 2);
    reserved = int.parse(parsedByte.substring(4, 6), radix: 2);
    espTypeVerMask = int.parse(parsedByte.substring(6, 8), radix: 2);
  }
}

extension IsReadPackage on PackageStructureType {
  bool isReadPackage() {
    return this.espTypeWrFlag == 0;
  }

  bool isWritePackage() {
    return this.espTypeWrFlag == 1;
  }

  bool isPartOfPackage() {
    return this.espTypePartFlag == 1;
  }

  bool isErrorPackage() {
    return this.espTypeErrFlag == 1;
  }
}
