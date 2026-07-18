String formatCurrency(int amount) {
  return amount.toString().replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (m) => '${m[1]}.',
  );
}

String formatCurrencyWithPrefix(int amount, {String prefix = 'Rp '}) {
  return '$prefix${formatCurrency(amount)}';
}
