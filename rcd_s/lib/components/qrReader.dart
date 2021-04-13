import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:rcd_s/connections/mqttConnect.dart';
import 'package:rcd_s/screens/devices.dart';
import 'package:toast/toast.dart';
import 'package:qr_mobile_vision/qr_mobile_vision.dart';

class QrReader extends StatefulWidget {
  @override
  _QrReaderState createState() => _QrReaderState();
}

class _QrReaderState extends State<QrReader> {
  @override
  initState() {
    super.initState();
    getCamera();
  }

  bool camState = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 40.0)),
          Text('Сканируйте QR-код на крышке сервера для подключения к облаку'),
          Padding(padding: EdgeInsets.only(top: 20.0)),
          Expanded(
            child: camState
                ? Center(
                    child: SizedBox(
                      child: QrCamera(
                        formats: [BarcodeFormats.QR_CODE],
                        onError: (context, error) => Text(
                          error.toString(),
                          style: TextStyle(color: Colors.red),
                        ),
                        qrCodeCallback: (code) {
                          connectToMqtt(code, context, onFailure: () {
                            Toast.show("Подключение...", context,
                                duration: Toast.LENGTH_LONG);
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Devices()),
                            );
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child:
                        Text("Доспуп к камере для этого приложения запрещен"),
                  ),
          ),
        ],
      ),
    );
  }

  Widget getCamera() {
    setState(() {
      camState = !camState;
    });
  }
}