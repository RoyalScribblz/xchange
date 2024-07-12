import "dart:io";

import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:image_picker/image_picker.dart";
import "package:pdfrx/pdfrx.dart";

import "../../../fonts.dart";
import "../../controllers/evidence_cubit.dart";
import "../../controllers/user_cubit.dart";
import "../common/spaced_column.dart";
import "../exchange_page/exchange_page.dart";

enum AttachmentOption { photoLibrary, takePhoto, chooseFiles }

class FrozenPage extends StatefulWidget {
  const FrozenPage({super.key});

  @override
  State<FrozenPage> createState() => _FrozenPageState();
}

class _FrozenPageState extends State<FrozenPage> {
  @override
  void initState() {
    super.initState();
    final String userId = context.read<UserCubit>().state.user!.userId;
    context.read<EvidenceCubit>().initialise(userId);
  }

  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final EvidenceCubit evidenceCubit = context.watch<EvidenceCubit>();
    final NavigatorState nav = Navigator.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Text("Your account has been frozen", style: Fonts.neueMedium(15)),
              Text("for suspicious activity.", style: Fonts.neueMedium(15)),
              const SizedBox(height: 15),
              PopupMenuButton(
                onSelected: (selected) async {
                  if (selected == AttachmentOption.photoLibrary) {
                    evidenceCubit.addImages(await picker.pickMultiImage());
                  } else if (selected == AttachmentOption.takePhoto) {
                    evidenceCubit.addImage(
                        await picker.pickImage(source: ImageSource.camera));
                  } else {
                    await evidenceCubit.addPdfs((await FilePicker.platform
                            .pickFiles(
                                allowMultiple: true,
                                type: FileType.custom,
                                allowedExtensions: ["pdf"]))
                        ?.xFiles);
                  }
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: AttachmentOption.photoLibrary,
                    child: SizedBox(
                      width: 180,
                      child: Row(
                        children: [
                          Text("Photo Library", style: Fonts.neueMedium(15)),
                          const Expanded(
                            child: SizedBox(),
                          ),
                          const Icon(Icons.photo_library_outlined)
                        ],
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: AttachmentOption.takePhoto,
                    child: SizedBox(
                      width: 180,
                      child: Row(
                        children: [
                          Text("Take Photo", style: Fonts.neueMedium(15)),
                          const Expanded(
                            child: SizedBox(),
                          ),
                          const Icon(Icons.camera_alt_outlined)
                        ],
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: AttachmentOption.chooseFiles,
                    child: SizedBox(
                      width: 180,
                      child: Row(
                        children: [
                          Text("Choose Files", style: Fonts.neueMedium(15)),
                          const Expanded(
                            child: SizedBox(),
                          ),
                          const Icon(Icons.folder_copy_outlined)
                        ],
                      ),
                    ),
                  ),
                ],
                child: Row(
                  children: [
                    const Icon(Icons.attach_file),
                    const SizedBox(width: 5),
                    Text("Attach Evidence", style: Fonts.neueLight(15)),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              SpacedColumn(
                spaceHeight: 5,
                children: [
                  for (XFile image in evidenceCubit.state.images)
                    Row(
                      children: [
                        Image.file(
                          File(image.path),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                            child: Text(image.name,
                                style: Fonts.neueLight(15),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis)),
                        IconButton(
                            onPressed: () => evidenceCubit.removeImage(image),
                            icon: const Icon(Icons.close))
                      ],
                    ),
                ],
              ),
              if (evidenceCubit.state.pdfs.isNotEmpty)
                const SizedBox(height: 5),
              SpacedColumn(
                spaceHeight: 5,
                children: [
                  for (int i = 0; i < evidenceCubit.state.pdfs.length; i++)
                    Row(
                      children: [
                        SizedBox(
                          width: 50,
                          height: 50,
                          child: PdfPageView(
                            document: evidenceCubit.state.pdfDocuments[i],
                            pageNumber: 1,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                            child: Text(evidenceCubit.state.pdfs[i].name,
                                style: Fonts.neueLight(15),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis)),
                        IconButton(
                            onPressed: () => evidenceCubit.removePdf(i),
                            icon: const Icon(Icons.close))
                      ],
                    ),
                ],
              ),
              const Expanded(child: SizedBox()),
              ContinueButton(
                label: "Submit Evidence",
                onPressed: () async {
                  await evidenceCubit.submitEvidence();
                  await nav.push(
                    MaterialPageRoute(
                      builder: (_) => const FrozenSubmissionPendingPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FrozenSubmissionPendingPage extends StatelessWidget {
  const FrozenSubmissionPendingPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                const Expanded(child: SizedBox()),
                const Icon(Icons.pending, size: 150),
                Text(
                  "Evidence Submission Successful",
                  style: Fonts.neueMedium(20),
                ),
                Text(
                  "Pending Review",
                  style: Fonts.neueBold(30),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
