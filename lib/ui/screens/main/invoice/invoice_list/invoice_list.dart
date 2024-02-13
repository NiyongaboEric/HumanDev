import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/getwidget.dart';
import 'package:seymo_pay_mobile_application/data/auth/model/auth_request.dart';
import 'package:seymo_pay_mobile_application/data/person/model/person_model.dart';
import 'package:seymo_pay_mobile_application/data/person/model/person_model.dart';
import 'package:seymo_pay_mobile_application/ui/screens/auth/login.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/invoice/invoice_list/invoice_details.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/invoice/student_invoice/people_list.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/person/bloc/person_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/font_sizes.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/invoice/student_invoice/people_list.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/person/bloc/person_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/font_sizes.dart';
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
  List<PersonModel> persons = [];
  List<bool> isToggleOptionSelected = [true, false, false, false];
  List<Widget> toggleOptions = [
    const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text("All"),
    ),
    const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text("By student"),
    ),
    const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text("By recipient"),
    ),
    const Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
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

  // Get All Persons
  void _getAllPersons() {
    context.read<PersonBloc>().add(const GetAllPersonEvent());
  }

  // Handle Invoice State Changes
  void _handleInvoiceStateChanges(BuildContext context, InvoiceState state) {
    if (state.status == InvoiceStateStatus.success) {
      setState(() {
        invoices = state.invoices!;
      });
      _getAllPersons();
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
    } else if (state.status == AuthStateStatus.unauthenticated) {
      // Handle Error
      _handleLogout();
    }
  }

  // Handle Person State Changes
  void _handlePersonStateChanges(BuildContext context, PersonState state) {
    if (state.status == PersonStatus.success) {
      if (invoices.isEmpty) return;
      // Handle Success
      for (var person in state.persons) {
        // Match person with invoice
        for (var invoice in invoices) {
          if (invoice.studentPersonId == person.id) {
            setState(() {
              persons.add(person);
            });
          }
        }
      }
    } else if (state.status == PersonStatus.error) {
      // Handle Error
    }
  }

  // Handle Logout
  void _handleLogout() {
    prefs.clear();
    nextScreenAndRemoveAll(context: context, screen: const LoginScreen());
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
        if (mounted) {
          if (visibilityInfo.visibleFraction > 0.5) {
            setState(() {
              isCurrentPage = true;
            });
          } else {
            setState(() {
              isCurrentPage = false;
            });
          }
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
                  : invoices.isNotEmpty || persons.isNotEmpty
                      ? ListView(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          children: [
                            ...invoices.map(
                              (element) => Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      if (element.isDraft) {
                                        bool reFetch = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    InvoiceDetails(
                                                  key: const Key(
                                                      "invoice_details_edit"),
                                                  invoiceType: InvoiceType.EDIT,
                                                  invoice: element,
                                                  person: persons.isNotEmpty
                                                      ? persons.firstWhere(
                                                          (each) =>
                                                              each.id ==
                                                              element
                                                                  .studentPersonId)
                                                      : null,
                                                ),
                                              ),
                                            ) ??
                                            false;
                                        if (reFetch) {
                                          _getAllInvoices();
                                        }
                                        // nextScreen(
                                        //   context: context,
                                        //   screen: InvoiceDetails(
                                        //     key: const Key("invoice_details_edit"),
                                        //     invoiceType: InvoiceType.EDIT,
                                        //     invoice: element,
                                        //     person: persons.isNotEmpty
                                        //         ? persons.firstWhere((each) =>
                                        //             each.id ==
                                        //             element.studentPersonId)
                                        //         : null,
                                        //   ),
                                        // );
                                      }
                                    },
                                    child: InvoiceCard(
                                      name: persons.isNotEmpty
                                          ? "${persons.firstWhere((each) => each.id == element.studentPersonId).firstName} ${persons.firstWhere((each) => each.id == element.studentPersonId).lastName1}"
                                          : "",
                                      date: element.invoiceDate,
                                      amount: element.totalAmount.toString(),
                                      currency: element.currency,
                                      isVoid: element.isVoid,
                                      isPaid: element.isPaid,
                                      isDraft: element.isDraft,
                                      // paidAmount: element.paymentSchedules!
                                      //     .map((e) => e.paidAmount)
                                      //     .reduce(
                                      //         (value, val) => value! + val!),
                                      invoiceNumber: element.number,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: Text(
                            "No invoices found",
                            style: TextStyle(
                              fontSize: CustomFontSize.medium,
                              color: SecondaryColors.secondaryPurple,
                            ),
                          ),
                        ));
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
            if (isCurrentPage && mounted) {
              _handleRefreshStateChanges(context, state);
            }
          },
          child: Container(),
        ),
        BlocListener<PersonBloc, PersonState>(
          listener: (context, state) {
            if (isCurrentPage && mounted) {
              _handlePersonStateChanges(context, state);
            }
          },
          child: Container(),
        ),
        IconButton(
          onPressed: () {
            nextScreen(
                context: context,
                screen: const PeopleListInvoice(
                ));
          },
          icon: const Icon(
            Icons.add_rounded,
            size: 28,
          ),
        ),
      ],
      bottom: _buildPreferredSizeWidget(context),
    );
  }

  // PreferredSize Widget
  PreferredSizeWidget _buildPreferredSizeWidget(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(150),
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
      prefixIcon: Icon(
        Icons.search_rounded,
        color: SecondaryColors.secondaryPurple,
      ),
      hintText: "Search",
      controller: searchController,
      color: SecondaryColors.secondaryPurple,
    );
  }

  // Toggle Button Options
  Widget _buildToggleButtonOptions(BuildContext context) {
    return ToggleButtons(
      textStyle: const TextStyle(
        fontSize: CustomFontSize.small,
      ),
      color: SecondaryColors.secondaryPurple,
      selectedColor: Colors.white,
      fillColor: LightInvoiceColors.dark,
      isSelected: isToggleOptionSelected,
      borderRadius: BorderRadius.circular(50),
      onPressed: updateToggleOptionSelected,
      children: toggleOptions,
    );
  }
}
