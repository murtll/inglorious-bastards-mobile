import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:inglorious_bastards/application/room/room_service.dart';
import 'package:inglorious_bastards/models/player.dart';

part 'room_state.dart';
part 'room_event.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  late RoomService roomService;

  RoomBloc(List<Player> players, int? roomKey) : super(
    RoomState.initial(players, roomKey)
  ) {
    on<RoomEvent>((event, emit) async {
      switch (event.runtimeType) {
        case _UpdateRoomKey:
          await _updateRoomKey(event as _UpdateRoomKey, emit);
          break;
        case _UpdateRoomPlayers:
          await _updateRoomPlayers(event as _UpdateRoomPlayers, emit);
          break;
      }
    });
  }
  Future _updateRoomPlayers(_UpdateRoomPlayers event, Emitter<RoomState> emit) async {
    print(event.players);
    emit(state.copyWith(
        players: event.players,
    ));
  }

  Future _updateRoomKey(_UpdateRoomKey event, Emitter<RoomState> emit) async {
    emit(state.copyWith(
        roomKey: some(event.roomKey)
    ));
  }
}