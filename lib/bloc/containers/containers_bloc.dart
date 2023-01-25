// Dart imports:
import 'dart:developer';

// Package imports:
import 'package:bloc/bloc.dart';

// Project imports:
import 'package:stow/bloc/containers/containers_events.dart';
import 'package:stow/bloc/containers/containers_state.dart';
import 'package:stow/models/container.dart' as customer_container;
import 'package:stow/utils/firebase.dart';

// Flutter imports:

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
  final customer_container.Container? newContainer;

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
      log(stacktrace.toString());
      emit(state.copyWith(status: ContainersStatus.error));
    }
  }

  void _mapAddEventToState(
      AddContainer event, Emitter<ContainersState> emit) async {
    emit(state.copyWith(status: ContainersStatus.loading));
    try {
      List<customer_container.Container> newContainerList = state.containers;
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
      log(stacktrace.toString());
      emit(state.copyWith(status: ContainersStatus.error));
    }
  }

  void _mapDeleteEventToState(
      DeleteContainer event, Emitter<ContainersState> emit) async {
    emit(state.copyWith(status: ContainersStatus.loading));
    try {
      List<customer_container.Container> newContainerList = state.containers;
      newContainerList.remove(event.container);
      service.deleteContainer(event.container.uid);
      emit(
        state.copyWith(
            status: ContainersStatus.success,
            containers: newContainerList,
            numContainers: newContainerList.length),
      );
    } catch (error, stacktrace) {
      log(stacktrace.toString());
      emit(state.copyWith(status: ContainersStatus.error));
    }
  }

  void _mapUpdateEventToState(
      UpdateContainer event, Emitter<ContainersState> emit) async {
    emit(state.copyWith(status: ContainersStatus.loading));
    try {
      List<customer_container.Container> newContainerList = state.containers;
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
      log(stacktrace.toString());
      emit(state.copyWith(status: ContainersStatus.error));
    }
  }
}
