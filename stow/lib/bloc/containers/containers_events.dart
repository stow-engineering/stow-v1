import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stow/bloc/containers/containers_state.dart';
import 'package:stow/utils/firebase.dart';
import '../../models/container.dart' as customContainer;
import '../../models/user.dart';

@immutable
abstract class ContainersEvent {
  const ContainersEvent([List props = const []]);
}

class LoadContainers extends ContainersEvent {
  @override
  String toString() => 'LoadContainers';
}

class AddContainer extends ContainersEvent {
  final customContainer.Container container;

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
  final customContainer.Container container;

  DeleteContainer(this.container) : super([container]);

  @override
  String toString() => 'DeleteContainer { container: $container }';
}
