import 'package:flutter/material.dart';

class ReplyCard extends StatefulWidget {
  ReplyCard(
      {super.key,
      required this.message,
      required this.time,
      this.emojiReaction});
  final String message;
  final String time;
  String? emojiReaction;

  @override
  _ReplyCardState createState() => _ReplyCardState();
}

class _ReplyCardState extends State<ReplyCard> {
  String? selectedEmoji;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
