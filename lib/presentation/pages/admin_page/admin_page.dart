import "dart:io";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:image_picker/image_picker.dart";
import "package:pdfrx/pdfrx.dart";

import "../../../data/dtos/currency.dart";
import "../../../data/dtos/evidence_request.dart";
import "../../../fonts.dart";
import "../../controllers/cubit_models/user.dart";
import "../../controllers/currencies_cubit.dart";
import "../../controllers/evidence_requests_cubit.dart";
import "../../controllers/limits_cubit.dart";
import "../../controllers/user_cubit.dart";
import "../common/spaced_column.dart";
import "../common/square_image.dart";

class AdminPage extends StatefulWidget {
  const AdminPage({
    super.key,
  });

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final LimitsCubit limitsCubit = context.watch<LimitsCubit>();
    final UserCubit userCubit = context.watch<UserCubit>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: currentPageIndex == 0
          ? FloatingActionButton(
              onPressed: () async {
                final List<String> invalidTexts =
                    limitsCubit.invalidControllerTexts();

                if (invalidTexts.isNotEmpty) {
                  final String content = invalidTexts.join(",\n");

                  await showDialog(
                    context: context,
                    builder: (BuildContext localContext) => AlertDialog(
                      title: const Text("Invalid Inputs"),
                      content: Text(
                          "Amount should only contain digits and decimals. The following are invalid: \n$content"),
                      actions: [
                        TextButton(
                          child: const Text("OK"),
                          onPressed: () => Navigator.of(localContext).pop(),
                        )
                      ],
                    ),
                  );
                }

                final Map<String, String> changedValues = await limitsCubit
                    .setCurrencyLimits(userCubit.state.credentials);

                if (changedValues.isNotEmpty) {
                  if (context.mounted) {
                    final String content = changedValues.entries
                        .map((e) => "${e.key}: ${e.value}")
                        .join(",\n");

                    await showDialog(
                      context: context,
                      builder: (BuildContext localContext) => AlertDialog(
                        title: const Text("Successfully applied new limits"),
                        content: Text(content),
                        actions: [
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () => Navigator.of(localContext).pop(),
                          )
                        ],
                      ),
                    );
                  }
                }
              },
              child: const Icon(Icons.check),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) =>
            setState(() => currentPageIndex = index),
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.lock_outline),
            label: "Limits",
          ),
          NavigationDestination(
            icon: Icon(Icons.document_scanner_outlined),
            label: "Requests",
          ),
        ],
      ),
      body: SafeArea(
        child: [
          const LimitsPage(),
          BlocProvider(
            create: (_) => EvidenceRequestsCubit(),
            child: const RequestsPage(),
          ),
        ][currentPageIndex],
      ),
    );
  }
}

class LimitsPage extends StatefulWidget {
  const LimitsPage({super.key});

  @override
  State<LimitsPage> createState() => _LimitsPageState();
}

class _LimitsPageState extends State<LimitsPage> {
  @override
  void initState() {
    super.initState();
    initStateAsync();
  }

  Future initStateAsync() async {
    final CurrenciesCubit currenciesCubit = context.read<CurrenciesCubit>();
    final LimitsCubit limitsCubit = context.read<LimitsCubit>();

    await currenciesCubit.update();
    limitsCubit.initialise(currenciesCubit.state);
  }

