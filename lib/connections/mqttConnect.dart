import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'dart:async';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:rcd_s/models/mqtt_response.dart';

class MqttManager {
  StreamController<MqttResponse> _streamMessageController;
  Stream<MqttResponse> mqttMessageStream;

  static String _host;
  static String _identifier;
  static String _login;
  static String _password;
  static String _receiveTopic;
  static String _sendTopic;

  MqttManager() {
    _streamMessageController = StreamController.broadcast();
    mqttMessageStream = _streamMessageController.stream;
  }

  static initMqttConnect(Map map) {
    /*_host = "m24.cloudmqtt.com";
    _identifier = "Mqtt_MyClientUniqueId";
    _login = "ubyytjem";
    _password = "FY2sZYarxLFj";
    _receiveTopic = "dev/98:f4:ab:14:99:14/raw";
    _sendTopic = "app/98:f4:ab:14:99:14/raw";*/
    _host = map["host"];
    _identifier = map["identifier"];
    _login = map["login"];
    _password = map["password"];
    _receiveTopic = map["receiveTopic"];
    _sendTopic = map["sendTopic"];
  }

  MqttServerClient client = MqttServerClient(_host, _identifier);

  Future<void> main() async {
    client = MqttServerClient(_host, _identifier);

    if (client.connectionStatus.state != MqttConnectionState.connecting &&
        client.connectionStatus.state != MqttConnectionState.connected) {
      print("_______________________________________________________________");
      print(client.connectionStatus.state);
      print(_host);
      print(client);

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
          .withClientIdentifier(_identifier)
          .keepAliveFor(20)
          .withWillTopic('willtopic')
          .withWillMessage('My Will message')
          .startClean()
          .withWillQos(MqttQos.atLeastOnce);
      print('EXAMPLE::Mosquitto client connecting....');
      client.connectionMessage = connMess;

      try {
        await client.connect(_login, _password);
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

    /*if (client.connectionStatus.state == MqttConnectionState.connecting ||
        client.connectionStatus.state == MqttConnectionState.disconnecting) {
      await Future.delayed(const Duration(seconds: 2), () {});
    }
    if (client.connectionStatus.state == MqttConnectionState.disconnected) {
      await main();
    }*/
    //Timer(Duration(seconds: 1), () {
    // if (client.connectionStatus.state == MqttConnectionState.connecting) {
    //   Duration(seconds: 1);
    // }
    if (client.connectionStatus.state != MqttConnectionState.connected) {
      client.disconnect();
      await main();
    }
    //});
    print(client.connectionStatus.state);
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
