import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:seymo_pay_mobile_application/data/invoice/model/invoice_request.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/buttons/default_btn.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/cards/invoice_card.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../utilities/colors.dart';
import '../../../../utilities/navigation.dart';
import '../../../home/homepage.dart';
import '../bloc/invoice_bloc.dart';
import '../invoice_list/invoice_list.dart';

class BatchInvoicePreview extends StatefulWidget {
  final List<BatchInvoiceItem> batchInvoiceItems;
  const BatchInvoicePreview({super.key, required this.batchInvoiceItems});

  @override
  State<BatchInvoicePreview> createState() => _BatchInvoicePreviewState();
}

class _BatchInvoicePreviewState extends State<BatchInvoicePreview> {
  bool saveDaft = false;
  bool isCurrentPage = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(context),
      bottomNavigationBar: buildBottomBar(context),
    );
  }

  // Save as Draft
  void saveAsDraft(List<InvoiceCreateRequest> invoiceCreateRequests) {
    setState(() {
      saveDaft = true;
    });
    // invoiceCreateRequests
    //     .map((e) => {
    //           e..isDraft = true,
    //           BlocProvider.of<InvoiceBloc>(context)
    //               .add(InvoiceEventCreateInvoice(e))
    //         })
    //     .toList();
    BlocProvider.of<InvoiceBloc>(context).add(
      InvoiceEventCreateInvoice(invoiceCreateRequests),
    );
  }

  // Commit
  void commit(List<InvoiceCreateRequest> invoiceCreateRequests) {
    setState(() {
      saveDaft = false;
    });
    // invoiceCreateRequests
    //     .map((e) => {
    //           // e..isDraft = false,
    //           // BlocProvider.of<InvoiceBloc>(context)
    //           //     .add(InvoiceEventCreateInvoice(e))
    //         })
    //     .toList();

    BlocProvider.of<InvoiceBloc>(context).add(
      InvoiceEventCreateInvoice(invoiceCreateRequests),
    );
  }

  // Handle Invoice State Change
  void handleInvoiceStateChange(BuildContext context, InvoiceState state) {
    if (state.invoiceResponse != null &&
        state.invoiceResponse!.isSuccess != null &&
        state.invoiceResponse!.isSuccess!) {
      GFToast.showToast(
        state.successMessage ?? "Invoice created successfully",
        context,
        toastPosition: GFToastPosition.BOTTOM,
        toastDuration: 5,
        backgroundColor: Colors.green,
        toastBorderRadius: 12.0,
      );
      nextScreenAndRemoveAll(context: context, screen: const HomePage());
      nextScreen(context: context, screen: const InvoiceList());
    }
    if (state.invoiceResponse != null &&
        state.invoiceResponse!.isSuccess != null &&
        !state.invoiceResponse!.isSuccess!) {
      GFToast.showToast(
        state.invoiceResponse!.errorMessage,
        context,
        toastPosition: GFToastPosition.BOTTOM,
        toastDuration: 5,
        backgroundColor: Colors.red,
        toastBorderRadius: 12.0,
      );
    }
    if (state.status == InvoiceStateStatus.success) {
      GFToast.showToast(
        state.successMessage ?? "Invoice created successfully",
        context,
        toastPosition: GFToastPosition.BOTTOM,
        toastDuration: 5,
        backgroundColor: Colors.green,
        toastBorderRadius: 12.0,
      );
      nextScreenAndRemoveAll(context: context, screen: const HomePage());
      nextScreen(context: context, screen: const InvoiceList());
    }
    if (state.status == InvoiceStateStatus.error) {
      GFToast.showToast(
        state.errorMessage ?? "Network Error",
        context,
        toastPosition: GFToastPosition.BOTTOM,
        toastDuration: 5,
        backgroundColor: Colors.red,
        toastBorderRadius: 12.0,
      );
    }
  }

  // Build App Bar
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: PrimaryColors.primaryPurple,
      iconTheme: IconThemeData(
        color: SecondaryColors.secondaryPurple,
      ),
      elevation: 0,
      title: Text(
        "Batch Invoice Preview",
        style: TextStyle(color: SecondaryColors.secondaryPurple),
      ),
    );
  }

  // Build Body
  Widget buildBody(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      children: [
        ...widget.batchInvoiceItems
            .map((e) => Column(
                  children: [
                    InvoiceCard(
                      name: e.studentName,
                      date: e.newInvoices != null
                          ? e.newInvoices!.invoiceDate
                          : e.updateInvoices!.invoiceDate,
                      amount: e.newInvoices != null
                          ? e.newInvoices!.totalAmount.toString()
                          : e.updateInvoices!.totalAmount.toString(),
                      currency: e.newInvoices != null
                          ? e.newInvoices!.currency
                          : e.updateInvoices!.currency,
                      isDraft: e.newInvoices != null
                          ? e.newInvoices!.isDraft
                          : e.updateInvoices!.isDraft,
                      paidAmount: 0,
                      isPaid: false,
                      isVoid: false,
                    ),
                    const SizedBox(height: 12.0),
                  ],
                ))
            .toList(),
      ],
    );
  }

  // Build Bottom Bar
  Widget buildBottomBar(BuildContext context) {
    return VisibilityDetector(
      key: Key("batch-invoice-preview"),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction == 1.0) {
          setState(() {
            isCurrentPage = true;
          });
        } else {
          setState(() {
            isCurrentPage = false;
          });
        }
      },
      child: BlocConsumer<InvoiceBloc, InvoiceState>(
        listenWhen: (prev, current) => isCurrentPage && mounted,
        listener: (context, state) {
          // TODO: implement listener
          handleInvoiceStateChange(context, state);
        },
        builder: (context, state) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DefaultBtn(
                  isLoading: saveDaft ? state.isLoading : false,
                  key: const Key("save-batch-as-draft"),
                  text: "Save as Draft",
                  btnColor: LightInvoiceColors.medium,
                  textColor: Colors.white,
                  onPressed: () {
                    saveAsDraft(widget.batchInvoiceItems
                        .map((e) => e.newInvoices!..isDraft = true)
                        .toList());
                  },
                ),
                DefaultBtn(
                  isLoading: saveDaft ? false : state.isLoading,
                  key: const Key("commit-batch-invoice"),
                  text: "Commit",
                  btnColor: LightInvoiceColors.dark,
                  textColor: Colors.white,
                  onPressed: () {
                    commit(widget.batchInvoiceItems
                        .map((e) => e.newInvoices!..isDraft = false)
                        .toList());
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class BatchInvoiceItem {
  final String studentName;
  final String parentName;
  final InvoiceCreateRequest? newInvoices;
  final InvoiceUpdateRequest? updateInvoices;

  const BatchInvoiceItem({
    required this.studentName,
    required this.parentName,
    this.newInvoices,
    this.updateInvoices,
  });
}
