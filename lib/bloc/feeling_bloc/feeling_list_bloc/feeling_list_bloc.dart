import 'package:bloc/bloc.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_list_bloc/feeling_list_event.dart';
import 'package:daily_dose_of_happiness/bloc/feeling_bloc/feeling_list_bloc/feeling_list_state.dart';
import 'package:daily_dose_of_happiness/model/feeling_model.dart';
import 'package:daily_dose_of_happiness/model/user_feeling_model.dart';
import 'package:daily_dose_of_happiness/repository/feeling_repository.dart';
import 'package:flutter/material.dart';

class FeelingListBloc extends Bloc<FeelingListEvent, FeelingListState> {
  FeelingRepository repository;
  FeelingListBloc({required this.repository}) : super(InitFeelingListState()) {
    on<LoadFeelingsEvent>((event, emit) async {
      //set state to loading
      emit(LoadingFeelingListState());
      try {
        final response = <FeelingModel>[
          FeelingModel(
              id: 'id',
              feelingName: FeelingEnum.happy,
              feelingColor: Color(0xFFFFE38D)),
          FeelingModel(
              id: 'id',
              feelingName: FeelingEnum.stressed,
              feelingColor: Color(0xFF7A86C2)),
          FeelingModel(
              id: 'id',
              feelingName: FeelingEnum.afraid,
              feelingColor: Color(0xFF6FA9E8)),
          FeelingModel(
              id: 'id',
              feelingName: FeelingEnum.sad,
              feelingColor: Color(0xFFBCA7D9)),
          FeelingModel(
              id: 'id',
              feelingName: FeelingEnum.tiered,
              feelingColor: Color(0xFFE8D5CC)),
          FeelingModel(
              id: 'id',
              feelingName: FeelingEnum.calm,
              feelingColor: Color(0xFFF3D39B)),
          FeelingModel(
              id: 'id',
              feelingName: FeelingEnum.motivated,
              feelingColor: Color(0xFFFFB882)),
        ];
        // await repository.loadFeelings();
        //set state to success
        if (response != null) {
          emit((LoadedFeelingListState(feelings: response)));
        }
        //set state to fail
        else {
          emit(FailedLoadFeelingListState());
        }
      } catch (_) {
        //set state to fail
        emit(FailedLoadFeelingListState());
      }
    });
    on<LoadLastWeekFeelingsEvent>((event, emit) async {
      //set state to loading
      emit(LoadingFeelingListState());
      try {
        final response = <UserFeelingModel>[
          UserFeelingModel(
              id: 'id',
              date: DateTime.now().subtract(Duration(days: 5)),
              feeling: FeelingModel(
                  id: 'id',
                  feelingName: FeelingEnum.motivated,
                  feelingColor: Color(0xFFFFB882))),
          UserFeelingModel(
            id: 'id',
            date: DateTime.now().subtract(Duration(days: 4)),
            feeling: FeelingModel(
                id: 'id',
                feelingName: FeelingEnum.motivated,
                feelingColor: Color(0xFFFFB882)),
          ),
          UserFeelingModel(
            id: 'id',
            date: DateTime.now().subtract(Duration(days: 1)),
            feeling: FeelingModel(
                id: 'id',
                feelingName: FeelingEnum.motivated,
                feelingColor: Color(0xFFFFB882)),
          ),
        ];
        // await repository.loadLastWeeksFeelings();
        //set state to success
        if (response != null) {
          emit((LoadedLastWeekFeelingListState(feelings: response)));
        }
        //set state to fail
        else {
          emit(FailedLoadFeelingListState());
        }
      } catch (_) {
        //set state to fail
        emit(FailedLoadFeelingListState());
      }
    });
  }
}
