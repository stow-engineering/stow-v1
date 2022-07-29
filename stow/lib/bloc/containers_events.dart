import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stow/bloc/containers_state.dart';
import 'package:stow/utils/firebase.dart';
import '../models/container.dart' as customContainer;
import '../models/user.dart';

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

  UpdateContainer(this.mac, this.name, this.size) : super([mac, name, size]);

  @override
  String toString() => 'UpdateContainer { mac: $mac, name: $name, size:$size }';
}

class DeleteContainer extends ContainersEvent {
  final customContainer.Container container;

  DeleteContainer(this.container) : super([container]);

  @override
  String toString() => 'DeleteContainer { container: $container }';
}
