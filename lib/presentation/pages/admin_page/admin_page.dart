import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:image_picker/image_picker.dart";
import "package:pdfrx/pdfrx.dart";

import "../../../data/dtos/currency.dart";
import "../../../data/dtos/evidence_request.dart";
import "../../../fonts.dart";
import "../../controllers/currencies_cubit.dart";
import "../../controllers/evidence_requests_cubit.dart";
import "../../controllers/limits_cubit.dart";
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
  int currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    final LimitsCubit limitsCubit = context.watch<LimitsCubit>();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: currentPageIndex == 0
          ? FloatingActionButton(
              onPressed: () async => await limitsCubit.setCurrencyLimits(),
              child: const Icon(Icons.check),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: TextField(
            decoration: const InputDecoration(hintText: "Search"),
            onChanged: (value) => limitsCubit.setSearch(value),
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
                            controller: filtered[currency],
                          ),
                        ),
                        IconButton(
                          onPressed: () => limitsCubit.setCurrencyLimit(currency),
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
    context.read<EvidenceRequestsCubit>().initialise();
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
                          onPressed: () async => evidenceRequestsCubit
                              .acceptEvidenceRequest(evidenceRequestsCubit
                                  .state.evidenceRequests[i].evidenceRequestId),
                          icon: const Icon(Icons.check),
                        ),
                        IconButton(
                          onPressed: () async => evidenceRequestsCubit
                              .rejectEvidenceRequest(evidenceRequestsCubit
                                  .state.evidenceRequests[i].evidenceRequestId),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    SpacedColumn(
                      spaceHeight: 5,
                      children: [
                        for (XFile xFile in evidenceRequestsCubit.state.files[
                            requests[i].evidenceRequestId]!)
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
