import 'package:equatable/equatable.dart';

abstract class AssetsEvent extends Equatable {
  const AssetsEvent();

  @override
  List<Object> get props => [];
}

class LoadAssets extends AssetsEvent {
  const LoadAssets();
}

class RefreshAssets extends AssetsEvent {
  const RefreshAssets();
}

class LoadNextPage extends AssetsEvent {
  const LoadNextPage();
}
