import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:seymo_pay_mobile_application/data/invoice/model/invoice_request.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/constants.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../data/constants/logger.dart';
import '../../utilities/colors.dart';
import '../../utilities/font_sizes.dart';

class PaymentScheduleDataSource extends DataGridSource {
  /// Helps to hold the new value of all editable widgets.
  /// Based on the new value we will commit the new value into the corresponding
  /// DataGridCell on the onCellSubmit method.
  dynamic newCellValue;

  /// Helps to control the editable text in the [TextField] widget.
  TextEditingController editingController = TextEditingController();
  List<DataGridRow> _paymentSchedule = [];

  // Get Tertiary Color
  var tertiaryColor = MaterialColor(
    TertiaryColors.tertiaryPurple.value,
    <int, Color>{
      50: TertiaryColors.tertiaryPurple,
      100: TertiaryColors.tertiaryPurple,
      200: TertiaryColors.tertiaryPurple,
      300: TertiaryColors.tertiaryPurple,
      400: TertiaryColors.tertiaryPurple,
      500: TertiaryColors.tertiaryPurple,
      600: TertiaryColors.tertiaryPurple,
      700: TertiaryColors.tertiaryPurple,
      800: TertiaryColors.tertiaryPurple,
      900: TertiaryColors.tertiaryPurple,
    },
  );

  // Saved Payment Schedule
  List<PaymentScheduleRequest> savedPaymentSchedule() {
    return _paymentSchedule
        .map<PaymentScheduleRequest>((e) => PaymentScheduleRequest(
              dueDate: e.getCells()[0].value.toString().toLowerCase() == "new date"
                  ? DateTime.now().toIso8601String()
                  : e.getCells()[0].value is DateTime
                    ? (e.getCells()[0].value as DateTime).toIso8601String()
                    : DateFormat('dd MMM yyyy').parse(e.getCells()[0].value).toIso8601String(),
              dueAmount: e.getCells()[1].value is String
                  ? int.parse(e.getCells()[1].value)
                  : (e.getCells()[1].value as double).toInt(),
            ))
        .toList();
  }

  PaymentScheduleDataSource(List<PaymentScheduleTable> paymentSchedule) {
    _paymentSchedule = paymentSchedule
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<DateTime>(columnName: 'date', value: e.date),
              DataGridCell<double>(columnName: 'due', value: e.due),
              DataGridCell<double>(columnName: 'paid', value: e.paid),
              DataGridCell<double>(columnName: 'remaining', value: e.remaining),
            ]))
        .toList();
  }

  @override
  List<DataGridRow> get rows => _paymentSchedule;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
      return Container(
        alignment: (dataGridCell.columnName == 'date')
            ? Alignment.centerLeft
            : Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: Text(
          dataGridCell.value.toString(),
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

    final bool isNumericType =
        column.columnName == 'due' || column.columnName == 'paid';

    final bool isDateType = column.columnName == 'date';

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: isNumericType ? Alignment.centerRight : Alignment.centerLeft,
      child: isDateType
          ?
          // Launch Date Picker
          FutureBuilder(
              future: Future.delayed(Duration.zero),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData(
                            colorScheme: ColorScheme.fromSwatch(
                              primarySwatch: tertiaryColor,
                            ),
                            useMaterial3: true,
                            textTheme: Theme.of(context).textTheme,
                          ),
                          child: child!,
                        );
                      }).then((value) => {
                        // Allow only past, future or both dates based on pickerTimeLine
                        if (value != null)
                          {
                            newCellValue = Constants.dateFormatParser(
                                value.toIso8601String()),
                                savedPaymentSchedule(),
                            notifyListeners(),
                            Navigator.of(context).pop(),
                          }
                      });
                });
                return Container();
              },
            )
          : TextField(
              autofocus: true,
              controller: editingController..text = displayText,
              textAlign: isNumericType || isDateType
                  ? TextAlign.right
                  : TextAlign.left,
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
              keyboardType:
                  isNumericType ? TextInputType.number : TextInputType.datetime,
              onChanged: (String value) {
                if (value.isNotEmpty) {
                  if (isNumericType) {
                    newCellValue = double.parse(value);
                  } else if (isDateType) {
                    newCellValue = Constants.dateFormatParser(value);
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

    final int dataRowIndex = _paymentSchedule.indexOf(dataGridRow);

    if (newCellValue == null || oldValue == newCellValue) {
      return;
    }

    if (column.columnName == 'date') {
      _paymentSchedule[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'date', value: newCellValue);
      // _employees[dataRowIndex].name = newCellValue.toString();
    } else if (column.columnName == 'due') {
      _paymentSchedule[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<double>(columnName: 'due', value: newCellValue);
      // _employees[dataRowIndex].designation = newCellValue.toString();
    } else if (column.columnName == 'remaining') {
      _paymentSchedule[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<double>(columnName: 'remaining', value: newCellValue);
      // _employees[dataRowIndex].designation = newCellValue.toString();
    } else {
      _paymentSchedule[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<double>(columnName: 'paid', value: newCellValue);
      // _employees[dataRowIndex].salary = newCellValue as int;
    }

    savedPaymentSchedule();

    notifyListeners();
  }
}

class PaymentScheduleTable {
  final int? id;
  final DateTime? date;
  final double? due;
  final double? paid;
  final double? remaining;

  PaymentScheduleTable({
    this.id,
    this.date,
    this.due,
    this.paid,
    this.remaining,
  });
}
