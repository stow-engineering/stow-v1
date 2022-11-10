import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:stow/utils/firebase.dart';
import 'package:stow/models/container.dart' as customContainer;
import 'containers_events.dart';
import 'containers_state.dart';

class ContainersBloc extends Bloc<ContainersEvent, ContainersState> {
  ContainersBloc({
    required this.service,
    this.newContainer,
  }) : super(const ContainersState()) {
    on<LoadContainers>(_mapLoadEventToState);
    on<AddContainer>(_mapAddEventToState);
    on<DeleteContainer>(_mapDeleteEventToState);
    on<UpdateContainer>(_mapUpdateEventToState);
  }
  final FirebaseService service;
  final customContainer.Container? newContainer;

  void _mapLoadEventToState(
      LoadContainers event, Emitter<ContainersState> emit) async {
    emit(state.copyWith(status: ContainersStatus.loading));
    try {
      final containers = await service.getContainerList();
      emit(
        state.copyWith(
          status: ContainersStatus.success,
          containers: containers,
          numContainers: containers!.length,
        ),
      );
    } catch (error, stacktrace) {
      print(stacktrace);
      emit(state.copyWith(status: ContainersStatus.error));
    }
  }

  void _mapAddEventToState(
      AddContainer event, Emitter<ContainersState> emit) async {
    emit(state.copyWith(status: ContainersStatus.loading));
    try {
      List<customContainer.Container> newContainerList =
          state.containers as List<customContainer.Container>;
      newContainerList.add(event.container);
      service.updateContainerData(event.container.name, event.container.size,
          event.container.uid, null, null);
      service.updateContainers(event.container.uid);
      emit(
        state.copyWith(
            status: ContainersStatus.success,
            containers: newContainerList,
            numContainers: newContainerList.length),
      );
    } catch (error, stacktrace) {
      print(stacktrace);
      emit(state.copyWith(status: ContainersStatus.error));
    }
  }

  void _mapDeleteEventToState(
      DeleteContainer event, Emitter<ContainersState> emit) async {
    emit(state.copyWith(status: ContainersStatus.loading));
    try {
      List<customContainer.Container> newContainerList =
          state.containers as List<customContainer.Container>;
      newContainerList.remove(event.container);
      service.deleteContainer(event.container.uid);
      emit(
        state.copyWith(
            status: ContainersStatus.success,
            containers: newContainerList,
            numContainers: newContainerList.length),
      );
    } catch (error, stacktrace) {
      print(stacktrace);
      emit(state.copyWith(status: ContainersStatus.error));
    }
  }

  void _mapUpdateEventToState(
      UpdateContainer event, Emitter<ContainersState> emit) async {
    emit(state.copyWith(status: ContainersStatus.loading));
    try {
      List<customContainer.Container> newContainerList =
          state.containers as List<customContainer.Container>;
      for (int i = 0; i < newContainerList.length; i++) {
        if (newContainerList[i].uid == event.mac) {
          newContainerList[i].name = event.name;
          newContainerList[i].size = event.size;
        }
      }
      service.updateContainerData(
          event.name, event.size, event.mac, event.value, event.full);
      emit(
        state.copyWith(
            status: ContainersStatus.success,
            containers: newContainerList,
            numContainers: newContainerList.length),
      );
    } catch (error, stacktrace) {
      print(stacktrace);
      emit(state.copyWith(status: ContainersStatus.error));
    }
  }
}
