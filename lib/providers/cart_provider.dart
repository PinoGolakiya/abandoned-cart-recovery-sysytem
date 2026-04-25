import 'package:abandoned_cart_recovery_system/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import '../models/cart_model.dart';
import '../services/db_services.dart';

class CartProvider extends ChangeNotifier {
  List<CartModel> carts = [];

  // INIT → Always fresh dummy data
  Future<void> init() async {
    // reset every perform data when app kill
    await DBService.clearAll();
    await _insertDummy();
    await loadCarts();
  }

  //  Realistic CRM feel data
  Future<void> _insertDummy() async {
    final dummy = [
      {
        "userName": "Rahul Patel",
        "product": "Nike Shoes",
        "amount": 2999,
        "status": "abandoned",
        "time": "10:30 AM",
      },
      {
        "userName": "Aman Shah",
        "product": "iPhone 13",
        "amount": 79999,
        "status": "abandoned",
        "time": "11:00 AM",
      },
      {
        "userName": "Priya Mehta",
        "product": "Handbag",
        "amount": 2499,
        "status": "abandoned",
        "time": "12:10 PM",
      },
      {
        "userName": "Kiran Verma",
        "product": "Laptop",
        "amount": 55999,
        "status": "abandoned",
        "time": "1:00 PM",
      },
      {
        "userName": "Neha Jain",
        "product": "Watch",
        "amount": 4999,
        "status": "abandoned",
        "time": "2:15 PM",
      },
      {
        "userName": "Rohit Singh",
        "product": "Headphones",
        "amount": 1999,
        "status": "abandoned",
        "time": "3:00 PM",
      },
    ];

    for (var item in dummy) {
      await DBService.insertCart(item);
    }
  }

  // Load carts from DB
  Future<void> loadCarts() async {
    final res = await DBService.getCarts();
    carts = res.map((e) => CartModel.fromMap(e)).toList();
    notifyListeners();
  }

  // Update status
  Future<void> updateStatus(int id, String status) async {
    await DBService.updateCartStatus(id, status);
    await loadCarts();
  }

  // Filters
  List<CartModel> get abandonedCarts =>
      carts.where((e) => e.status == AppStrings.abandonedKey).toList();

  List<CartModel> get followUpCarts =>
      carts.where((e) => e.status == AppStrings.followUpKey).toList();

  List<CartModel> get convertedCarts =>
      carts.where((e) => e.status == AppStrings.convertedKey).toList();

  // High value (>5000)
  List<CartModel> get highValueCarts =>
      carts.where((e) => e.amount > 5000 && e.status == AppStrings.abandonedKey).toList();

  int get highValueCount => highValueCarts.length;

  // Stats
  int get abandoned => abandonedCarts.length;

  int get converted => convertedCarts.length;

  double get revenue => convertedCarts.fold(0, (sum, e) => sum + e.amount);

  // Daily calls dummy data
  Map<String, int> get dailyCalls {
    return {
      "Mon": 10,
      "Tue": 3,
      "Wed": 4,
      "Thu": 5,
      "Fri": 6,
      "Sat": 7,
      "Sun": 10,
    };
  }

  //  Call result distribution
  Map<String, int> get callStats {
    return {
      "Converted": convertedCarts.length,
      "Follow-up": followUpCarts.length,
      "Lost": carts.where((e) => e.status == AppStrings.noInterested).length,
    };
  }
}
