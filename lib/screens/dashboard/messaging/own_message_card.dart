import 'dart:developer';

import 'package:flutter/material.dart';

enum MessageStatus { notSent, sent, delivered, read }

class OwnMessageCard extends StatefulWidget {
  OwnMessageCard({
    super.key,
    required this.message,
    required this.time,
    this.emojiReaction,
    required this.messageStatus,
  });
  final String message;
  final String time;
  String? emojiReaction;
  final MessageStatus messageStatus;

  @override
  _OwnMessageCardState createState() => _OwnMessageCardState();
}

class _OwnMessageCardState extends State<OwnMessageCard> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: const Color(0xffdcf8c6),
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 60, top: 10, bottom: 20),
                      child: Text(
                        widget.message,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 10,
                      child: Row(
                        children: [
                          Text(
                            widget.time,
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
                          _buildStatusIcon(widget.messageStatus),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Visibility(
                visible: widget.emojiReaction != null,
                child: Positioned(
                    top: 50,
                    right: 10,
                    child: Text(
                      widget.emojiReaction ?? "",
                      style: const TextStyle(fontSize: 17),
                    )),
              ),
              // Positioned(
              //     left: 5,
              //     top: 10,
              //     child: IconButton(
              //         onPressed: () {},
              //         icon: Icon(
              //           Icons.forward,
              //           color: Colors.grey,
              //           size: 20,
              //         )))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(MessageStatus status) {
    // log(status.toString(), name: "Message Status from Own Message card.");
    switch (status) {
      case MessageStatus.notSent:
        return const Icon(Icons.access_time, size: 20, color: Colors.grey);
      case MessageStatus.sent:
        return const Icon(Icons.check, size: 20, color: Colors.grey);
      case MessageStatus.delivered:
        return const Icon(Icons.done_all, size: 20, color: Colors.grey);
      case MessageStatus.read:
        return const Icon(Icons.done_all, size: 20, color: Colors.blue);
      default:
        return const SizedBox.shrink();
    }
  }
}
