import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_strings.dart';
import '../providers/call_provider.dart';
import '../providers/cart_provider.dart';
import '../core/constants/app_colors.dart';
import '../services/db_services.dart';

class CallScreen extends StatefulWidget {
  final dynamic cart;

  const CallScreen({super.key, required this.cart});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<CallProvider>(context, listen: false).startCall(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final call = Provider.of<CallProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          // Avatar + Animation
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.card,
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withAlpha(70),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(Icons.person, size: 60, color: AppColors.textColor),
          ),

          const SizedBox(height: 20),

          Text(
            widget.cart.userName,
            style: const TextStyle(fontSize: 22, color: AppColors.textColor),
          ),

          Text(call.status, style: const TextStyle(color: AppColors.glass)),

          Text("${call.seconds}s", style: const TextStyle(color: AppColors.textColor)),

          const SizedBox(height: 40),
          Spacer(),

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _actionBtn(
                color: AppColors.converted,
                icon: Icons.check,
                label: AppStrings.interested,
                onTap: () async {
                  await cartProvider.updateStatus(widget.cart.id, AppStrings.convertedKey);
                  await call.saveCall(
                    cartId: widget.cart.id,
                    result: AppStrings.interested,
                  );
                  call.endCall();
                  Navigator.pop(context);
                },
              ),

              _actionBtn(
                color: AppColors.close,
                icon: Icons.close,
                label: AppStrings.notInterested,
                onTap: () async {
                  await cartProvider.updateStatus(
                    widget.cart.id,
                    AppStrings.interestedKey,
                  );
                  await call.saveCall(
                    cartId: widget.cart.id,
                    result: AppStrings.notInterested,
                  );
                  call.endCall();
                  Navigator.pop(context);
                },
              ),

              _actionBtn(
                color: AppColors.followUp,
                icon: Icons.schedule,
                label: AppStrings.callLater,
                onTap: () async{
                  call.endCall();
                  await Provider.of<CartProvider>(context, listen: false)
                      .updateStatus(widget.cart.id, AppStrings.followUpKey);
                  _showNote(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionBtn({
    required Color color,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(icon, color: AppColors.textColor),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: AppColors.textColor)),
      ],
    );
  }

  // Premium note bottom sheet
  void _showNote(BuildContext context) {
    final controller = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  AppStrings.addNote,
                  style: TextStyle(color: AppColors.textColor, fontSize: 18),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: controller,
                  style: const TextStyle(color: AppColors.textColor),
                  decoration: const InputDecoration(
                    hintText: AppStrings.customerSaid,
                  ),
                ),

                const SizedBox(height: 15),

                ElevatedButton(
                  onPressed: () async {
                    await DBService.insertNote({
                      "cartId": widget.cart.id,
                      "note": controller.text,
                      "createdAt": DateTime.now().toString(),
                    });

                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text(AppStrings.saveSchedule),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
