part of 'space_bloc.dart';

enum SpaceStateStatus {
  initial,
  success,
  error,
}

class SpaceState {
  final SpaceStateStatus status;
  final List<Space> spaces;
  final bool isLoading;
  final String? successMessage;
  final String? errorMessage;

  const SpaceState({
    this.status = SpaceStateStatus.initial,
    this.spaces = const [],
    this.isLoading = false,
    this.successMessage,
    this.errorMessage,
  });

  SpaceState copyWith({
    SpaceStateStatus? status,
    List<Space>? spaces,
    bool? isLoading,
    String? successMessage,
    String? errorMessage,
  }) {
    return SpaceState(
      status: status ?? this.status,
      spaces: spaces ?? this.spaces,
      isLoading: isLoading ?? this.isLoading,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
