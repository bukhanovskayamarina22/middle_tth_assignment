import 'package:equatable/equatable.dart';
import 'package:middle_tth_assignment/data/models.dart';

abstract class AssetsState extends Equatable {
  const AssetsState();

  @override
  List<Object> get props => [];
}

class Initial extends AssetsState {
  const Initial();
}

class Loading extends AssetsState {
  const Loading();
}

class LoadingMore extends AssetsState {
  final List<Asset> assets;
  final int currentPage;

  const LoadingMore({required this.assets, required this.currentPage});

  @override
  List<Object> get props => [assets, currentPage];
}

class Loaded extends AssetsState {
  final List<Asset> assets;
  final int currentPage;

  const Loaded({required this.assets, required this.currentPage});

  @override
  List<Object> get props => [assets, currentPage];

  Loaded copyWith({List<Asset>? assets, int? currentPage}) {
    return Loaded(assets: assets ?? this.assets, currentPage: currentPage ?? this.currentPage);
  }
}
