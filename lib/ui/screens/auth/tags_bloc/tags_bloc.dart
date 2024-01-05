import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:seymo_pay_mobile_application/data/tags/model/tag_request.dart';

import '../../../../data/constants/shared_prefs.dart';
import '../../../../data/tags/api/tag_api.dart';
import '../../../../data/tags/model/tag_model.dart';

part 'tags_event.dart';
part 'tags_state.dart';

class TagsBloc extends Bloc<TagsEvent, TagsState> {
  final TagApiImpl tagApiImpl;
  final SharedPreferenceModule sharedPreferenceModule;
  TagsBloc(this.tagApiImpl, this.sharedPreferenceModule) : super(const TagsState()) {
    on<TagsEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<TagsEventGetTags>(_getTags);
    on<TagsEventUpdateTags>(_updateTag);
  }

  Future<void> _getTags(TagsEventGetTags event, Emitter<TagsState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final tags = await tagApiImpl.getTags();
      sharedPreferenceModule.saveTags(tags);
      emit(state.copyWith(
          status: TagsStateStatus.success,
          tags: tags,
          isLoading: false,
          successMessage: "Tag"));
    } on DioException catch (error) {
      emit(state.copyWith(
        errorMessage: error.response?.data['message'] ?? "Network Error",
        isLoading: false,
        status: TagsStateStatus.error,
      ));
    } finally {
      emit(state.copyWith(
        status: TagsStateStatus.initial,
        errorMessage: null,
        successMessage: null,
        isLoading: false,
      ));
    }
  }

  // Update Tag
  Future<void> _updateTag(
      TagsEventUpdateTags event, Emitter<TagsState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final tag = await tagApiImpl.updateTag(event.tag, "");
      emit(state.copyWith(
          status: TagsStateStatus.success,
          tagResponse: tag,
          isLoading: false,
          successMessage: "Tag successfully updated"));
    } on DioException catch (error) {
      emit(state.copyWith(
        errorMessage: error.response?.data['message'] ?? "Network Error",
        isLoading: false,
        status: TagsStateStatus.error,
      ));
    } finally {
      emit(state.copyWith(
        status: TagsStateStatus.initial,
        errorMessage: null,
        successMessage: null,
        isLoading: false,
      ));
    }
  }
}
