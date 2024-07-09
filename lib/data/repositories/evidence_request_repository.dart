import "package:image_picker/image_picker.dart";

import "package:http/http.dart" as http;

class EvidenceRequestRepository {
  static Future submitEvidence(String evidenceId, List<XFile> xFiles) async {
    final request = http.MultipartRequest(
      "PATCH",
      Uri.http("10.0.2.2:5230", "evidenceRequest/$evidenceId/evidence"),
    );
    
    for (XFile file in xFiles) {
      request.files.add(await http.MultipartFile.fromBytes(field, value))
    }
  }
}
