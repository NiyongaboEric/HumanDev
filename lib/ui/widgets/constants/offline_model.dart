class OfflineModel {
  final String id;
  final String title;
  final dynamic data;
  final UploadStatus status;

  OfflineModel({
    required this.id,
    required this.title,
    required this.data,
    required this.status,
  });

  // Offline Model From JSON
  factory OfflineModel.fromJson(Map<String, dynamic> json) {
    return OfflineModel(
      id: json['id'],
      title: json['title'],
      data: json['data'],
      status: UploadStatusExtension.fromString(json['status']),
    );
  }

  // Offline Model To JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'data': data,
        'status': status.toString().split('.').last,
      };
}

enum UploadStatus {
  initial,
  success,
  failed,
  pending,
  cancelled,
  processing,
  completed,
  error,
  unknown
}

extension UploadStatusExtension on UploadStatus {
  static UploadStatus fromString(String value) {
    switch (value) {
      case "initial":
        return UploadStatus.initial;
      case "success":
        return UploadStatus.success;
      case "failed":
        return UploadStatus.failed;
      case "pending":
        return UploadStatus.pending;
      case "cancelled":
        return UploadStatus.cancelled;
      case "processing":
        return UploadStatus.processing;
      case "completed":
        return UploadStatus.completed;
      case "error":
        return UploadStatus.error;
      case "unknown":
        return UploadStatus.unknown;
      default:
        return UploadStatus.initial;
    }
  }
}
