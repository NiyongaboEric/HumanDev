part of 'tags_bloc.dart';

sealed class TagsEvent extends Equatable {
  const TagsEvent();

  @override
  List<Object> get props => [];
}

final class TagsEventGetTags extends TagsEvent {
  const TagsEventGetTags();
}

class TagsEventUpdateTags extends TagsEvent {
  final TagRequest tag;
  
  const TagsEventUpdateTags(this.tag);
}
