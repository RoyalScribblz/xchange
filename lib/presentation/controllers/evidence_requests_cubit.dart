import "package:auth0_flutter/auth0_flutter.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:image_picker/image_picker.dart";
import "package:pdfrx/pdfrx.dart";

import "../../data/dtos/evidence_request.dart";
import "../../data/repositories/evidence_request_repository.dart";
import "cubit_models/evidence_requests_data.dart";

class EvidenceRequestsCubit extends Cubit<EvidenceRequestsData> {
  EvidenceRequestsCubit() : super(EvidenceRequestsData([], {}, {}));

  Future initialise(Credentials? credentials) async {
    final List<EvidenceRequest> evidenceRequests =
        await EvidenceRequestRepository.getEvidenceRequests(credentials);

    final Map<String, List<XFile>> files = {};
    final Map<String, PdfDocument> pdfDocuments = {};
    for (EvidenceRequest evidenceRequest in evidenceRequests) {
      final List<XFile> xFiles = [];

      for (String evidenceId in evidenceRequest.evidenceIds) {
        final XFile? xFile =
            await EvidenceRequestRepository.getEvidence(evidenceId, credentials);
        if (xFile == null) {
          continue;
        }

        xFiles.add(xFile);

        if (xFile.mimeType == "application/pdf") {
          pdfDocuments[xFile.path] = await PdfDocument.openFile(xFile.path);
        }
      }

      files[evidenceRequest.evidenceRequestId] = xFiles;
    }

    emit(EvidenceRequestsData(evidenceRequests, files, pdfDocuments));
  }

  Future acceptEvidenceRequest(String evidenceRequestId, Credentials? credentials) async {
    final bool success = await EvidenceRequestRepository.acceptEvidenceRequest(
        evidenceRequestId, credentials);

    if (success) {
      final List<XFile>? xFiles = state.files.remove(evidenceRequestId);

      if (xFiles != null) {
        for (var xFile in xFiles) {
          state.pdfDocuments.remove(xFile.path);
        }
      }

      state.evidenceRequests.removeWhere((e) => e.evidenceRequestId == evidenceRequestId);

      emit(EvidenceRequestsData(state.evidenceRequests, state.files, state.pdfDocuments));
    }
  }

  Future rejectEvidenceRequest(String evidenceRequestId, Credentials? credentials) async {
    final bool success = await EvidenceRequestRepository.rejectEvidenceRequest(
        evidenceRequestId, credentials);

    if (success) {
      final List<XFile>? xFiles = state.files.remove(evidenceRequestId);

      if (xFiles != null) {
        for (var xFile in xFiles) {
          state.pdfDocuments.remove(xFile.path);
        }
      }

      state.evidenceRequests.removeWhere((e) => e.evidenceRequestId == evidenceRequestId);

      emit(EvidenceRequestsData(state.evidenceRequests, state.files, state.pdfDocuments));
    }
  }
}
