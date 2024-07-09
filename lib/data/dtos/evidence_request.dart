import "package:json_annotation/json_annotation.dart";

part "evidence_request.g.dart";

@JsonSerializable()
class EvidenceRequest {

  EvidenceRequest({
    required this.evidenceRequestId,
    required this.evidenceIds,
    required this.status,
  });

  factory EvidenceRequest.fromJson(Map<String, dynamic> json) => _$EvidenceRequestFromJson(json);
  Map<String, dynamic> toJson() => _$EvidenceRequestToJson(this);

  final String evidenceRequestId;
  final List<String> evidenceIds;
  final EvidenceRequestStatus status;
}

enum EvidenceRequestStatus {
  @JsonValue(0)
  active,

  @JsonValue(1)
  rejected,

  @JsonValue(2)
  accepted,
}