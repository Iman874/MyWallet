import 'package:flutter/material.dart';

IconData? iconFromName(String? name) {
  if (name == null) return null;
  switch (name) {
    case 'attach_money': return Icons.attach_money;
    case 'restaurant': return Icons.restaurant;
    case 'directions_car': return Icons.directions_car;
    case 'sports_esports': return Icons.sports_esports;
    case 'category': return Icons.category;
    case 'shopping_cart': return Icons.shopping_cart;
    case 'health_and_safety': return Icons.health_and_safety;
    case 'school': return Icons.school;
    case 'home': return Icons.home;
    case 'favorite': return Icons.favorite;
    case 'flight': return Icons.flight;
    case 'checkroom': return Icons.checkroom;
    case 'work': return Icons.work;
    case 'payments': return Icons.payments;
    case 'account_balance': return Icons.account_balance;
    case 'card_giftcard': return Icons.card_giftcard;
    // Material Icons used in UI
    case 'light_mode': return Icons.light_mode;
    case 'dark_mode': return Icons.dark_mode;
    case 'add': return Icons.add;
    case 'edit': return Icons.edit;
    case 'delete': return Icons.delete;
    case 'search': return Icons.search;
    case 'filter_list': return Icons.filter_list;
    case 'more_vert': return Icons.more_vert;
    case 'close': return Icons.close;
    case 'check': return Icons.check;
    case 'arrow_back': return Icons.arrow_back;
    case 'arrow_forward': return Icons.arrow_forward;
    case 'arrow_upward': return Icons.arrow_upward;
    case 'arrow_downward': return Icons.arrow_downward;
    default: return null;
  }
}
