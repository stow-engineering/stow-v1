import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stow/utils/firebase.dart';
import 'package:stow/models/container.dart' as customContainer;
import 'package:equatable/equatable.dart';

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
