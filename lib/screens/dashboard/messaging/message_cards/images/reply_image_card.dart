import 'dart:developer';

// import 'package:chat_application/utils/LocalDb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:chat_application/CustomUI/PhotoViewPage.dart';
import 'package:path/path.dart' as path;
import 'package:qonnect/screens/dashboard/messaging/message_cards/images/photo_view_page.dart';
import 'package:qonnect/utils/LocalDB/local_db.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReplyFileCard extends StatefulWidget {
  ReplyFileCard({
    super.key,
    required this.path,
    required this.message,
    required this.time,
    this.emojiReaction,
  });

  final String path;
  final String message;
  final String time;
  String? emojiReaction;

  @override
  State<ReplyFileCard> createState() => _ReplyFileCardState();
}

class _ReplyFileCardState extends State<ReplyFileCard> {
  bool _isDownloaded = false;
  String? _localFilePath;
  String? _tempFilePath;
  String fileName = '';

  @override
  void initState() {
    super.initState();
    fileName = path.basename(widget.path);
    _checkIfFileExists();
  }

  Future<void> requestPermissions(BuildContext context) async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      final result = await Permission.storage.request();
      if (!result.isGranted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Storage permission denied")),
        );
      }
    }
  }

  Future<void> downloadFile(BuildContext context) async {
    await requestPermissions(context);

    try {
      final directory = await getExternalStorageDirectory();
      // final filePath = '${directory?.path}/${widget.path}';
      final filePath = '${directory?.path}/$fileName';

      final tempDirectory = await getTemporaryDirectory();
      final tempFile = File('${tempDirectory.path}/$fileName');

      await tempFile.copy(filePath);
      log("File copied from ${tempFile.path} to $filePath");
      DBHelper.updateFilePath(tempFile.path, filePath);
      // await tempFile.delete();

      // Save the downloaded file path in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(fileName, filePath);

      setState(() {
        _isDownloaded = true;
        _localFilePath = filePath;
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File downloaded to $filePath")),
      );
    } catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to download file: $error")),
      );
    }
  }

  void _checkIfFileExists() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedFilePath = prefs.getString(fileName);

    if (savedFilePath != null && File(savedFilePath).existsSync()) {
      setState(() {
        _isDownloaded = true;
        _localFilePath = savedFilePath;
      });
    } else {
      final tempFile = File(widget.path);
      if (tempFile.existsSync()) {
        setState(() {
          _tempFilePath = tempFile.path;
        });
      } else {
        log("File does not exist in temporary or saved paths",
            name: "File Check");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        //New line originally the child was Container that is the child below.
        child: InkWell(
          onTap: _isDownloaded
              ? () {
                  // Navigate to the PhotoViewPage when the image is clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PhotoViewPage(imagePath: _localFilePath!),
                    ),
                  );
                }
              : null,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2.3,
                width: MediaQuery.of(context).size.width / 1.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey[400],
                ),
                child: Card(
                  margin: const EdgeInsets.all(3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: (_isDownloaded && _localFilePath != null)
                            ? Image.file(
                                File(_localFilePath!),
                                fit: BoxFit.fitHeight,
                              )
                            : (_tempFilePath != null
                                ? Image.file(
                                    File(_tempFilePath!),
                                    fit: BoxFit.fitHeight,
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  )),
                      ),
                      widget.message.isNotEmpty
                          ? Container(
                              height: 40,
                              padding: const EdgeInsets.only(
                                left: 15,
                                top: 8,
                              ),
                              child: Text(
                                widget.message,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              if (!_isDownloaded)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: IconButton(
                        icon: const Icon(
                          Icons.download,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: () {
                          downloadFile(context);
                          // downloadFile(context,
                          //     "http://192.168.0.207:5000/download/images/${widget.path}");
                        },
                      ),
                    ),
                  ),
                ),
              Visibility(
                visible: widget.emojiReaction != null,
                child: Positioned(
                    top: 350,
                    left: 10,
                    child: Text(
                      widget.emojiReaction ?? "",
                      style: const TextStyle(fontSize: 17),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
