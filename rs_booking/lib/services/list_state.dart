/*import 'package:rs_booking/services/models.dart';

enum ListStage { idle, loading, error, complete }

class ListState {
  ListState({
    List<Studio>? studios,
    this.stage = ListStage.idle,
  }) : studiosStore = studios {
    if (isInitialized && stage != ListStage.complete && this.studios.isEmpty) {
      throw Exception(
          "List is empty but has stage marker other than `complete`");
    }
  }

  final List<Studio>? studiosStore;

  bool get isInitialized => studiosStore != null;

  final ListStage stage;

  List<Studio> get studios => studiosStore ?? List<Studio>.empty();

  bool get hasError => stage == ListStage.error;

  bool get isLoading => stage == ListStage.loading;

  ListState copyWith({
    List<Studio>? studios,
    ListStage? stage,
  }) {
    return ListState(
      studios: studios ?? studiosStore,
      stage: stage ?? this.stage,
    );
  }
}
*/