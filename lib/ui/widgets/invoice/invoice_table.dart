import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_it/get_it.dart';
import 'package:seymo_pay_mobile_application/data/constants/logger.dart';
import 'package:seymo_pay_mobile_application/data/invoice/model/invoice_model.dart';
import 'package:seymo_pay_mobile_application/data/invoice/model/invoice_request.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/font_sizes.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/invoice/item_data_source.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/invoice/payment_schedule_data_source.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../../../data/constants/shared_prefs.dart';
import '../../screens/main/invoice/invoice_list/select_fee.dart';

var sl = GetIt.instance;

enum InvoiceTableType { ITEMS, PAYMENT_SCHEDULE }

class InvoiceTable extends StatefulWidget {
  final InvoiceTableType invoiceTableType;
  final List<InvoiceItemModel>? itemItems;
  final bool isEditable;
  final Function(List<InvoiceItemRequest> items)? savedItems;
  final Function(List<PaymentScheduleRequest> paymentSchedules)?
      savedPaymentSchedules;
  final List<PaymentScheduleModel>? paymentSchedules;
  const InvoiceTable({
    super.key,
    required this.invoiceTableType,
    this.itemItems,
    this.paymentSchedules,
    required this.isEditable,
    this.savedItems,
    this.savedPaymentSchedules,
  });

  @override
  State<InvoiceTable> createState() => _InvoiceTableState();
}

class _InvoiceTableState extends State<InvoiceTable> {
  TextEditingController itemController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController dueController = TextEditingController();
  TextEditingController paidController = TextEditingController();

  List<ItemsTable> items = [];
  List<String> standardItemsNames = [];
  List<PaymentScheduleTable> paymentSchedule = [];
  List<GridColumn> itemColumns = [];
  List<GridColumn> paymentScheduleColumns = [];
  late ItemsDataSource itemsDataSource;
  late PaymentScheduleDataSource paymentScheduleDataSource;
  Timer? _timer;

  var prefs = sl<SharedPreferenceModule>();

  var isEditable = false;

  List<ItemsTable> getItems() {
    logger.i(widget.itemItems);
    return widget.itemItems!
        .map((e) => ItemsTable(
              id: e.id!,
              items: e.description!,
              quantity: e.quantity!,
              price: e.grossPrice!.toDouble(),
              total: e.total!.toDouble(),
              vat: e.taxRate is double
                  ? (e.taxRate! * 100).toInt()
                  : e.taxRate! * 100,
            ))
        .toList();
  }

  List<PaymentScheduleTable> getPaymentSchedule() {
    return widget.paymentSchedules!
        .map((e) => PaymentScheduleTable(
              id: e.id,
              date: DateTime.tryParse(e.dueDate!),
              due: e.dueAmount?.toDouble(),
              paid: e.paidAmount?.toDouble(),
              remaining: 0,
            ))
        .toList();
  }

