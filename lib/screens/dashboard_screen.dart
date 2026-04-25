import 'dart:ui';
import 'package:abandoned_cart_recovery_system/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../core/constants/app_colors.dart';
import '../services/db_services.dart';
import '../utils/data_utils.dart';
import 'analytics_screen.dart';
import 'call_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<CartProvider>(context, listen: false).init(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AppStrings.dashboard,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AnalyticsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context, auth);
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Welcome
            Text(
              "${AppStrings.welcome} ${auth.user?.name}",
              style: const TextStyle(
                color: AppColors.textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Follow-up badge
            if (cart.followUpCarts.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.followUp.withAlpha(60),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.notifications, color: AppColors.followUp),
                    const SizedBox(width: 10),
                    Text(
                      "${cart.followUpCarts.length} ${AppStrings.pending}",
                      style: const TextStyle(color: AppColors.followUp),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // Stats
            Row(
              children: [
                Expanded(
                  child: _glassCard(AppStrings.abandoned, "${cart.abandoned}"),
                ),
                Expanded(
                  child: _glassCard(AppStrings.converted, "${cart.converted}"),
                ),
                Expanded(
                  child: _glassCard(AppStrings.revenue, "₹${cart.revenue}"),
                ),
              ],
            ),

            // High value section
            if (cart.highValueCarts.isNotEmpty) ...[
              const SizedBox(height: 20),

              const Text(
                AppStrings.highValue,
                style: TextStyle(
                  color: AppColors.followUp,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              ...cart.highValueCarts.map((c) => _cartItem(c)).toList(),
            ],

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  // Abandoned
                  const Text(
                    AppStrings.abandonedCarts,
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  if (cart.abandonedCarts.isEmpty)
                    _emptyState(AppStrings.noAbandoned),

                  ...cart.abandonedCarts.map((c) => _cartItem(c)).toList(),

                  const SizedBox(height: 20),

                  // Follow-ups
                  if (cart.followUpCarts.isNotEmpty) ...[
                    const Text(
                      AppStrings.followUps,
                      style: TextStyle(
                        color: AppColors.followUp,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    ...cart.followUpCarts.map((c) => _cartItem(c)).toList(),
                  ],

                  const SizedBox(height: 20),

                  // Converted
                  if (cart.convertedCarts.isNotEmpty) ...[
                    const Text(
                      AppStrings.convertedTitle,
                      style: TextStyle(
                        color: AppColors.converted,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    ...cart.convertedCarts.map((c) => _cartItem(c)).toList(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
  // Logout
  void _showLogoutDialog(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            AppStrings.logout,
            style: TextStyle(color: AppColors.textColor),
          ),
          content: const Text(
           AppStrings.askLogout,
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
              },
              child: const Text(
                AppStrings.cancel,
                style: TextStyle(color: AppColors.converted),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.close,
              ),
              onPressed: () async {
                Navigator.pop(context);
                auth.logout(context);
              },
              child: const Text(AppStrings.logout,style:TextStyle(color: AppColors.textColor) ),
            ),
          ],
        );
      },
    );
  }
  // Glass card
  Widget _glassCard(String title, String value) {
    return Container(
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.glass,
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(color: AppColors.textColor)),
          Text(title, style: const TextStyle(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  // Cart item
  Widget _cartItem(cart) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CallScreen(cart: cart)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const CircleAvatar(child: Icon(Icons.person)),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cart.userName,
                    style: const TextStyle(color: AppColors.textColor),
                  ),
                  Text(
                    "${cart.product} - ₹${cart.amount}",
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),

                  const SizedBox(height: 4),

                  //  Status chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _statusColor(cart.status),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      cart.status,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Notes
            IconButton(
              icon: const Icon(Icons.note, color: AppColors.followUp),
              onPressed: () => _showNotes(cart.id),
            ),

            const Icon(Icons.call, color: AppColors.converted),
          ],
        ),
      ),
    );
  }

  // Status wise badge color set
  Color _statusColor(String status) {
    switch (status) {
      case AppStrings.convertedKey:
        return AppColors.converted;
      case AppStrings.followUpKey:
        return AppColors.followUp;
      default:
        return AppColors.glass;
    }
  }

  void _showNotes(int cartId) async {
    final notes = await DBService.getNotes(cartId);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: notes.isEmpty
              ? const Center(child: Text(AppStrings.noNotes))
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: notes.length,
                  itemBuilder: (_, i) {
                    final n = notes[i];
                    return ListTile(
                      title: Text(n['note']),
                      subtitle: Text(formatDateTime(n['createdAt'])),
                    );
                  },
                ),
        );
      },
    );
  }

  Widget _emptyState(String text) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Text(text, style: const TextStyle(color: Colors.grey)),
      ),
    );
  }
}
