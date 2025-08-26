import 'package:bloc/bloc.dart';
import 'package:middle_tth_assignment/data/dio.dart';
import 'package:middle_tth_assignment/data/models.dart';
import 'package:middle_tth_assignment/logic/event.dart';
import 'package:middle_tth_assignment/logic/state.dart';
import 'package:middle_tth_assignment/main.dart';

class AssetsBloc extends Bloc<AssetsEvent, AssetsState> {
  final ApiService _apiService;

  AssetsBloc({required ApiService apiService}) : _apiService = apiService, super(const Initial()) {
    on<LoadAssets>(_onLoadAssets);
    on<LoadNextPage>(_onLoadNextPage);
  }

  Future<void> _onLoadAssets(LoadAssets event, Emitter<AssetsState> emit) async {
    await _loadAssets(emit);
  }

  Future<void> _loadAssets(Emitter<AssetsState> emit) async {
    emit(const Loading());
    await _fetchAssets(emit, 1, []);
  }

  Future<void> _onLoadNextPage(LoadNextPage event, Emitter<AssetsState> emit) async {
    if (state is Loaded) {
      final currentState = state as Loaded;
      await _fetchAssets(emit, currentState.currentPage + 1, currentState.assets);
    }
  }

  Future<void> _fetchAssets(Emitter<AssetsState> emit, int page, List<Asset> existingAssets) async {
    try {
      final response = await _apiService.getAssets(page: page);
      final newAssets = response.map((a) => Asset.fromResponse(a)).toList();

      final allAssets = page == 1 ? newAssets : [...existingAssets, ...newAssets];

      emit(Loaded(assets: allAssets, currentPage: page));
    } catch (error, stack) {
      logger.e('''
       Error in AssetsBloc._fetchAssets: 
       Error: $error,
       Stack: $stack,
       Parameters:
          page: $page,
          existingAssets: $existingAssets
       ''');
      emit(AssetsError(message: error.toString(), assets: existingAssets, currentPage: page > 1 ? page - 1 : 1));
    }
  }
}

class AssetsError extends AssetsState {
  final String message;
  final List<Asset> assets;
  final int currentPage;

  const AssetsError({required this.message, this.assets = const [], this.currentPage = 1});

  @override
  List<Object> get props => [message, assets, currentPage];
}
