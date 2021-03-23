abstract class QRScanningEvent {}

class QRScannedEvent extends QRScanningEvent {
  final String code;

  QRScannedEvent(this.code);
}
