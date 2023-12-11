import 'package:flutter/cupertino.dart';
import 'package:seymo_pay_mobile_application/data/constants/logger.dart';
import 'package:seymo_pay_mobile_application/data/invoice/model/invoice_model.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/invoice/item_data_source.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/invoice/payment_schedule_data_source.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

enum InvoiceTableType { ITEMS, PAYMENT_SCHEDULE }

class InvoiceTable extends StatefulWidget {
  final InvoiceTableType invoiceTableType;
  final List<InvoiceItemModel>? itemItems;
  final List<PaymentScheduleModel>? paymentSchedules;
  const InvoiceTable({super.key, required this.invoiceTableType, this.itemItems, this.paymentSchedules});

  @override
  State<InvoiceTable> createState() => _InvoiceTableState();
}

class _InvoiceTableState extends State<InvoiceTable> {
  List<ItemsTable> items = [];
  List<PaymentScheduleTable> paymentSchedule = [];
  List<GridColumn> itemColumns = [];
  List<GridColumn> paymentScheduleColumns = [];
  late ItemsDataSource itemsDataSource;
  late PaymentScheduleDataSource paymentScheduleDataSource;

  List<ItemsTable> getItems() {
    return [
      ItemsTable(
        id: 1,
        items: "Item 1",
        quantity: 1,
        price: 100,
        total: 100,
      ),
      ItemsTable(
        id: 2,
        items: "Item 2",
        quantity: 2,
        price: 200,
        total: 400,
      ),
      ItemsTable(
        id: 3,
        items: "Item 3",
        quantity: 3,
        price: 300,
        total: 900,
      ),
    ];
  }

  List<PaymentScheduleTable> getPaymentSchedule() {
    return [
      PaymentScheduleTable(
        id: 1,
        date: DateTime.now().toIso8601String(),
        due: 100,
        paid: 100,
      ),
      PaymentScheduleTable(
        id: 2,
        date: DateTime.now().toIso8601String(),
        due: 200,
        paid: 200,
      ),
      PaymentScheduleTable(
        id: 3,
        date: DateTime.now().toIso8601String(),
        due: 300,
        paid: 300,
      ),
    ];
  }

  List<GridColumn> getItemsGridColumn() {
    return [
      GridColumn(
        columnName: 'items',
        label: Container(
          color: PrimaryColors.primaryPurple,
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: const Text(
            'Items',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'quantity',
        label: Container(
          color: PrimaryColors.primaryPurple,
          padding: const EdgeInsets.all(0.0),
          alignment: Alignment.center,
          child: const Text(
            '#',
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
          child: const Text(
            'Price',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'total',
        label: Container(
          color: PrimaryColors.primaryPurple,
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: const Text(
            'Total',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ];
  }

  List<GridColumn> getPaymentScheduleGridColumn() {
    return [
      GridColumn(
        columnName: 'date',
        label: Container(
          color: PrimaryColors.primaryPurple,
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: const Text(
            'Date',
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
          child: const Text(
            'Due',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      GridColumn(
        columnName: 'paid',
        label: Container(
          color: PrimaryColors.primaryPurple,
          // padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: const Text(
            'Paid',
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ];
  }

  @override
  void initState() {
    // TODO: implement initState
    items = getItems();
    itemColumns = getItemsGridColumn();
    paymentSchedule = getPaymentSchedule();
    paymentScheduleColumns = getPaymentScheduleGridColumn();
    itemsDataSource = ItemsDataSource(items);
    paymentScheduleDataSource = PaymentScheduleDataSource(paymentSchedule);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfDataGrid(
      verticalScrollPhysics: const NeverScrollableScrollPhysics(),
      footerHeight: 0,
      columnWidthMode: ColumnWidthMode.fill,
      source: widget.invoiceTableType == InvoiceTableType.ITEMS
          ? itemsDataSource
          : paymentScheduleDataSource,
      columns: widget.invoiceTableType == InvoiceTableType.ITEMS
          ? itemColumns
          : paymentScheduleColumns,
      gridLinesVisibility: GridLinesVisibility.both,
      headerGridLinesVisibility: GridLinesVisibility.both,
    );
  }
}
