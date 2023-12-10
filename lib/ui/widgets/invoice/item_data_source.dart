import 'package:flutter/material.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/invoice/invoice_table.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ItemsDataSource extends DataGridSource {
  ItemsDataSource(List<ItemsTable> items) {
     _items = items
        .map<DataGridRow>((e) => DataGridRow(cells: [
              // DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<String>(columnName: 'items', value: e.items),
              DataGridCell<String>(columnName: '#', value: e.quantity.toString()),
              DataGridCell<double>(
                  columnName: 'price', value: e.price),
              DataGridCell<double>(columnName: 'Total', value: e.total),
            ]))
        .toList();
  }

  List<DataGridRow>  _items = [];

  @override
  List<DataGridRow> get rows =>  _items;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: (dataGridCell.columnName == 'id' || dataGridCell.columnName == 'salary')
            ? Alignment.centerRight
            : Alignment.centerLeft,
        padding: const EdgeInsets.all(16.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}

class ItemsTable {
  final int id;
  final String items;
  final int quantity;
  final double price;
  final double total;

  ItemsTable({
    required this.id,
    required this.items,
    required this.quantity,
    required this.price,
    required this.total,
  });
}
