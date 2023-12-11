import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/getwidget.dart';
import 'package:seymo_pay_mobile_application/data/auth/model/auth_request.dart';
import 'package:seymo_pay_mobile_application/data/constants/logger.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/login.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/invoice/invoice_list/invoice_details.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/navigation.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../../../data/constants/shared_prefs.dart';
import '../../../../../data/invoice/model/invoice_model.dart';
import '../../../../utilities/colors.dart';
import '../../../../widgets/cards/invoice_card.dart';
import '../../../../widgets/inputs/text_field.dart';
import '../../../auth/auth_bloc/auth_bloc.dart';
import '../bloc/invoice_bloc.dart';

var sl = GetIt.instance;

class InvoiceList extends StatefulWidget {
  const InvoiceList({super.key});

  @override
  State<InvoiceList> createState() => _InvoiceListState();
}

class _InvoiceListState extends State<InvoiceList> {
  bool isCurrentPage = true;
  final TextEditingController searchController = TextEditingController();
  var prefs = sl<SharedPreferenceModule>();
  List<InvoiceModel> invoices = [];
  List<bool> isToggleOptionSelected = [true, false, false, false];
  List<Widget> toggleOptions = [
    const Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Text("All"),
    ),
    const Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Text("By student"),
    ),
    const Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Text("By recipient"),
    ),
    const Padding(
      padding: EdgeInsets.symmetric(horizontal: 18),
      child: Text("By month"),
    ),
  ];
  void updateToggleOptionSelected(int index) {
    setState(() {
      for (int i = 0; i < isToggleOptionSelected.length; i++) {
        if (i == index) {
          isToggleOptionSelected[i] = true;
        } else {
          isToggleOptionSelected[i] = false;
        }
      }
    });
  }

  // Get All Invoices
  void _getAllInvoices() {
    context.read<InvoiceBloc>().add(const InvoiceEventGetAllInvoices());
  }

  // Refresh Tokens
  void _refreshToken() {
    var token = prefs.getToken();
    if (token == null) return;
    context
        .read<AuthBloc>()
        .add(AuthEventRefresh(RefreshRequest(refresh: token.refreshToken)));
  }

  // Handle Invoice State Changes
  void _handleInvoiceStateChanges(BuildContext context, InvoiceState state) {
    if (state.status == InvoiceStateStatus.success) {
      setState(() {
        invoices = state.invoices!;
      });
    } else if (state.status == InvoiceStateStatus.error) {
      if (state.errorMessage!.contains("Unauthorized")) {
        _refreshToken();
      } else {
        GFToast.showToast(
          "Error: ${state.errorMessage}",
          context,
          toastPosition: GFToastPosition.BOTTOM,
          toastDuration: 6,
          toastBorderRadius: 12.0,
          backgroundColor: Colors.red,
        );
      }
    }
  }

  // Handle Refresh State Changes
  void _handleRefreshStateChanges(BuildContext context, AuthState state) {
    if (state.status == AuthStateStatus.authenticated) {
      _getAllInvoices();
    } else if (state.status == InvoiceStateStatus.error) {
      // Handle Error
      _handleLogout();
    }
  }

  // Handle Logout
  void _handleLogout() {
    prefs.clear();
    nextScreenAndRemoveAll(context: context, screen: LoginScreen());
  }

  @override
  void initState() {
    // TODO: implement initState
    // Get Invoices from Shared Preference
    // invoices = prefs.getInvoice();
    _getAllInvoices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: const Key("invoice_list"),
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.5) {
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
        listener: (context, state) {
          // TODO: implement listener
          if (isCurrentPage && mounted) {
            _handleInvoiceStateChanges(context, state);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: BackgroundColors.bgPurple,
            appBar: _buildAppBar(context),
            body: state.isLoading
                ? const Center(
                    child: GFLoader(
                      type: GFLoaderType.ios,
                    ),
                  )
                : invoices.isNotEmpty
                    ? ListView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        children: [
                          ...invoices.map(
                            (element) => GestureDetector(
                              onTap: () {
                                if (element.isDraft) {
                                  nextScreen(
                                    context: context,
                                    screen: InvoiceDetails(
                                        invoiceType: InvoiceType.EDIT),
                                  );
                                }
                              },
                              child: InvoiceCard(
                                name: "Diana Antonova",
                                date: element.invoiceDate,
                                amount: element.totalAmount.toString(),
                                currency: element.currency,
                                isVoid: element.isVoid,
                                isPaid: element.isPaid,
                                isDraft: element.isDraft,
                              ),
                            ),
                          ),
                        ],
                      )
                    : null,
          );
        },
      ),
    );
  }

  // AppBar
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: PrimaryColors.primaryPurple,
      title: const Text("Invoice list"),
      centerTitle: true,
      actions: [
        // AuthBloc Listener
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            _handleRefreshStateChanges(context, state);
          },
          child: Container(),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add_rounded),
        ),
      ],
      bottom: _buildPreferredSizeWidget(context),
    );
  }

  // PreferredSize Widget
  PreferredSizeWidget _buildPreferredSizeWidget(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(170),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            _buildToggleButtonOptions(context),
            const SizedBox(height: 20),
            _buildSearchBar()
          ],
        ),
      ),
    );
  }

  // Search Bar
  Widget _buildSearchBar() {
    return CustomTextField(
      hintText: "Search",
      controller: searchController,
      color: Colors.purple,
    );
  }

  // Toggle Button Options
  Widget _buildToggleButtonOptions(BuildContext context) {
    return ToggleButtons(
      color: SecondaryColors.secondaryPurple,
      selectedColor: Colors.white,
      fillColor: SecondaryColors.secondaryPurple,
      isSelected: isToggleOptionSelected,
      borderRadius: BorderRadius.circular(50),
      onPressed: updateToggleOptionSelected,
      children: toggleOptions,
    );
  }

  // Invoice Card
  // Widget _buildInvoiceCard() {
  //   return InvoiceCard();
  // }
}
