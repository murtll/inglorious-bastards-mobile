import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:inglorious_bastards/application/room/room_service.dart';
import 'package:inglorious_bastards/models/player.dart';

part 'home_state.dart';
part 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late RoomService roomService;

  HomeBloc() : super(HomeState.initial()) {
    on<HomeEvent>((event, emit) async {
      switch (event.runtimeType) {
        case _UpdateNickName:
          await _updateNickName(event as _UpdateNickName, emit);
          break;
        case _CreateRoom:
          await _createRoom(event as _CreateRoom, emit);
          break;
        case _UpdateRoomKey:
          await _updateRoomKey(event as _UpdateRoomKey, emit);
          break;
        case _UpdateRoomPlayers:
          await _updateRoomPlayers(event as _UpdateRoomPlayers, emit);
          break;
        case _UpdateConnectionResult:
          await _updateConnectionResult(event as _UpdateConnectionResult, emit);
          break;
        case _JoinRoom:
          await _joinRoom(event as _JoinRoom, emit);
          break;
        case _UpdateError:
          await _updateError(event as _UpdateError, emit);
          break;
      }
    });
  }

  Future _updateNickName(_UpdateNickName event, Emitter<HomeState> emit) async {
    emit(state.copyWith(nickname: some(event.nickName)));
  }

  Future _createRoom(_CreateRoom event, Emitter<HomeState> emit) async {
    if (state.nickname == null) {
      emit(state.copyWith(connectionResult: ConnectionResult.emptyNickName));
      return;
    }

    roomService = RoomService.createRoom(state.nickname!,
        (Either<String, Map<String, dynamic>> result) {
      result.fold((l) {
        add(HomeEvent.updateError(l));
        add(const HomeEvent.updateConnectionResult(ConnectionResult.error));
      }, (r) {
        add(HomeEvent.updateRoomPlayers(r['players']
            .map((e) => Player.fromJson(e))
            .toList()
            .cast<Player>()));
        add(HomeEvent.updateRoomKey(r['roomKey']));
        add(const HomeEvent.updateConnectionResult(ConnectionResult.ok));
      });
    });
  }

  Future _updateConnectionResult(_UpdateConnectionResult event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      connectionResult: event.connectionResult,
    ));
  }

  Future _updateRoomPlayers(
      _UpdateRoomPlayers event, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      players: event.players,
    ));
  }

  Future _updateRoomKey(_UpdateRoomKey event, Emitter<HomeState> emit) async {
    emit(state.copyWith(roomKey: some(event.roomKey)));
  }

  Future _joinRoom(_JoinRoom event, Emitter<HomeState> emit) async {
    if (state.nickname == null) {
      emit(state.copyWith(connectionResult: ConnectionResult.emptyNickName));
      return;
    }
    if (state.roomKey == null) {
      emit(state.copyWith(connectionResult: ConnectionResult.emptyRoomKey));
      return;
    }

    roomService = RoomService.joinRoom(state.nickname!, state.roomKey!,
        (Either<String, Map<String, dynamic>> result) {
      result.fold((l) {
        add(HomeEvent.updateError(l));
        add(const HomeEvent.updateConnectionResult(ConnectionResult.error));
      }, (r) {
        add(HomeEvent.updateRoomPlayers(r['players']
            .map((e) => Player.fromJson(e))
            .toList()
            .cast<Player>()));
        add(const HomeEvent.updateConnectionResult(ConnectionResult.ok));
      });
    });
  }

  _updateError(_UpdateError event, Emitter<HomeState> emit) {
    emit(state.copyWith(error: some(event.error)));
  }
}
