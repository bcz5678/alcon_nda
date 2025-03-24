import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainState.initial()) {
    on<MainEvent>(onMainEvent);
  }

  void onMainEvent(
    MainEvent event,
    Emitter<MainState> emit,
    ) async {

  }

}
