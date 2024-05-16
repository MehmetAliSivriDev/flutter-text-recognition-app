import 'dart:io';

class ImageModel {
  int id;
  File file;

  ImageModel({
    required this.id,
    required this.file,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      file: File(json['filePath']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filePath': file.path,
    };
  }
}
