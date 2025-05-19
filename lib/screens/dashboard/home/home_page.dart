import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Center(
        child: Container(
          height: 320,
          width: 320,
          child: Center(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                buildNewMeetingWidget(),
                buildJoinMeetingWidget()
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget buildNewMeetingWidget() {
  return IconButton.filled(
    onPressed: () {},
    icon: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.video_call, color: Colors.white, size: 30),
        Text(
          'New Meeting',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    ),
    style: IconButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 219, 96, 35),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    ),
  );
}

Widget buildJoinMeetingWidget() {
 return IconButton.filled(
    onPressed: () {},
    icon: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_box_rounded, color: Colors.white, size: 30),
        Text(
          'Join Meeting',
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    ),
    style: IconButton.styleFrom(
      backgroundColor: Colors.blue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    ),
  );
}