  @override
  Widget build(BuildContext context) {
    final LimitsCubit limitsCubit = context.watch<LimitsCubit>();
    final Map<Currency, TextEditingController> filtered =
        limitsCubit.getFilteredCurrencies();

    final UserCubit userCubit = context.watch<UserCubit>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, bottom: 15),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(hintText: "Search"),
                  onChanged: (value) => limitsCubit.setSearch(value),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async => await context.read<UserCubit>().logout(),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: SpacedColumn(
                spaceHeight: 7,
                children: [
                  for (Currency currency in filtered.keys)
                    Row(
                      children: [
                        SquareImage(assetPath: currency.flagImageUrl, size: 50),
                        const SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            "${currency.name} (${currency.symbol})",
                            style: Fonts.neueMedium(15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: filtered[currency],
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            if (!limitsCubit.controllerTextValid(currency) &&
                                context.mounted) {
                              await showDialog(
                                context: context,
                                builder: (BuildContext localContext) =>
                                    AlertDialog(
                                  title: const Text("Invalid Input"),
                                  content: const Text(
                                      "Amount should only contain digits and decimals, for example: `25.62`"),
                                  actions: [
                                    TextButton(
                                      child: const Text("OK"),
                                      onPressed: () =>
                                          Navigator.of(localContext).pop(),
                                    )
                                  ],
                                ),
                              );
                            }

                            final double? amount =
                                await limitsCubit.setCurrencyLimit(
                                    currency, userCubit.state.credentials);

                            if (amount != null &&
                                amount <= 0 &&
                                context.mounted) {
                              await showDialog(
                                context: context,
                                builder: (BuildContext localContext) =>
                                    AlertDialog(
                                  title: const Text("Invalid Limit"),
                                  content: const Text(
                                      "Limit must be non-zero and positive."),
                                  actions: [
                                    TextButton(
                                      child: const Text("OK"),
                                      onPressed: () =>
                                          Navigator.of(localContext).pop(),
                                    )
                                  ],
                                ),
                              );
                              return;
                            }

                            if (amount != null && context.mounted) {
                              // TODO bug this shows a second time if u press again
                              await showDialog(
                                context: context,
                                builder: (BuildContext localContext) =>
                                    AlertDialog(
                                  title: const Text(
                                      "Successfully applied new limit"),
                                  content: Text(
                                      "${currency.currencyCode}: ${amount.toStringAsFixed(2)}"),
                                  actions: [
                                    TextButton(
                                      child: const Text("OK"),
                                      onPressed: () =>
                                          Navigator.of(localContext).pop(),
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.check),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
        //ContinueButton(label: "Save All", onPressed: () => {}),
      ],
    );
  }
}

class RequestsPage extends StatefulWidget {
  const RequestsPage({super.key});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  @override
  void initState() {
    super.initState();
    final UserCubit userCubit = context.read<UserCubit>();
    context
        .read<EvidenceRequestsCubit>()
        .initialise(userCubit.state.credentials);
  }

  @override
  Widget build(BuildContext context) {
    final EvidenceRequestsCubit evidenceRequestsCubit =
        context.watch<EvidenceRequestsCubit>();
    final NavigatorState nav = Navigator.of(context);

    final List<EvidenceRequest> requests = evidenceRequestsCubit
        .state.evidenceRequests
        .where((r) => r.status == EvidenceRequestStatus.active)
        .toList();

    final UserCubit userCubit = context.watch<UserCubit>();

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          for (int i = 0; i < requests.length; i++)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "User ID: ${requests[i].userId.substring(6)}",
                              style: Fonts.neueMedium(15),
                            ),
                            Text(
                              "Amount: ${requests[i].currency.symbol}${requests[i].amount} ${requests[i].currency.currencyCode}",
                              style: Fonts.neueMedium(15),
                            ),
                            Text("Evidence:", style: Fonts.neueMedium(15)),
                          ],
                        ),
                        const Expanded(child: SizedBox()),
                        IconButton(
                          onPressed: () async =>
                              evidenceRequestsCubit.acceptEvidenceRequest(
                                  evidenceRequestsCubit.state
                                      .evidenceRequests[i].evidenceRequestId,
                                  userCubit.state.credentials),
                          icon: const Icon(Icons.check),
                        ),
                        IconButton(
                          onPressed: () async =>
                              evidenceRequestsCubit.rejectEvidenceRequest(
                                  evidenceRequestsCubit.state
                                      .evidenceRequests[i].evidenceRequestId,
                                  userCubit.state.credentials),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    SpacedColumn(
                      spaceHeight: 5,
                      children: [
                        for (XFile xFile in evidenceRequestsCubit
                            .state.files[requests[i].evidenceRequestId]!)
                          Row(
                            children: [
                              xFile.mimeType == "application/pdf"
                                  ? SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: PdfPageView(
                                        document: evidenceRequestsCubit
                                            .state.pdfDocuments[xFile.path],
                                        pageNumber: 1,
                                      ),
                                    )
                                  : Image.file(
                                      File(xFile.path),
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  xFile.name,
                                  style: Fonts.neueLight(15),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                onPressed: () async => await nav.push(
                                  MaterialPageRoute(
                                    builder: (_) {
                                      return xFile.mimeType == "application/pdf"
                                          ? FullScreenPdfView(xFile.path)
                                          : FullScreenImageView(xFile.path);
                                    },
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.open_in_new_outlined,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}

class FullScreenImageView extends StatelessWidget {
  const FullScreenImageView(this.imageFilePath, {super.key});

  final String imageFilePath;

  @override
  Widget build(BuildContext context) {
    final NavigatorState nav = Navigator.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () => nav.pop(),
        child: const Icon(Icons.close),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.file(
                File(imageFilePath),
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenPdfView extends StatelessWidget {
  const FullScreenPdfView(this.pdfFilePath, {super.key});

  final String pdfFilePath;

  @override
  Widget build(BuildContext context) {
    final NavigatorState nav = Navigator.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () => nav.pop(),
        child: const Icon(Icons.close),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: PdfViewer.file(
                pdfFilePath,
                params: const PdfViewerParams(
                  backgroundColor: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
