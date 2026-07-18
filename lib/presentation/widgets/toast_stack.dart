import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/toast_provider.dart';
import 'toast_widget.dart';

class ToastStack extends StatelessWidget {
  const ToastStack({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ToastProvider>(
      builder: (context, provider, child) {
        if (provider.toasts.isEmpty) return const SizedBox.shrink();

        return Positioned(
          top: MediaQuery.of(context).padding.top + 8,
          right: 12,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: provider.toasts.reversed.map((toast) {
              return ToastWidget(
                toast: toast,
                onDismiss: () => provider.remove(toast.id),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
