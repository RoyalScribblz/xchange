import "dart:convert";

import "package:image_picker/image_picker.dart";
import "package:http_parser/http_parser.dart";

import "package:http/http.dart" as http;
import "package:mime/mime.dart";

import "../dtos/evidence_request.dart";

class EvidenceRequestRepository {
  static Future submitEvidence(String evidenceId, List<XFile> xFiles) async {
    final request = http.MultipartRequest(
      "PATCH",
      Uri.http("10.0.2.2:5230", "evidenceRequest/$evidenceId/evidence"),
    );

    for (XFile file in xFiles) {
      request.files.add(
        http.MultipartFile.fromBytes(
          "file",
          await file.readAsBytes(),
          filename: file.name,
          contentType: MediaType.parse(
            lookupMimeType(file.path) ?? "application/octet-stream",
          ),
        ),
      );
    }

    request.headers.addAll({
      "Access-Control-Allow-Origin": "*",
      "Accept": "*/*",
    });

    await request.send();
  }

  static Future<EvidenceRequest?> getEvidenceRequest(String userId) async {
    final response = await http.get(
      Uri.http("10.0.2.2:5230", "evidenceRequest", {"userId": userId}),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
        "Accept": "*/*"
      },
    );

    if (response.statusCode == 200) {
      return EvidenceRequest.fromJson(json.decode(response.body));
    }

    return null;
  }
}
