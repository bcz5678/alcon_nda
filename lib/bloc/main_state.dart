part of 'main_bloc.dart';

enum MainStateStatus {
  initial,
  loading,
  isInProgress,
  done,
  error,
}

class MainState extends Equatable{
  MainState({
    required this.stateStatus,
  });

  MainState.initial()
    : this(
      stateStatus: MainStateStatus.initial,
  );

  final MainStateStatus? stateStatus;


  MainState copyWith({
    MainStateStatus? stateStatus,
  }) {
    return MainState(
      stateStatus: stateStatus ?? this.stateStatus,
    );
  }

  @override
  List<Object?> get props => [
    stateStatus,
  ];
}

