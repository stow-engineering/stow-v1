import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stow/utils/firebase.dart';
import '../models/container.dart' as customContainer;
import '../models/user.dart';
import 'package:equatable/equatable.dart';

// enum ContainerAction { init, add, delete }

// class ContainerBloc {
//   final _containerState = StreamController<ContainersState>.broadcast();
//   StreamSink<ContainersState> get containerSink => _containerState.sink;
//   Stream<ContainersState> get containerStream => _containerState.stream;

//   final _eventStream = StreamController<ContainerAction>.broadcast();
//   StreamSink<ContainerAction> get eventSink => _eventStream.sink;
//   Stream<ContainerAction> get containerEventStream => _eventStream.stream;

//   FirebaseService service;
//   StowUser user;

//   ContainerBloc(this.service, this.user) {
//     user = this.user;
//     service = this.service;
//     containerEventStream.listen((event) async {
//       if (event == ContainerAction.init) {
//         List<customContainer.Container>? currentContainers =
//             await service.getContainerList();
//         ContainersState state = ContainersState(
//             containers: currentContainers ?? [],
//             numContainers: currentContainers!.length);
//         containerSink.add(state);
//       }
//     });
//   }

//   void dispose() {
//     _containerState.close();
//     _eventStream.close();
//   }
// }

// Future<List<customContainer.Container>> getContainerStream(service) async {
//   return await service.getContainerList();
// }

// @immutable
// abstract class ContainersState extends Equatable {
//   const ContainersState([List props = const []]);
// }

// class ContainersLoading extends ContainersState {
//   @override
//   String toString() => 'ContainersLoading';
// }

// class ContainersLoaded extends ContainersState {
//   final List<customContainer.Container> containers;

//   ContainersLoaded([this.containers = const []]) : super([containers]);

//   @override
//   String toString() => 'ContainersLoaded { containers: $containers }';
// }

// class ContainersNotLoaded extends ContainersState {
//   @override
//   String toString() => 'ContainersNotLoaded';
// }

// class ContainersState {
//   int numContainers;
//   List<customContainer.Container> containers;

//   ContainersState({required this.numContainers, required this.containers});
// }

//}

enum ContainersStatus { initial, success, error, loading }

extension ContainersStatusX on ContainersStatus {
  bool get isInitial => this == ContainersStatus.initial;
  bool get isSuccess => this == ContainersStatus.success;
  bool get isError => this == ContainersStatus.error;
  bool get isLoading => this == ContainersStatus.loading;
}

class ContainersState extends Equatable {
  const ContainersState(
      {this.status = ContainersStatus.initial,
      List<customContainer.Container>? containers,
      int numContainers = 0})
      : containers = containers ?? const [],
        numContainers = numContainers;

  final List<customContainer.Container> containers;
  final int numContainers;
  final ContainersStatus status;

  @override
  List<Object?> get props => [status, containers, numContainers];

  ContainersState copyWith({
    ContainersStatus? status,
    List<customContainer.Container>? containers,
    int? numContainers,
  }) {
    return ContainersState(
        containers: containers ?? this.containers,
        numContainers: numContainers ?? this.numContainers,
        status: status ?? this.status);
  }
}
