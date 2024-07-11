import "package:image_picker/image_picker.dart";
import "package:pdfrx/pdfrx.dart";

import "../../../data/dtos/evidence_request.dart";

class EvidenceRequestsData {
  EvidenceRequestsData(this.evidenceRequests, this.files, this.pdfDocuments);

  final List<EvidenceRequest> evidenceRequests;
  final Map<String, List<XFile>> files;
  final Map<String, PdfDocument> pdfDocuments;
}