import 'dart:io';

import 'package:flutter/material.dart';
class Messaging extends StatefulWidget {
  const Messaging({super.key});

  @override
  State<Messaging> createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {

  
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, __) {
        return (Platform.isAndroid && __ == Orientation.portrait)
            ? buildMessageScreenForPortrait()
            : buildMessageScreenForLandscape();
      },
    );
  }

  Widget buildMessageScreenForLandscape(){
    return Row(
              children: [
                // Left Sidebar
                Container(
                  width: 250,
                  color: const Color(0xFF242424),
                  child: Column(
                    children: [
                      // Sidebar Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: const Row(
                          children: [
                            Text(
                              'Team Chat',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            Icon(Icons.expand_more, color: Colors.white),
                          ],
                        ),
                      ),
                      // Sidebar Items
                      ListTile(
                        leading: const Icon(
                          Icons.alternate_email,
                          color: Colors.white70,
                        ),
                        title: const Text(
                          'Mentions',
                          style: TextStyle(color: Colors.white70),
                        ),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.star_border,
                          color: Colors.white70,
                        ),
                        title: const Text(
                          'Starred',
                          style: TextStyle(color: Colors.white70),
                        ),
                        onTap: () {},
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          'Chats and Channels',
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ),
                      // Add more chat items here
                    ],
                  ),
                ),
                // Main Chat Area
                Expanded(
                  child: Column(
                    children: [
                      // Chat Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 0.5),
                          ),
                        ),
                        child: const Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text('H'),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'General',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Chat Messages Area
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          child: const Center(
                            child: Text('Chat messages will appear here'),
                          ),
                        ),
                      ),
                      // Message Input
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey, width: 0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: "What's on your mind",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.send),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
  }

  Widget buildMessageScreenForPortrait() {
    return Scaffold();
  }
}
