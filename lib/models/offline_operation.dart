class OfflineOperation {
  final String type;
  final Map<String, dynamic> payload;
  final DateTime createdAt;

  OfflineOperation({
    required this.type,
    required this.payload,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'type': type,
    'payload': payload,
    'created_at': createdAt.toIso8601String(),
  };

  factory OfflineOperation.fromJson(Map<String, dynamic> json) => OfflineOperation(
    type: json['type']?.toString() ?? '',
    payload: Map<String, dynamic>.from(json['payload'] ?? {}),
    createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ?? DateTime.now(),
  );
}
