import 'dart:math';

import 'package:flutter/material.dart';
import 'package:middle_tth_assignment/constants.dart';

class AssetResponse {
  final String id;
  final String name;
  final String priceUid;

  AssetResponse({required this.id, required this.name, required this.priceUid});

  factory AssetResponse.fromMap(Map<String, dynamic> map) {
    return AssetResponse(id: map['id'] as String, name: map['name'] as String, priceUid: map['priceUsd'] as String);
  }
}

class Asset {
  final String id;
  final String name;
  final double priceUsd;
  final Color color;

  Asset({required this.id, required this.name, required this.priceUsd, required this.color});

  factory Asset.fromResponse(AssetResponse res) {
    // случайное число от 0 до 16777215 конвертируется в 16-ричное число,
    // добавляется 100% насыщенность, парсится в цвет
    final generatedColor = 'FF${Random().nextInt(ColorConstants.colorsRange).toRadixString(16)}';
    return Asset(
      id: res.id,
      name: res.name,
      priceUsd: double.parse(res.priceUid).toPrecision(2),
      color: Color(int.parse(generatedColor, radix: 16)),
    );
  }
}

extension DoubleExtension on double {
  double toPrecision(int n) => double.parse(toStringAsFixed(n));
}
