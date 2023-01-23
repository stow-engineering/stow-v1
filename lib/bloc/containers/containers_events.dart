// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:stow/models/container.dart' as custom_container;

@immutable
abstract class ContainersEvent {
  const ContainersEvent([List props = const []]);
}

class LoadContainers extends ContainersEvent {
  @override
  String toString() => 'LoadContainers';
}

class AddContainer extends ContainersEvent {
  final custom_container.Container container;

  AddContainer(this.container) : super([container]);

  @override
  String toString() => 'AddContainer { container: $container }';
}

class UpdateContainer extends ContainersEvent {
  final String mac;
  final String name;
  final String size;
  final int? value;
  final bool? full;

  UpdateContainer(this.mac, this.name, this.size, this.value, this.full)
      : super([mac, name, size, value, full]);

  @override
  String toString() =>
      'UpdateContainer { mac: $mac, name: $name, size:$size, value:$value, full:$full }';
}

class DeleteContainer extends ContainersEvent {
  final custom_container.Container container;

  DeleteContainer(this.container) : super([container]);

  @override
  String toString() => 'DeleteContainer { container: $container }';
}
