import 'dart:typed_data';

class FileTypeModel {
  Uint8List data;
  String dataType;

  FileTypeModel({required this.data, required this.dataType});

  Map<String, dynamic> toMap() {
    return {"data": data, "dataType": dataType};
  }
}
/*
enum FileType{
  jpg = "image/jpeg";
  png = "image/png";
  bmp = "image/bmp";
  webp = "image/webp";
  pdf = "application/pdf";
}
*/