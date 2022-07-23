import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class RoomSocket {
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://${dotenv.env['API_HOST']}:${dotenv.env['API_PORT']}/ws'),
  );
  late StreamSubscription _listener;

  RoomSocket({ Function(Map<String, dynamic>)? eventListener }) {
    _listener = channel.stream.listen((message) {
      if (eventListener != null) eventListener(json.decode(message));
    });
  }

  void setListener(Function(Map<String, dynamic>) callback) {
    _listener.onData((message) {
      print(message);
      callback(json.decode(message));
    });
  }

  void sendMessage(Map<String, dynamic> message) {
    channel.sink.add(json.encode(message));
  }
}