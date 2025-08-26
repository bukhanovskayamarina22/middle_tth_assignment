import 'package:equatable/equatable.dart';

abstract class AssetsEvent extends Equatable {
  const AssetsEvent();

  @override
  List<Object> get props => [];
}

class LoadAssets extends AssetsEvent {
  const LoadAssets();
}

class LoadNextPage extends AssetsEvent {
  const LoadNextPage();
}
