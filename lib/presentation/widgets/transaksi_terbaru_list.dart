import 'package:flutter/material.dart';
import '../../domain/entities/transaksi.dart';
import 'transaksi_list_item.dart';

class TransaksiTerbaruList extends StatelessWidget {
  final List<Transaksi> transaksiList;

  const TransaksiTerbaruList({super.key, required this.transaksiList});

  @override
  Widget build(BuildContext context) {
    final limitedList = transaksiList.take(5).toList();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: limitedList.length,
      itemBuilder: (context, index) {
        return TransaksiListItem(transaksi: limitedList[index]);
      },
    );
  }
}
