import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:getwidget/getwidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:seymo_pay_mobile_application/data/auth/model/auth_request.dart';
import 'package:seymo_pay_mobile_application/data/auth/model/auth_response.dart';
import 'package:seymo_pay_mobile_application/data/constants/logger.dart';
import 'package:seymo_pay_mobile_application/data/constants/shared_prefs.dart';
import 'package:seymo_pay_mobile_application/data/journal/model/journal_model.dart';
import 'package:seymo_pay_mobile_application/data/person/model/person_model.dart';
import 'package:seymo_pay_mobile_application/ui/screens/main/transaction_records/bloc/journal_bloc.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/colors.dart';
import 'package:seymo_pay_mobile_application/ui/utilities/font_sizes.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/cards/disposable_card.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/constants/upload_card_model.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/default_tag_buttons.dart';
import 'package:seymo_pay_mobile_application/ui/widgets/inputs/text_field.dart';

import '../../../../utilities/custom_colors.dart';
import '../../../../utilities/navigation.dart';
import '../../../../widgets/cards/upload_card.dart';
import '../../../auth/auth_bloc/auth_bloc.dart';
import '../../../auth/login.dart';
import 'recipient.dart';

var sl = GetIt.instance;

var prefs = sl<SharedPreferenceModule>();

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  TextEditingController descriptionController = TextEditingController();
  bool rep = true;
  final List<XFile> _images = [];
  bool previewState = false;
  Widget? previewWidget;
  List<DefaultTagsSettings> tags = [];
  List<DefaultTagsSettings> selectedTags = [];
  bool logout = false;

  _imgFromCamera() async {
    XFile? image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (image != null) {
      setState(() {
        _images.add(image);
      });
    }
  }

  _imgFromGallery() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        XFile file = XFile(result.files.single.path!);
        _images.add(file);
      });
    }
  }

  bool imageMatch(File imageFile) {
    return imageFile.existsSync() &&
        RegExp(r'\.(jpeg|jpg|png|gif|bmp|webp)').hasMatch(
          imageFile.path.toLowerCase(),
        );
  }

  // Add To tag List
  void _addTag(DefaultTagsSettings text) {
    setState(() {
      tags.add(text);
    });
    // Save List of tags to SharedPreferences
    // prefs.setString("tags", json.encode(tags));
  }

  // Remove Tag From List
  void _removeTag(DefaultTagsSettings text) {
    setState(() {
      tags.remove(text);
    });
    // Save List of tags to SharedPreferences
    // prefs.setString("tags", json.encode(tags));
  }

