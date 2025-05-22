import 'dart:typed_data';

import 'package:mime/mime.dart';

String modifyDateTimeValue(String timeStamp) {
  return timeStamp.substring(11, 16);
}

final List<String> imageTypes = [
  'png',
  'jpg',
  'gif',
  'bmp',
  'tiff',
  'webp',
  'svg',
  'ico'
];

final List<String> docTypes = [
  'pdf',
  'doc',
  'docx',
  'xls',
  'xlsx',
  'ppt',
  'pptx',
  'csv',
  'html',
  'xml',
];

final List<String> audioTypes = [
  'mp3',
  'aac',
  'wav',
  'ogg',
  'flac',
  'wma',
  'amr',
];

final List<String> videoTypes = ['mp4', 'avi', 'mpeg', 'webm', 'wmv'];

List<String> fileTypeHelper(String decryptedFileExtension) {
  List<String> res = [];
  var fileType;
  var stringType;
  if (imageTypes.contains(decryptedFileExtension)) {
    fileType = 'image';
    stringType = '📷 Image';
  } else if (docTypes.contains(decryptedFileExtension)) {
    fileType = 'pdf';
    stringType = '📄 PDF Document';
  } else if (audioTypes.contains(decryptedFileExtension)) {
    fileType = 'mp3';
    stringType = '🎵 Audio Message';
  } else if (videoTypes.contains(decryptedFileExtension)) {
    fileType = 'mp4';
    stringType = '🎥 Video Message';
  } else {
    fileType = 'text';
    stringType = '';
  }
  res.add(fileType);
  res.add(stringType);
  return res;
}

Map<String, String> mimeToExtensionMap = {
  'image/png': 'png',
  'image/jpeg': 'jpg',
  'image/gif': 'gif',
  'image/bmp': 'bmp',
  'image/tiff': 'tiff',
  'image/webp': 'webp',
  'image/svg+xml': 'svg',
  'image/vnd.microsoft.icon': 'ico',
  'application/pdf': 'pdf',
  'application/msword': 'doc',
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document':
      'docx',
  'application/vnd.ms-excel': 'xls',
  'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet': 'xlsx',
  'application/vnd.ms-powerpoint': 'ppt',
  'application/vnd.openxmlformats-officedocument.presentationml.presentation':
      'pptx',
  'text/csv': 'csv',
  'text/html': 'html',
  'application/xml': 'xml',
  'text/xml': 'xml',
  'audio/mpeg': 'mp3',
  'audio/aac': 'aac',
  'audio/wav': 'wav',
  'audio/ogg': 'ogg',
  'audio/flac': 'flac',
  'audio/x-ms-wma': 'wma',
  'audio/amr': 'amr',
  'video/mp4': 'mp4',
  'video/x-msvideo': 'avi',
  'video/mpeg': 'mpeg',
  'video/webm': 'webm',
  'video/x-ms-wmv': 'wmv'
};

String getFileType(Uint8List bytes) {
  if (bytes.length >= 4 &&
      String.fromCharCodes(bytes.sublist(0, 4)) == 'RIFF') {
    return 'audio/wav';
  }
  return lookupMimeType('', headerBytes: bytes) ?? 'unknown';
}
