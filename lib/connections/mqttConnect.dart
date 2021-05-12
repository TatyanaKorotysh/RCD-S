import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'dart:async';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:rcd_s/models/mqtt_response.dart';

class MqttManager {
  StreamController<MqttResponse> _streamMessageController;
  Stream<MqttResponse> mqttMessageStream;

  //String _identifier = "#";
  //String _host = "m24.cloudmqtt.com";
  String _receiveTopic = "dev/98:f4:ab:14:99:14/raw";
  String _sendTopic = "app/98:f4:ab:14:99:14/raw";

  MqttManager() {
    _streamMessageController = StreamController.broadcast();
    mqttMessageStream = _streamMessageController.stream;

    mqttMessageStream.listen((event) {
      //print(event.payload);
    });
    connectToMqtt();
  }

  final client = MqttServerClient("m24.cloudmqtt.com", "Mqtt_MyClientUniqueId");

  connectToMqtt({Function onFailure}) async {
    await main();
    if (onFailure != null) onFailure();
  }

  Future<int> main() async {
    client.logging(on: false);
    client.keepAlivePeriod = 60;
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;
    client.pongCallback = pong;
    client.port = 16591;
    client.secure = false;
    //client.setProtocolV311();

    final connMess = MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueId')
        .keepAliveFor(20)
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    print('EXAMPLE::Mosquitto client connecting....');
    client.connectionMessage = connMess;

    try {
      await client.connect("ubyytjem", "FY2sZYarxLFj");
    } on NoConnectionException catch (e) {
      print('EXAMPLE::client exception - $e');
      client.disconnect();
    } on SocketException catch (e) {
      print('EXAMPLE::socket exception - $e');
      client.disconnect();
    }

    if (client.connectionStatus.state == MqttConnectionState.connected) {
      print('EXAMPLE::Mosquitto client connected');
    } else {
      print(
          'EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      //exit(-1);
    }

    return 0;
  }

  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
    //MqttEncoding mqttEncoding = MqttEncoding();

    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;

      //print(recMess.payload.message);
      final String pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      _streamMessageController.add(MqttResponse(pt, topic));
      //client.disconnect();
      print(
          "EXAMPLE: Change notification: topic is <${c[0].topic}>, payload is <-- $pt -->");
      print("");
    });
  }

  void pong() {
    print('EXAMPLE::Ping response client callback invoked');
  }

  void publish(List<int> message) async {
    print('EXAMPLE::PUBLISHING');
    if (client.connectionStatus.state == MqttConnectionState.connecting ||
        client.connectionStatus.state == MqttConnectionState.disconnecting) {
      await Future.delayed(const Duration(seconds: 2), () {});
    }
    if (client.connectionStatus.state == MqttConnectionState.disconnected) {
      await connectToMqtt();
    }
    print('EXAMPLE::PUBLISH');

    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    var listForMqtt = "";
    message.forEach((item) {
      listForMqtt += String.fromCharCode(item);
    });
    builder.addString(listForMqtt);
    client.publishMessage(_sendTopic, MqttQos.exactlyOnce, builder.payload);
  }

  /*sendCommand(List<int> message) async {
    print('EXAMPLE::SENDING COMMAND');
    if (client.connectionStatus.state == MqttConnectionState.connecting ||
        client.connectionStatus.state == MqttConnectionState.disconnecting) {
      await Future.delayed(const Duration(seconds: 2), () {});
    }
    if (client.connectionStatus.state == MqttConnectionState.disconnected) {
      await connectToMqtt();
    }

    /*final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    var listForMqtt = "";
    message.forEach((item) {
      listForMqtt += String.fromCharCode(item);
    });
    builder.addString(listForMqtt);
    client.publishMessage(_receiveTopic, MqttQos.exactlyOnce, builder.payload);*/

    // print(message);
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    var buffer = Uint8List.fromList(message);
    print(buffer);
    //builder.addBuffer(buffer.toList());
    //print(builder.payload);
    client.publishMessage(_receiveTopic, MqttQos.exactlyOnce, builder.payload);

    print('EXAMPLE::SEND COMMAND');
  }*/

  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus.disconnectionOrigin ==
        MqttDisconnectionOrigin.solicited) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
    //exit(-1);
  }

  void onConnected() {
    client.subscribe(_receiveTopic, MqttQos.atLeastOnce);
  }

  Stream<MqttResponse> get getMqttMessageStream => mqttMessageStream;
}
