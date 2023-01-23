// Dart imports:

// Flutter imports:

// Package imports:
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:stow/models/container.dart' as custom_container;

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
      List<custom_container.Container>? containers,
      this.numContainers = 0})
      : containers = containers ?? const [];

  final List<custom_container.Container> containers;
  final int numContainers;
  final ContainersStatus status;

  @override
  List<Object?> get props => [status, containers, numContainers];

  ContainersState copyWith({
    ContainersStatus? status,
    List<custom_container.Container>? containers,
    int? numContainers,
  }) {
    return ContainersState(
        containers: containers ?? this.containers,
        numContainers: numContainers ?? this.numContainers,
        status: status ?? this.status);
  }
}
