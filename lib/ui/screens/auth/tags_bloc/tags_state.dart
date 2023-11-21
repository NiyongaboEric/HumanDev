part of 'tags_bloc.dart';

enum TagsStateStatus {
  initial,
  success,
  error,
}

class TagsState {
  final TagsStateStatus status;
  final TagRequest? tagRequest;
  final TagModel? tagResponse;
  final List<TagModel> tags;
  final bool isLoading;
  final String? successMessage;
  final String? errorMessage;

  const TagsState({
    this.status = TagsStateStatus.initial,
    this.tagRequest,
    this.tagResponse,
    this.tags = const [],
    this.isLoading = false,
    this.successMessage,
    this.errorMessage,
  });
  
  TagsState copyWith({
    TagsStateStatus? status,
    TagRequest? tagRequest,
    TagModel? tagResponse,
    List<TagModel>? tags,
    bool? isLoading,
    String? successMessage,
    String? errorMessage,
  }) {
    return TagsState(
      status: status ?? this.status,
      tagRequest: tagRequest ?? this.tagRequest,
      tagResponse: tagResponse ?? this.tagResponse,
      tags: tags ?? this.tags,
      isLoading: isLoading ?? this.isLoading,
      successMessage: successMessage ?? this.successMessage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