// Refresh Tokens
  void _refreshTokens() {
    TokenResponse? token = prefs.getToken();
    if (token != null) {
      context.read<AuthBloc>().add(AuthEventRefresh(RefreshRequest(refresh:token.refreshToken)));
    }
  }

  // Logout
  void _logout() {
    context.read<AuthBloc>().add(AuthEventLogout());
  }

  // Handle Paid Money State Change
  void _handleJournalStateChange(BuildContext context, JournalState state) {
    if (state.status == JournalStatus.success) {
      nextScreen(context: context, screen: const Recipient());
    }
    if (state.status == JournalStatus.error) {
      logger.e(state.errorMessage);
    }
  }

    // Handle Get User Data State Change
  void _handleRefreshStateChange(BuildContext context, AuthState state) {
    // var prefs = sl<SharedPreferenceModule>();
    if (logout) {
      return;
    }
    if (state.status == AuthStateStatus.authenticated) {
      // navigate(context, state);
      if (state.refreshFailure != null) {
        GFToast.showToast(
          state.refreshFailure,
          context,
          toastBorderRadius: 8.0,
          toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
              ? GFToastPosition.TOP
              : GFToastPosition.BOTTOM,
          backgroundColor: CustomColor.red,
        );
      }
    }
    if (state.status == AuthStateStatus.unauthenticated) {
      print("Error...: ${state.refreshFailure}");
      if (state.refreshFailure != null &&
          state.refreshFailure!.contains("Invalid refresh token")) {
        logger.w("Invalid refresh token");
        setState(() {
          logout = true;
        });
        _logout();
      } else {
        GFToast.showToast(
          state.refreshFailure,
          context,
          toastBorderRadius: 8.0,
          toastPosition: MediaQuery.of(context).viewInsets.bottom != 0
              ? GFToastPosition.TOP
              : GFToastPosition.BOTTOM,
          backgroundColor: CustomColor.red,
          toastDuration: 6,
        );
      }
    }
  }

  // Handle Logout State Change
  void _handleLogoutStateChange(BuildContext context, AuthState state) {
    if (!logout) {
      return;
    }
    if (state.logoutMessage != null) {
      nextScreenAndRemoveAll(context: context, screen: const LoginScreen());
    }
    if (state.logoutFailure != null) {
      var prefs = sl<SharedPreferenceModule>();
      prefs.clear();
      nextScreenAndRemoveAll(context: context, screen: const LoginScreen());
    }
  }

  navigate(BuildContext context, JournalState state) {
    JournalModel paymentRequest = JournalModel(
      description: descriptionController.text,
      // images: _images ?? state.journalData?.images,
      id: state.journalData?.id,
      amount: state.journalData?.amount,
      accountantId: state.journalData?.accountantId,
      // recipientId: state.journalData?.recipientId,
      recipientFirstName: state.journalData?.recipientFirstName,
      recipientLastName: state.journalData?.recipientLastName,
      recipientRole: state.journalData?.recipientRole,
      companyName: state.journalData?.companyName,
      supplier: state.journalData?.supplier,
      tags: selectedTags,
      createdAt: state.journalData?.createdAt,
      updatedAt: state.journalData?.updatedAt,
      currency: state.journalData?.currency,
      spaceId: state.journalData?.spaceId,
      creditAccountId: state.journalData?.creditAccountId,
      debitAccountId: state.journalData?.debitAccountId,
    );
    if (_images.isNotEmpty &&
        (descriptionController.text.isNotEmpty || selectedTags.isNotEmpty)) {
      context.read<JournalBloc>().add(SaveDataJournalState(paymentRequest));
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
            actionsAlignment:
                descriptionController.text.isNotEmpty || selectedTags.isNotEmpty
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
            backgroundColor: Colors.red.shade50,
            title: Text(
                descriptionController.text.isEmpty && selectedTags.isEmpty
                    ? "No description given and no tags selected"
                    : "No receipt uploaded. Proceed?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: SecondaryColors.secondaryRed,
                )),
            actions: [
              if (descriptionController.text.isNotEmpty ||
                  selectedTags.isNotEmpty)
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context
                        .read<JournalBloc>()
                        .add(SaveDataJournalState(paymentRequest));
                  },
                  child: Text("Yes",
                      style: TextStyle(
                          color: Colors.red.shade300,
                          fontSize: CustomFontSize.small)),
                ),
              FloatingActionButton.extended(
                backgroundColor: Colors.red.shade200,
                onPressed: () {
                  Navigator.pop(context);
                },
                label: Text(
                    descriptionController.text.isNotEmpty ||
                            selectedTags.isNotEmpty
                        ? "No"
                        : "Okay",
                    style: TextStyle(
                        color: SecondaryColors.secondaryRed,
                        fontSize: CustomFontSize.small)),
              )
            ]),
      );
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    _images.clear();
    selectedTags.clear();
    super.dispose();
  }

  @override
  void initState() {
    // Get Tags From Shared Preferences
    // var value = prefs.getString("tags");
    // if (value != null) {
    //   List<dynamic> decodedTags = json.decode(value);
    //   List<TagModel> tagModel =
    //       decodedTags.map((tag) => TagModel.fromJson(tag)).toList();
    //   var paidMoneyTags =
    //       tagModel.where((element) => element.isPaidMoneyTag == true);
    //   var tags = paidMoneyTags.map((element) => element.name).toList();
    //   // List<String> tags = decodedTags.map((tag) => tag.toString()).toList();
    //   setState(() {
    //     // Add non-existing values to tags
    //     for (var tag in tags) {
    //       if (tag != null && !this.tags.contains(tag)) {
    //         this.tags.add(tag);
    //       }
    //     }
    //   });
    // }
    // Get Admin Data From Shared Preferences
    var admin = prefs.getAdmin();
    if (admin != null && admin.tagsSettings != null) {
      setState(() {
          tags.addAll(admin.tagsSettings!.paidMoney!);
      });
      
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<UploadCardModel> uploadCardData = [
      UploadCardModel(
        title: "Take receipt photo",
        icon: Icons.camera_alt_outlined,
        onPressed: _imgFromCamera,
      ),
      UploadCardModel(
        title: "Upload receipt",
        icon: Icons.upload_file,
        onPressed: _imgFromGallery,
      )
    ];

    return BlocConsumer<JournalBloc, JournalState>(
        listenWhen: (previous, current) {
      return ModalRoute.of(context)!.isCurrent;
    }, listener: (context, state) {
      _handleJournalStateChange(context, state);
    }, builder: (context, state) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.red.shade50,
        appBar: AppBar(
          backgroundColor: Colors.red.shade100,
          title: Text("Payment",
              style: TextStyle(
                color: SecondaryColors.secondaryRed,
              )),
          centerTitle: true,
          actions: [
            BlocListener<AuthBloc, AuthState>(listener: (context, state){
              _handleRefreshStateChange(context, state);
              _handleLogoutStateChange(context, state);
            }, child: Container(),)
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.red.shade200,
          onPressed: () {
            navigate(context, state);
          },
          label: SizedBox(
            width: 80,
            child: Center(
              child: Text(
                "Next",
                style: TextStyle(
                    fontSize: CustomFontSize.large,
                    color: SecondaryColors.secondaryRed),
              ),
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          children: [
            const SizedBox(height: 30),
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 4 / 3,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: uploadCardData.length,
              itemBuilder: (context, index) => UploadCard(
                text: uploadCardData[index].title,
                icon: uploadCardData[index].icon,
                onPressed: uploadCardData[index].onPressed,
                borderColor: SecondaryColors.secondaryRed,
              ),
            ),
            SizedBox(height: _images.isNotEmpty ? 20 : 0),
            _images.isNotEmpty
                ? Wrap(
                    children: [
                      ..._images.map(
                        (image) => DisposableCard(
                          key: ValueKey(image),
                          onTap: () {
                            // Show Image Modal Preview
                            showDialog(
                              context: context,
                              builder: (context) => Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                        maxHeight:
                                            MediaQuery.of(context).size.height -
                                                100,
                                        maxWidth:
                                            MediaQuery.of(context).size.width -
                                                50,
                                      ),
                                      child: imageMatch(File(image.path))
                                          ? Image.file(File(image.path))
                                          : PdfView(path: image.path),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red.shade300),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Icon(
                                        Icons.clear,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          content: imageMatch(File(image.path))
                              ? Image.file(File(image.path))
                              : PdfView(path: image.path),
                          onDispose: () {
                            setState(() {
                              _images.remove(image);
                            });
                          },
                        ),
                      )
                    ],
                  )
                : const Text(""),
            const SizedBox(height: 20),
            CustomTextField(
              color: SecondaryColors.secondaryRed,
              hintText: "Description",
              controller: descriptionController,
            ),
            const SizedBox(height: 10),
            DefaultTagButtons(
              addTag: _addTag,
              removeTag: _removeTag,
              color: Colors.red.shade100,
              btnColor: Colors.red.shade100,
              textColor: SecondaryColors.secondaryRed,
              unselectedTag: SecondaryColors.secondaryRed.withOpacity(0.5),
              unselectedTagText: SecondaryColors.secondaryRed.withOpacity(0.5),
              tags: tags,
              selectedTags: selectedTags,
            ),
            const SizedBox(height: 150),
          ],
        ),
      );
    });
  }
}
