part of 'space_bloc.dart';

sealed class SpaceEvent extends Equatable {
  const SpaceEvent();

  @override
  List<Object> get props => [];
}

final class SpaceEventGetSpaces extends SpaceEvent {
  const SpaceEventGetSpaces();
}

final class SpaceEventUpdateSpaceName extends SpaceEvent {
  final String spaceName;

  const SpaceEventUpdateSpaceName(this.spaceName);
}

// Update Standard Items
final class SpaceEventUpdateStandardItems extends SpaceEvent {
  final List<StandardItem> standardItems;

  const SpaceEventUpdateStandardItems(this.standardItems);
}
