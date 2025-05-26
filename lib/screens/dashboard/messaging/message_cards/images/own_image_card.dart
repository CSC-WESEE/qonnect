import 'dart:io';
// import 'package:chat_application/CustomUI/OwnMessageCard.dart';
import 'package:flutter/material.dart';
import 'package:qonnect/screens/dashboard/messaging/message_cards/images/photo_view_page.dart';
// import 'package:chat_application/CustomUI/PhotoViewPage.dart';
import 'package:qonnect/screens/dashboard/messaging/message_cards/text_messages/own_message_card.dart';


// ignore: must_be_immutable
class OwnFileCard extends StatelessWidget {
  OwnFileCard({
    super.key,
    required this.path,
    required this.message,
    required this.time,
    this.emojiReaction,
    required this.messageStatus,
  });

  final String path; // File path
  final String message; // Message content
  final String time;
  String? emojiReaction;
  final MessageStatus messageStatus;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: InkWell(
          onTap: () {
            // Navigate to the PhotoViewPage to display the full image
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PhotoViewPage(imagePath: path),
              ),
            );
          },
          child: Container(
            height: MediaQuery.of(context).size.height / 2.3,
            width: MediaQuery.of(context).size.width / 2.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.teal[400],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Card(
                  margin: const EdgeInsets.all(3),
                  color: Colors.teal[400],
                  semanticContainer: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Image.file(

                          File(
                              path), // Use the local file directly since the sender already has it
                          fit: BoxFit.cover,
                        ),
                      ),
                      message.isNotEmpty
                          ? Container(
                              height: 40,
                              padding: const EdgeInsets.only(
                                left: 15,
                                top: 8,
                              ),
                              child: Text(
                                message,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      // const Icon(
                      //   Icons.done_all,
                      //   size: 20,
                      // ),
                      _buildStatusIcon(messageStatus),
                    ],
                  ),
                ),
                Visibility(
                  visible: emojiReaction != null,
                  child: Positioned(
                      top: 350,
                      right: 10,
                      child: Text(
                        emojiReaction ?? "",
                        style: const TextStyle(fontSize: 17),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.notSent:
        return const Icon(Icons.access_time, size: 20, color: Colors.grey);
      case MessageStatus.sent:
        return const Icon(Icons.check, size: 20, color: Colors.grey);
      case MessageStatus.delivered:
        return const Icon(Icons.done_all, size: 20, color: Colors.grey);
      case MessageStatus.read:
        return const Icon(Icons.done_all, size: 20, color: Colors.blue);
      }
  }
}
