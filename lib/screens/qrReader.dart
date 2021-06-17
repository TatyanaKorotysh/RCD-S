import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_mobile_vision/qr_camera.dart';
import 'package:rcd_s/connections/mqttConnect.dart';
import 'package:rcd_s/screens/authorization.dart';
import 'package:rcd_s/services/json.dart';
import 'package:rcd_s/services/translate.dart';
import 'package:qr_mobile_vision/qr_mobile_vision.dart';
import 'package:toast/toast.dart';

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
          Text(
            AppLocalizations.of(context).translate('qr'),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
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
                          var sub = code.substring(0, 5);
                          if (sub == "rcd_s") {
                            var mes = code.substring(5);
                            JsonService.writeQr(mes);
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Authorization()),
                            );
                          } else {
                            Toast.show(
                              AppLocalizations.of(context).translate('qrError'),
                              context,
                              duration: Toast.LENGTH_LONG,
                              gravity: Toast.TOP,
                              backgroundColor: Color(0xFFBF360C),
                            );
                          }
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
                    child: Text(AppLocalizations.of(context)
                        .translate('cameraNotAccess')),
                  ),
          ),
        ],
      ),
    );
  }

  void getCamera() {
    setState(() {
      camState = !camState;
    });
  }
}