  List<GridColumn> getItemsGridColumn() {
    return [
      GridColumn(
        columnName: 'items',
        minimumWidth: 200,
        label: Container(
          color: PrimaryColors.primaryPurple,
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            'Items',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: CustomFontSize.medium,
                color: SecondaryColors.secondaryPurple.withOpacity(0.7)),
          ),
        ),
      ),
      GridColumn(
        columnName: 'quantity',
        label: Container(
          color: PrimaryColors.primaryPurple,
          padding: const EdgeInsets.all(0.0),
          alignment: Alignment.center,
          child: Text(
            '#',
            style: TextStyle(
                fontSize: CustomFontSize.medium,
                color: SecondaryColors.secondaryPurple.withOpacity(0.7)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'price',
        label: Container(
          color: PrimaryColors.primaryPurple,
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            'Price',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: CustomFontSize.medium,
                color: SecondaryColors.secondaryPurple.withOpacity(0.7)),
          ),
        ),
      ),
      GridColumn(
        columnName: 'total',
        allowEditing: false,
        label: Container(
          color: PrimaryColors.primaryPurple,
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            'Total',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: CustomFontSize.medium,
                color: SecondaryColors.secondaryPurple.withOpacity(0.7)),
          ),
        ),
      ),
      GridColumn(
        columnName: 'vat',
        label: Container(
          color: PrimaryColors.primaryPurple,
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            'VAT',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: CustomFontSize.medium,
                color: SecondaryColors.secondaryPurple.withOpacity(0.7)),
          ),
        ),
      ),
    ];
  }

  List<GridColumn> getPaymentScheduleGridColumn() {
    return [
      GridColumn(
        columnName: 'date',
        minimumWidth: 200,
        columnWidthMode: ColumnWidthMode.fill,
        label: Container(
          color: PrimaryColors.primaryPurple,
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            'Due Date',
            style: TextStyle(
                fontSize: CustomFontSize.medium,
                color: SecondaryColors.secondaryPurple.withOpacity(0.7)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'due',
        label: Container(
          color: PrimaryColors.primaryPurple,
          // padding: const EdgeInsets.all(0.0),
          alignment: Alignment.center,
          child: Text(
            'Due',
            style: TextStyle(
                fontSize: CustomFontSize.medium,
                color: SecondaryColors.secondaryPurple.withOpacity(0.7)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'paid',
        allowEditing: false,
        label: Container(
          color: PrimaryColors.primaryPurple,
          // padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            'Paid',
            style: TextStyle(
                fontSize: CustomFontSize.medium,
                color: SecondaryColors.secondaryPurple.withOpacity(0.7)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'remaining',
        minimumWidth: 150,
        allowEditing: false,
        label: Container(
          color: PrimaryColors.primaryPurple,
          // padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(
            'Remaining',
            style: TextStyle(
                fontSize: CustomFontSize.medium,
                color: SecondaryColors.secondaryPurple.withOpacity(0.7)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ];
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.paymentSchedules != null) {
      paymentSchedule = getPaymentSchedule();
    }
    if (widget.itemItems != null) {
      items = getItems();
    }
    if (widget.itemItems == null || widget.itemItems!.isEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (widget.invoiceTableType == InvoiceTableType.ITEMS) {
            itemsDataSource.rows.add(DataGridRow(cells: [
              DataGridCell<String>(columnName: 'items', value: 'New item name'),
              DataGridCell<String>(columnName: 'quantity', value: '0'),
              DataGridCell<String>(columnName: 'price', value: '0'),
              DataGridCell<String>(columnName: 'total', value: '0'),
              DataGridCell<String>(columnName: 'vat', value: '0 %'),
            ]));
            itemsDataSource.buildRow(itemsDataSource.rows.last);
          }
        });
      });
    }
    if (widget.paymentSchedules == null || widget.paymentSchedules!.isEmpty) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (widget.invoiceTableType == InvoiceTableType.PAYMENT_SCHEDULE) {
            paymentScheduleDataSource.rows.add(DataGridRow(cells: [
              DataGridCell<String>(columnName: 'date', value: 'New date'),
              DataGridCell<String>(columnName: 'due', value: '0'),
              DataGridCell<String>(columnName: 'paid', value: '0'),
              DataGridCell<String>(columnName: 'remaining', value: '0'),
            ]));
            paymentScheduleDataSource
                .buildRow(paymentScheduleDataSource.rows.last);
          }
        });
      });
    }
    itemColumns = getItemsGridColumn();
    paymentScheduleColumns = getPaymentScheduleGridColumn();
    itemsDataSource = ItemsDataSource(items);
    paymentScheduleDataSource = PaymentScheduleDataSource(paymentSchedule);
    if (widget.invoiceTableType == InvoiceTableType.ITEMS && mounted) {
      widget.savedItems!(itemsDataSource.savedItem());
    }
    if (widget.invoiceTableType == InvoiceTableType.PAYMENT_SCHEDULE &&
        mounted) {
      widget.savedPaymentSchedules!(
          paymentScheduleDataSource.savedPaymentSchedule());
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (widget.invoiceTableType == InvoiceTableType.ITEMS && mounted) {
        widget.savedItems!(itemsDataSource.savedItem());
      }
      if (widget.invoiceTableType == InvoiceTableType.PAYMENT_SCHEDULE &&
          mounted) {
        widget.savedPaymentSchedules!(
            paymentScheduleDataSource.savedPaymentSchedule());
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var space = prefs.getSpaces().first;
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 20),
        _buildDataGrid(),
        _buildTotalPrice(space.currency ?? "GHS"),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildHeaderTitle(),
        const Spacer(),
        _buildAddButton(),
      ],
    );
  }

  Widget _buildHeaderTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.invoiceTableType == InvoiceTableType.ITEMS
              ? "Items"
              : "Payment Schedule",
          style: TextStyle(
            color: TertiaryColors.tertiaryPurple,
            fontSize: CustomFontSize.medium,
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              isEditable = !isEditable;
            });
          },
          icon: Icon(
            Icons.edit,
            color: TertiaryColors.tertiaryPurple,
            size: 20,
          ),
        )
      ],
    );
  }

  Widget _buildAddButton() {
    return widget.invoiceTableType == InvoiceTableType.ITEMS
        ? FloatingActionButton.extended(
            key: widget.invoiceTableType == InvoiceTableType.ITEMS
                ? const Key("add-standard-item")
                : const Key("add-payment-schedule"),
            heroTag: widget.invoiceTableType == InvoiceTableType.ITEMS
                ? "add-standard-item"
                : "add-payment-schedule",
            onPressed: () async {
              List<ItemFee>? result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectFee(
                    selectedFees: itemsDataSource.rows
                        .map(
                          (e) => ItemFee(
                            name: e.getCells()[0].value.toString(),
                            price: double.parse(
                              e.getCells()[2].value.toString(),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
              if (result == null) return;
              // logger.wtf(result.map((e) => '${e.name} ${e.isSelected}').toList());
              if (result.isNotEmpty) {
                itemsDataSource.rows.removeWhere(
                    (e) => (e.getCells()[0].value == "New item name"));

                List<ItemFee> toRemove = result.where((element) => !element.isSelected).toList();
                toRemove.removeWhere((e) => !itemsDataSource.rows.any((row) => row.getCells()[0].value?.trim() == e.name?.trim()));
                List<ItemFee> toAdd = result.where((element) => element.isSelected).toList();
                toAdd.removeWhere((e) => itemsDataSource.rows.any((row) => row.getCells()[0].value?.trim() == e.name?.trim()));

                // print('REMOVE: ${toRemove.map((e) => e.name).toList().join(', ')}');
                itemsDataSource.rows.removeWhere((row) => toRemove.any((e) => e.name?.trim() == row.getCells()[0].value.toString().trim()));

                // print('ADD: ${toAdd.map((e) => e.name).toList().join(', ')}');
                itemsDataSource.rows
                    .addAll(toAdd.map((e) => DataGridRow(cells: [
                          DataGridCell<String>(
                              columnName: 'items', value: e.name),
                          DataGridCell<String>(
                              columnName: 'quantity', value: '1'),
                          DataGridCell<String>(
                              columnName: 'price', value: '${e.price}'),
                          DataGridCell<String>(
                              columnName: 'total', value: '${e.price}'),
                          DataGridCell<String>(columnName: 'vat', value: '0 %'),
                        ])));
                setState(() {});
              }
            },
            label: Text("Add std item",
                style: TextStyle(
                  color: TertiaryColors.tertiaryPurple,
                  fontSize: CustomFontSize.small,
                )),
            backgroundColor: PrimaryColors.primaryPurple,
          )
        : const SizedBox();
  }

  Widget _buildDataGrid() {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: double.infinity,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isEditable ? _buildEditableData() : Container(height: 0),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDataGridContainer(),
                _buildAddNewRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddNewRow() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: PrimaryColors.primaryPurple,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          side: BorderSide(color: SecondaryColors.secondaryPurple, width: 1.5),
        ),
        minimumSize: Size(widget.isEditable ? 350 : double.infinity, 50),
      ),
      onPressed: () {
        // Add empty row to the data source.
        setState(() {
          if (widget.invoiceTableType == InvoiceTableType.ITEMS) {
            itemsDataSource.rows.add(DataGridRow(cells: [
              DataGridCell<String>(columnName: 'items', value: 'New item name'),
              DataGridCell<String>(columnName: 'quantity', value: '0'),
              DataGridCell<String>(columnName: 'price', value: '0'),
              DataGridCell<String>(columnName: 'total', value: '0'),
              DataGridCell<String>(columnName: 'vat', value: '0 %'),
            ]));
            itemsDataSource.buildRow(itemsDataSource.rows.last);
          } else {
            paymentScheduleDataSource.rows.add(DataGridRow(cells: [
              DataGridCell<String>(columnName: 'date', value: 'New date'),
              DataGridCell<String>(columnName: 'due', value: '0'),
              DataGridCell<String>(columnName: 'paid', value: '0'),
              DataGridCell<String>(columnName: 'remaining', value: '0'),
            ]));
            paymentScheduleDataSource
                .buildRow(paymentScheduleDataSource.rows.last);
          }
        });
      },
      child: Icon(
        Icons.add,
        color: SecondaryColors.secondaryPurple,
      ),
    );
  }

  Widget _buildEditableData() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...widget.invoiceTableType == InvoiceTableType.ITEMS
            ? itemsDataSource.rows
                .map((e) => SizedBox(
                      height: 55,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            itemsDataSource.rows.remove(e);
                            widget.savedItems!(itemsDataSource.savedItem());
                          });
                        },
                        icon: Icon(
                          Icons.delete,
                          color: SecondaryColors.secondaryPurple,
                        ),
                      ),
                    ))
                .toList()
            : paymentScheduleDataSource.rows
                .map((e) => SizedBox(
                      height: 55,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            paymentScheduleDataSource.rows.remove(e);
                            widget.savedPaymentSchedules!(
                                paymentScheduleDataSource
                                    .savedPaymentSchedule());
                          });
                        },
                        icon: Icon(
                          Icons.delete,
                          color: SecondaryColors.secondaryPurple,
                        ),
                      ),
                    ))
                .toList(),
      ],
    );
  }

  Widget _buildDataGridContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        border: Border.all(color: SecondaryColors.secondaryPurple, width: 1.5),
      ),
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: double.infinity,
        ),
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: SfDataGridTheme(
          data: SfDataGridThemeData(
            gridLineColor: SecondaryColors.secondaryPurple,
            gridLineStrokeWidth: 0.5,
          ),
          child: SfDataGrid(
            allowEditing: true,
            selectionMode: SelectionMode.single,
            navigationMode: GridNavigationMode.cell,
            editingGestureType: EditingGestureType.tap,
            // rowHeight: 55,
            shrinkWrapRows: true,
            // columnWidthMode: ColumnWidthMode.fitByCellValue,
            source: widget.invoiceTableType == InvoiceTableType.ITEMS
                ? itemsDataSource
                : paymentScheduleDataSource,
            columns: widget.invoiceTableType == InvoiceTableType.ITEMS
                ? itemColumns
                : paymentScheduleColumns,
            gridLinesVisibility: GridLinesVisibility.both,
            headerGridLinesVisibility: GridLinesVisibility.both,
          ),
        ),
      ),
    );
  }

  Widget _buildTotalPrice(String currency) {
    return widget.invoiceTableType == InvoiceTableType.ITEMS
        ? Row(
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "$currency ",
                      style: TextStyle(
                        color: TertiaryColors.tertiaryPurple,
                        fontSize: CustomFontSize.medium,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      itemsDataSource.rows.isNotEmpty
                          ? itemsDataSource.rows
                              .map((e) => double.parse(
                                  e.getCells()[3].value.toString()))
                              .toList()
                              .reduce((value, element) => value + element)
                              .toString()
                          : '0.0',
                      style: TextStyle(
                        color: SecondaryColors.secondaryPurple,
                        fontSize: CustomFontSize.medium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : const SizedBox();
  }
}
