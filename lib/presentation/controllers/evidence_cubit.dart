import "package:flutter_bloc/flutter_bloc.dart";
import "package:image_picker/image_picker.dart";
import "package:pdfrx/pdfrx.dart";

import "../../data/repositories/evidence_request_repository.dart";
import "cubit_models/evidence_submission.dart";

class EvidenceCubit extends Cubit<EvidenceSubmission> {
  EvidenceCubit() : super(EvidenceSubmission("", [], [], []));

  void addImages(List<XFile> newImages) {
    if (newImages.isEmpty) {
      return;
    }

    final List<XFile> images = [...state.images];

    for (XFile image in newImages) {
      images.removeWhere((i) => i.name == image.name);
      images.add(image);
    }

    emit(EvidenceSubmission(
        state.evidenceId, images, state.pdfs, state.pdfDocuments));
  }

  void addImage(XFile? image) {
    if (image == null) {
      return;
    }

    final List<XFile> images = [...state.images];

    images.removeWhere((i) => i.name == image.name);
    images.add(image);

    emit(EvidenceSubmission(
        state.evidenceId, images, state.pdfs, state.pdfDocuments));
  }

  Future addPdfs(List<XFile>? newPdfs) async {
    if (newPdfs == null || newPdfs.isEmpty) {
      return;
    }

    final List<XFile> pdfs = [...state.pdfs];

    for (XFile pdf in newPdfs) {
      pdfs.removeWhere((i) => i.name == pdf.name);
      pdfs.add(pdf);
    }

    final List<PdfDocument> pdfDocuments = [];
    for (XFile pdf in pdfs) {
      pdfDocuments.add(await PdfDocument.openFile(pdf.path));
    }

    emit(
        EvidenceSubmission(state.evidenceId, state.images, pdfs, pdfDocuments));
  }

  void removeImage(XFile image) {
    if (state.images.remove(image)) {
      emit(EvidenceSubmission(
          state.evidenceId, state.images, state.pdfs, state.pdfDocuments));
    }
  }

  void removePdf(int index) {
    state.pdfs.removeAt(index);
    state.pdfDocuments.removeAt(index);
    emit(EvidenceSubmission(
        state.evidenceId, state.images, state.pdfs, state.pdfDocuments));
  }

  Future initialise(String userId) async {
    final evidenceRequest =
        await EvidenceRequestRepository.getEvidenceRequest(userId);

    if (evidenceRequest != null) {
      emit(EvidenceSubmission(
        evidenceRequest.evidenceRequestId,
        state.images,
        state.pdfs,
        state.pdfDocuments,
      ));
    }
  }

  Future submitEvidence() async {
    await EvidenceRequestRepository.submitEvidence(
      state.evidenceId,
      [...state.images, ...state.pdfs],
    );
  }
}
