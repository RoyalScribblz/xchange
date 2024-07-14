import "dart:convert";
import "dart:io";

import "package:image_picker/image_picker.dart";
import "package:http_parser/http_parser.dart";

import "package:http/http.dart" as http;
import "package:mime/mime.dart";
import "package:path_provider/path_provider.dart";

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

  static Future<EvidenceRequest?> getEvidenceRequest(String userId, EvidenceRequestStatus status) async {
    final String statusString = switch (status) {
      EvidenceRequestStatus.waiting => "0",
      EvidenceRequestStatus.active => "1",
      EvidenceRequestStatus.rejected => "2",
      EvidenceRequestStatus.accepted => "3",
    };

    final response = await http.get(
      Uri.http("10.0.2.2:5230", "evidenceRequest", {"userId": userId, "evidenceRequestStatus": statusString}),
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

  static Future<List<EvidenceRequest>> getEvidenceRequests() async {
    final response = await http.get(
      Uri.http("10.0.2.2:5230", "evidenceRequests"),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
        "Accept": "*/*"
      },
    );

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((e) => EvidenceRequest.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    return [];
  }

  static Future<XFile?> getEvidence(String evidenceId) async {
    final Directory directory = await getTemporaryDirectory();  // TODO clear this directory
    final File file = File("${directory.path}/$evidenceId");

    final response = await http.get(
      Uri.http("10.0.2.2:5230", "evidence/$evidenceId"),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Accept": "*/*"
      },
    );

    if (response.statusCode == 200) {
      if (!await file.exists()) {
        await file.create();
      }

      await file.writeAsBytes(response.bodyBytes);
      return XFile("${directory.path}/$evidenceId", mimeType: response.headers["content-type"]);
    }

    return null;
  }

  static Future<bool> acceptEvidenceRequest(String evidenceRequestId) async {
    final response = await http.post(
      Uri.http("10.0.2.2:5230", "evidenceRequest/$evidenceRequestId/accept"),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
        "Accept": "*/*"
      },
    );

    return response.statusCode == 200;
  }

  static Future<bool> rejectEvidenceRequest(String evidenceRequestId) async {
    final response = await http.post(
      Uri.http("10.0.2.2:5230", "evidenceRequest/$evidenceRequestId/reject"),
      headers: {
        "Access-Control-Allow-Origin": "*",
        "Content-Type": "application/json",
        "Accept": "*/*"
      },
    );

    return response.statusCode == 200;
  }
}
