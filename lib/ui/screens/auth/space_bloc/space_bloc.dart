import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:seymo_pay_mobile_application/data/constants/logger.dart';
import 'package:seymo_pay_mobile_application/data/constants/shared_prefs.dart';
import 'package:seymo_pay_mobile_application/data/space/model/space_model.dart';

import '../../../../data/space/api/space_api.dart';

part 'space_event.dart';
part 'space_state.dart';

class SpaceBloc extends Bloc<SpaceEvent, SpaceState> {
  final SharedPreferenceModule sharedPreferenceModule;
  final SpaceApiImpl spaceApiImpl;

  SpaceBloc(this.sharedPreferenceModule, this.spaceApiImpl)
      : super(const SpaceState()) {
    on<SpaceEventGetSpaces>(_getSpaces);
    on<SpaceEventUpdateSpaceName>(_updateSpaceName);
  }

  Future<void> _getSpaces(
      SpaceEventGetSpaces event, Emitter<SpaceState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final token = sharedPreferenceModule.getToken();
      if (token == null) {
        throw Exception("No Token: Unauthorized");
      }
      List<Space> spaces = await spaceApiImpl.getSpaces();
      sharedPreferenceModule.saveSpaces(spaces);
      logger.d(spaces);
      emit(state.copyWith(
        spaces: spaces,
        status: SpaceStateStatus.success,
        isLoading: false,
      ));
    } on Exception catch (error) {
      logger.w(error);
      emit(state.copyWith(
        errorMessage: error.toString(),
        status: SpaceStateStatus.error,
        isLoading: false,
      ));
      emit(state.copyWith(
        errorMessage: null,
        isLoading: false,
      ));
    } finally {
      emit(state.copyWith(
        isLoading: false,
        status: SpaceStateStatus.initial,
        errorMessage: null,
      ));
    }
  }

  // Update Space Name
  Future<void> _updateSpaceName(
      SpaceEventUpdateSpaceName event, Emitter<SpaceState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final token = sharedPreferenceModule.getToken();
      if (token == null) {
        throw Exception("No Token: Unauthorized");
      }
      Space space = await spaceApiImpl.updateSpace(event.spaceName);
      emit(state.copyWith(
        status: SpaceStateStatus.success,
        spaces: [space],
        isLoading: false,
      ));
    } on Exception catch (error) {
      logger.w(error);
      emit(state.copyWith(
        errorMessage: error.toString(),
        status: SpaceStateStatus.error,
        isLoading: false,
      ));
      emit(state.copyWith(
        errorMessage: null,
        isLoading: false,
      ));
    } finally {
      emit(state.copyWith(
        isLoading: false,
        status: SpaceStateStatus.initial,
        errorMessage: null,
      ));
    }
  }
}
