import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/web.dart';
import 'package:middle_tth_assignment/constants.dart';
import 'package:middle_tth_assignment/data/dio.dart';
import 'package:middle_tth_assignment/data/models.dart';
import 'package:middle_tth_assignment/logic/bloc.dart';
import 'package:middle_tth_assignment/logic/event.dart';
import 'package:middle_tth_assignment/logic/state.dart';

final logger = Logger();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AssetsBloc>(
      create: (context) => AssetsBloc(apiService: ApiService())..add(LoadAssets()),
      child: MaterialApp(
        title: TextConstants.appName,
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
        home: const MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<AssetsBloc>().add(const RefreshAssets());
        },
        child: Center(
          child: BlocBuilder<AssetsBloc, AssetsState>(
            builder: (context, state) {
              if (state is Initial || state is Loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is AssetsError && state.assets.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${TextConstants.error}${state.message}'),
                      ElevatedButton(
                        onPressed: () => context.read<AssetsBloc>().add(const LoadAssets()),
                        child: const Text(TextConstants.retry),
                      ),
                    ],
                  ),
                );
              }

              List<Asset> assets;
              if (state is Loaded) {
                assets = state.assets;
              } else if (state is LoadedMore) {
                assets = state.assets;
              } else if (state is AssetsError) {
                assets = state.assets;
              } else {
                assets = [];
              }

              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.atEdge && notification.metrics.pixels != 0) {
                    context.read<AssetsBloc>().add(LoadNextPage());
                  }
                  return true;
                },
                child: ListView.builder(
                  itemCount: assets.length,
                  itemBuilder: (context, index) {
                    final asset = assets[index];
                    return CoinTile(key: UniqueKey(), asset: asset);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CoinTile extends StatelessWidget {
  const CoinTile({required this.asset, super.key});

  final Asset asset;

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 17,
      height: 24 / 17,
      letterSpacing: -0.41,
      color: Color(ColorConstants.textColor),
    );
    return SizedBox(
      height: 84,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: asset.color, borderRadius: BorderRadius.circular(16)),
            ),
            SizedBox(width: 16),
            Expanded(child: Text(asset.name, style: textStyle)),
            Text('\$${asset.priceUsd}', style: textStyle),
          ],
        ),
      ),
    );
  }
}
