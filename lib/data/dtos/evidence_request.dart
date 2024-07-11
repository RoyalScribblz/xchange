import "package:json_annotation/json_annotation.dart";

import "currency.dart";

part "evidence_request.g.dart";

@JsonSerializable()
class EvidenceRequest {

  EvidenceRequest({
    required this.evidenceRequestId,
    required this.userId,
    required this.evidenceIds,
    required this.status,
    required this.currency,
    required this.amount,
  });

  factory EvidenceRequest.fromJson(Map<String, dynamic> json) => _$EvidenceRequestFromJson(json);
  Map<String, dynamic> toJson() => _$EvidenceRequestToJson(this);

  final String evidenceRequestId;
  final String userId;
  final List<String> evidenceIds;
  final EvidenceRequestStatus status;
  final Currency currency;
  final double amount;
}

@JsonEnum()
enum EvidenceRequestStatus {
  @JsonValue(0)
  active,

  @JsonValue(1)
  rejected,

  @JsonValue(2)
  accepted,
}