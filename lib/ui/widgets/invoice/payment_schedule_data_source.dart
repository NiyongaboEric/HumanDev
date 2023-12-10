import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class PaymentScheduleDataSource extends DataGridSource {
  PaymentScheduleDataSource(List<PaymentScheduleTable> items) {
    _items = items
        .map<DataGridRow>((e) => DataGridRow(cells: [
              // DataGridCell<int>(columnName: 'id', value: e.id),
              DataGridCell<DateTime>(columnName: 'date', value: e.date),
              DataGridCell<double>(columnName: 'due', value: e.due),
              DataGridCell<double>(columnName: 'paid', value: e.paid),
            ]))
        .toList();
  }

  List<DataGridRow> _items = [];

  @override
  List<DataGridRow> get rows => _items;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: (dataGridCell.columnName == 'id' ||
                dataGridCell.columnName == 'salary')
            ? Alignment.centerRight
            : Alignment.centerLeft,
        padding: const EdgeInsets.all(16.0),
        child: Text(dataGridCell.value.toString()),
      );
    }).toList());
  }
}

class PaymentScheduleTable {
  final int id;
  final DateTime date;
  final double due;
  final double paid;

  PaymentScheduleTable({
    required this.id,
    required this.date,
    required this.due,
    required this.paid,
  });
}
