/*import 'package:flutter/material.dart';

import '../services/list_state.dart';

class ListStatusIndicator extends StatelessWidget {
  final ListState listState;
  final Function()? onRepeat;

  const ListStatusIndicator(this.listState, {this.onRepeat, Key? key})
      : super(key: key);

  static bool hasStatus(ListState listState) =>
      listState.hasError ||
      listState.isLoading ||
      (listState.isInitialized && listState.studios.isEmpty); // 1

  @override
  Widget build(BuildContext context) {
    Widget? stateIndicator;
    if (listState.hasError) {
      stateIndicator =
          const Text("Ошибка загрузки данных", textAlign: TextAlign.center);
      if (onRepeat != null) {
        stateIndicator = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            stateIndicator,
            const SizedBox(width: 8),
            IconButton(onPressed: onRepeat, icon: const Icon(Icons.refresh))
          ],
        );
      }
    } else if (listState.isLoading) {
      stateIndicator = const CircularProgressIndicator();
    } else if (listState.isInitialized && listState.studios.isEmpty) {
      stateIndicator = const Text("Нет данных", textAlign: TextAlign.center);
    }

    if (stateIndicator == null) return Container();

    return Container(alignment: Alignment.center, child: stateIndicator);
  }
}
*/