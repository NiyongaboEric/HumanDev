import 'package:flutter/material.dart';
import 'package:seymo_pay_mobile_application/data/invoice/model/invoice_request.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/font_sizes.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class ItemsDataSource extends DataGridSource {
  dynamic newCellValue;

  /// Helps to control the editable text in the [TextField] widget.
  TextEditingController editingController = TextEditingController();
  List<DataGridRow> _items = [];

  // Saved Items
  List<InvoiceItemRequest> savedItem() {
    return _items
        .map<InvoiceItemRequest>((e) => InvoiceItemRequest(
              description: e.getCells()[0].value.toString(),
              quantity: int.parse(e.getCells()[1].value.toString()),
              grossPrice: e.getCells()[2].value is String
                  ? int.parse(e.getCells()[2].value)
                  : (e.getCells()[2].value as double).toInt(),
              total: e.getCells()[3].value is String
                  ? int.parse(e.getCells()[3].value)
                  : (e.getCells()[3].value as double).toInt(),
            ))
        .toList();
  }

  ItemsDataSource(List<ItemsTable> items) {
    _items = items
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'items', value: e.items),
              DataGridCell<String>(
                  columnName: 'quantity', value: e.quantity.toString()),
              DataGridCell<double>(columnName: 'price', value: e.price),
              DataGridCell<double>(columnName: 'total', value: e.total),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _items;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: (dataGridCell.columnName == 'items')
            ? Alignment.centerLeft
            : Alignment.center,
        padding: dataGridCell.columnName == 'items'
            ? const EdgeInsets.only(left: 6.0)
            : const EdgeInsets.all(8.0),
        child: Text(
          dataGridCell.value.toString(),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: SecondaryColors.secondaryPurple,
              fontSize: CustomFontSize.small),
        ),
      );
    }).toList());
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    // Text going to display on editable widget
    final String displayText = dataGridRow
            .getCells()
            .firstWhere((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            .value
            ?.toString() ??
        '';

    // The new cell value must be reset.
    // To avoid committing the [DataGridCell] value that was previously edited
    // into the current non-modified [DataGridCell].
    newCellValue = null;

    final bool isNumericType = column.columnName == 'quantity';

    final bool isDoubleType = column.columnName == 'price';

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: isNumericType ? Alignment.centerRight : Alignment.centerLeft,
      child: TextField(
        autofocus: true,
        controller: editingController..text = displayText,
        textAlign:
            isNumericType || isDoubleType ? TextAlign.right : TextAlign.left,
        decoration: InputDecoration(
          fillColor: SecondaryColors.secondaryPurple,
          focusColor: SecondaryColors.secondaryPurple,
          hoverColor: SecondaryColors.secondaryPurple,
          contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
        ),
        style: TextStyle(
            color: SecondaryColors.secondaryPurple,
            fontSize: CustomFontSize.small),
        cursorColor: SecondaryColors.secondaryPurple,
        keyboardType: isNumericType || isDoubleType
            ? TextInputType.number
            : TextInputType.text,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            if (isNumericType) {
              newCellValue = int.parse(value);
            } else if (isDoubleType) {
              newCellValue = double.parse(value);
            } else {
              newCellValue = value;
            }
          } else {
            newCellValue = null;
          }
        },
        onSubmitted: (String value) {
          submitCell();
        },
      ),
    );
  }

  @override
  Future<void> onCellSubmit(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column) async {
    final dynamic oldValue = dataGridRow
            .getCells()
            .firstWhere((DataGridCell dataGridCell) =>
                dataGridCell.columnName == column.columnName)
            .value ??
        '';

    final int dataRowIndex = _items.indexOf(dataGridRow);

    if (newCellValue == null || oldValue == newCellValue) {
      return;
    }

    if (column.columnName == 'items') {
      _items[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'items', value: newCellValue);
      // _employees[dataRowIndex].name = newCellValue.toString();
    } else if (column.columnName == 'quantity') {
      _items[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(columnName: 'quantity', value: newCellValue);
      // _employees[dataRowIndex].designation = newCellValue.toString();
    } else {
      _items[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<double>(columnName: 'price', value: newCellValue);
      // _employees[dataRowIndex].salary = newCellValue as int;
    }

    _items[dataRowIndex].getCells()[3] = DataGridCell<double>(
        columnName: 'total',
        value: (double.parse(
                _items[dataRowIndex].getCells()[1].value.toString()) *
            double.parse(_items[dataRowIndex].getCells()[2].value.toString())));

    savedItem();

    notifyListeners();
  }
}

class ItemsTable {
  final int? id;
  final String items;
  final int quantity;
  final double price;
  final double total;

  ItemsTable({
    this.id,
    required this.items,
    required this.quantity,
    required this.price,
    required this.total,
  });
}
