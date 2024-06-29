import "package:image_picker/image_picker.dart";
import "package:pdfrx/pdfrx.dart";

class EvidenceSubmission {
  EvidenceSubmission(
    this.images,
    this.pdfs,
    this.pdfDocuments,
  );

  final List<XFile> images;
  final List<XFile> pdfs;
  final List<PdfDocument> pdfDocuments;
}
