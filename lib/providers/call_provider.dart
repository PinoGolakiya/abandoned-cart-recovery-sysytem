import 'dart:async';
import 'dart:math';
import 'package:abandoned_cart_recovery_system/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import '../services/db_services.dart';

class CallProvider extends ChangeNotifier {
  int seconds = 0;
  String status = AppStrings.dialing;
  Timer? _timer;

  void startCall() {
    seconds = 0;
    status = AppStrings.dialing;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      seconds++;
      notifyListeners();
    });

    Future.delayed(const Duration(seconds: 2), () {
      final outcomes = [
        AppStrings.connected,
        AppStrings.busy,
        AppStrings.notAnswered,
      ];
      status = outcomes[Random().nextInt(outcomes.length)];
      notifyListeners();
    });
  }

  void endCall() {
    _timer?.cancel();
  }

  Future<void> saveCall({required int cartId, required String result}) async {
    await DBService.insertCall({
      "cartId": cartId,
      "status": result,
      "duration": seconds,
      "createdAt": DateTime.now().toString(),
    });
  }
}
