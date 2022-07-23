import 'package:dartz/dartz.dart';

import 'package:inglorious_bastards/application/room/room_socket.dart';

class RoomService {
  final RoomSocket _socket;

  RoomService(this._socket);

  factory RoomService.createRoom(String username, Function(Either<String, Map<String, dynamic>>) callback) {
    final service = RoomService(RoomSocket());

    service.setListener((json) {
      if (json['type'] == 'roomData') {
        callback(Right(json['data']));
      } else if (json['type'] == 'error') {
        callback(Left(json['data']['error']));
      }
    });

    service.sendMessage({
      'action': 'createRoom',
      'data': {
        'username': username
      }
    });

    return service;
  }

  factory RoomService.joinRoom(String username, int roomKey, Function(Either<String, Map<String, dynamic>>) callback) {
    final service = RoomService(RoomSocket());

    service.setListener((json) {
      if (json['type'] == 'roomData') {
        callback(Right(json['data']));
      } else if (json['type'] == 'error') {
        callback(Left(json['data']['error']));
      }
    });

    service.sendMessage({
      'action': 'joinRoom',
      'data': {
        'username': username,
        'roomKey': roomKey
      }
    });

    return service;
  }

  void setListener(Function(dynamic) callback) {
    _socket.setListener(callback);
  }

  void sendMessage(Map<String, Object> message) {
    _socket.sendMessage(message);
  }

  void closeSocket() {
    _socket.channel.sink.close();
  }
}