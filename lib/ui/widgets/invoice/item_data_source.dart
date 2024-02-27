import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                  ? double.parse(e.getCells()[2].value)
                  : e.getCells()[2].value is int
                    ? (e.getCells()[2].value as int).toDouble()
                    : e.getCells()[2].value,
              total: e.getCells()[3].value is String
                  ? parseToNum(e.getCells()[3].value)
                  // ? int.parse(e.getCells()[3].value)
                  : (e.getCells()[3].value as double).toInt(),
              taxAmount: 0,
              taxRate:
                  int.parse(e.getCells()[4].value.toString().split(" ").first) /
                      100,
            ))
        .toList();
  }

  int parseToNum(String numStr) {
    num? parsedNumber = num.tryParse(numStr);

    if (parsedNumber != null) {
      if (parsedNumber is int) {
        int intValue = parsedNumber;
        return intValue;
      } else if (parsedNumber is double) {
        double doubleValue = parsedNumber;
        return doubleValue.toInt();
      }
    }
    return 0;
  }

  ItemsDataSource(List<ItemsTable> items) {
    _items = items
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'items', value: e.items),
              DataGridCell<String>(
                  columnName: 'quantity', value: e.quantity.toString()),
              DataGridCell<double>(columnName: 'price', value: e.price),
              DataGridCell<double>(columnName: 'total', value: e.total),
              DataGridCell<String>(columnName: 'vat', value: '${e.vat} %'),
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
    String displayText = dataGridRow
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

    if (column.columnName == "vat") displayText = displayText.split(" ").first;

    final bool isNumericType =
        column.columnName == 'quantity' || column.columnName == 'vat';

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
          // hintText: "Enter value",
          fillColor: SecondaryColors.secondaryPurple,
          focusColor: SecondaryColors.secondaryPurple,
          hoverColor: SecondaryColors.secondaryPurple,
          contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
        ),
        style: TextStyle(
            color: SecondaryColors.secondaryPurple,
            fontSize: CustomFontSize.small),
        cursorColor: SecondaryColors.secondaryPurple,
        inputFormatters: [
          isNumericType || isDoubleType
              ? FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              : FilteringTextInputFormatter.singleLineFormatter
        ],
        keyboardType: isNumericType || isDoubleType
            ? TextInputType.number
            : TextInputType.text,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            if (isNumericType) {
              if (column.columnName == "vat" && int.parse(value) > 100) {
                newCellValue = 100;
                return;
              }
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
    } else if (column.columnName == 'vat') {
      _items[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'vat', value: '${newCellValue} %');
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
  final int vat;

  ItemsTable({
    this.id,
    required this.items,
    required this.quantity,
    required this.price,
    required this.total,
    required this.vat,
  });
}
