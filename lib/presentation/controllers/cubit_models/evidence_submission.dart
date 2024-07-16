import "package:image_picker/image_picker.dart";
import "package:pdfrx/pdfrx.dart";

import "../../../data/dtos/evidence_request.dart";

class EvidenceSubmission {
  EvidenceSubmission(
    this.evidenceRequest,
    this.images,
    this.pdfs,
    this.pdfDocuments,
  );

  final EvidenceRequest? evidenceRequest;
  final List<XFile> images;
  final List<XFile> pdfs;
  final List<PdfDocument> pdfDocuments;
}
