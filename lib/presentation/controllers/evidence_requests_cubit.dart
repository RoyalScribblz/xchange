import "package:flutter_bloc/flutter_bloc.dart";
import "package:image_picker/image_picker.dart";
import "package:pdfrx/pdfrx.dart";

import "../../data/dtos/evidence_request.dart";
import "../../data/repositories/evidence_request_repository.dart";
import "cubit_models/evidence_requests_data.dart";

class EvidenceRequestsCubit extends Cubit<EvidenceRequestsData> {
  EvidenceRequestsCubit() : super(EvidenceRequestsData([], {}, {}));

  Future initialise() async {
    final List<EvidenceRequest> evidenceRequests = await EvidenceRequestRepository.getEvidenceRequests();

    final Map<String, List<XFile>> files = {};
    final Map<String, PdfDocument> pdfDocuments = {};
    for (EvidenceRequest evidenceRequest in evidenceRequests) {
      final List<XFile> xFiles = [];

      for (String evidenceId in evidenceRequest.evidenceIds) {
        final XFile? xFile = await EvidenceRequestRepository.getEvidence(evidenceId);
        if (xFile == null) {
          break;
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
}
