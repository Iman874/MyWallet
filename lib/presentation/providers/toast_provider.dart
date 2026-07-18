import 'package:flutter/foundation.dart';

enum ToastType { success, error, warning, info }

class ToastMessage {
  final int id;
  final ToastType type;
  final String title;
  final String message;
  final int duration;

  ToastMessage({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.duration = 3000,
  });
}

class ToastProvider extends ChangeNotifier {
  static const int _maxToasts = 3;
  final List<ToastMessage> _toasts = [];
  int _nextId = 0;

  List<ToastMessage> get toasts => List.unmodifiable(_toasts);

  void showSuccess(String title, String message) {
    _add(ToastType.success, title, message);
  }

  void showError(String title, String message) {
    _add(ToastType.error, title, message);
  }

  void showWarning(String title, String message) {
    _add(ToastType.warning, title, message);
  }

  void showInfo(String title, String message) {
    _add(ToastType.info, title, message);
  }

  void _add(ToastType type, String title, String message) {
    final toast = ToastMessage(
      id: _nextId++,
      type: type,
      title: title,
      message: message,
    );
    _toasts.add(toast);

    if (_toasts.length > _maxToasts) {
      _toasts.removeAt(0);
    }

    notifyListeners();

    Future.delayed(Duration(milliseconds: toast.duration), () {
      remove(toast.id);
    });
  }

  void remove(int id) {
    _toasts.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void clear() {
    _toasts.clear();
    notifyListeners();
  }
}
