import 'dart:io';

class Photo {
  final String id;
  final String author;
  final String downloadUrl;
  final File? localFile;

  Photo({required this.id, required this.author, required this.downloadUrl, this.localFile});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(id: json['id'] ?? '', author: json['author'] ?? 'Unknown', downloadUrl: json['download_url'] ?? '');
  }

  factory Photo.fromLocalFile(File file) {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return Photo(id: 'local_$timestamp', author: 'You', downloadUrl: '', localFile: file);
  }

  bool get isLocal => localFile != null;

  String getThumbnailUrl({int width = 400, int height = 400}) {
    if (isLocal) return '';
    return downloadUrl.replaceAll(RegExp(r'/id/\d+/(\d+)/(\d+)'), '/id/${id.split('/').last}/$width/$height');
  }
}
