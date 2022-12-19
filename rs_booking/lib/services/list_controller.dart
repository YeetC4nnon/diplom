/*import 'package:flutter/material.dart';
import 'package:rs_booking/services/models.dart';
import 'package:rs_booking/services/repository.dart';
import 'package:rs_booking/services/list_state.dart';

class ListController extends ValueNotifier<ListState> {
  ListController() : super(ListState()) {
    loadStudios();
  }

  Future<Stream<List<Studio>>> _fetchRecords() async {
    final loadedStudios = MockRepository().studios();
    return loadedStudios;
  }

  Future<void> loadStudios() async {
    if (value.isLoading) return;

    value = value.copyWith(stage: ListStage.loading);

    try {
      final fetchResult = await _fetchRecords();

      value = value.copyWith(
        stage: ListStage.idle,
        studios: fetchResult,
      );
    } catch (e) {
      value = value.copyWith(stage: ListStage.error);
      rethrow;
    }
  }

  repeatQuery() {
    return loadStudios();
  }
}
*/