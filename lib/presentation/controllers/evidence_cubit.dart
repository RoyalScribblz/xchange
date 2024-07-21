import "package:auth0_flutter/auth0_flutter.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:image_picker/image_picker.dart";
import "package:pdfrx/pdfrx.dart";

import "../../data/dtos/evidence_request.dart";
import "../../data/repositories/evidence_request_repository.dart";
import "cubit_models/evidence_submission.dart";

class EvidenceCubit extends Cubit<EvidenceSubmission> {
  EvidenceCubit() : super(EvidenceSubmission(null, [], [], []));

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
        state.evidenceRequest, images, state.pdfs, state.pdfDocuments));
  }

  void addImage(XFile? image) {
    if (image == null) {
      return;
    }

    final List<XFile> images = [...state.images];

    images.removeWhere((i) => i.name == image.name);
    images.add(image);

    emit(EvidenceSubmission(
        state.evidenceRequest, images, state.pdfs, state.pdfDocuments));
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
        EvidenceSubmission(state.evidenceRequest, state.images, pdfs, pdfDocuments));
  }

  void removeImage(XFile image) {
    if (state.images.remove(image)) {
      emit(EvidenceSubmission(
          state.evidenceRequest, state.images, state.pdfs, state.pdfDocuments));
    }
  }

  void removePdf(int index) {
    state.pdfs.removeAt(index);
    state.pdfDocuments.removeAt(index);
    emit(EvidenceSubmission(
        state.evidenceRequest, state.images, state.pdfs, state.pdfDocuments));
  }

  Future initialise(Credentials? credentials) async {
    final evidenceRequest =
        await EvidenceRequestRepository.getEvidenceRequest(credentials);

    if (evidenceRequest != null) {
      emit(EvidenceSubmission(
        evidenceRequest,
        state.images,
        state.pdfs,
        state.pdfDocuments,
      ));
    }
  }

  Future submitEvidence(Credentials? credentials) async {
    await EvidenceRequestRepository.submitEvidence(
      state.evidenceRequest!.evidenceRequestId,
      [...state.images, ...state.pdfs],
      credentials,
    );
  }
}
