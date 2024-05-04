import 'dart:math';
// import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
// import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:lawlink_lawyer/utils/session.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LawyerHomeScaffold extends StatefulWidget {
  const LawyerHomeScaffold({super.key, this.child});

  final Widget? child;

  @override
  // ignore: library_private_types_in_public_api
  _LawyerHomeScaffoldState createState() => _LawyerHomeScaffoldState();
}

class _LawyerHomeScaffoldState extends State<LawyerHomeScaffold> {
  Map<String, String> userData = {};
  final supabase = Supabase.instance.client;
  //int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final data = await SessionManagement.getUserData();
    setState(() {
      userData = data;
    });
  }

  void removeUserData() async {
    await SessionManagement.clearUserData();
  }

  Color getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 3,
        bottom:
            const PreferredSize(preferredSize: Size(10, 10), child: Column()),
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(10)),
        shadowColor: Colors.grey,
        title: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: getRandomColor(),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/home');
                },
                child: Text(
                  userData['name'] != null && userData['name']!.isNotEmpty
                        ? '${userData['name']}'[0].toUpperCase()
                        : '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10), // Space between avatar and text
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
              child: Text(
                'Hi, ${userData['name']}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 5.0, top: 3),
            child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/chat_history');
                },
                icon: const Icon(Icons.chat_outlined),
                iconSize: 30),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, top: 3),
            child: IconButton(
                onPressed: () {
                  // Navigator.pushNamed(context, '/chat_history');
                  Navigator.pushNamed(context, '/manage_cases', arguments: {
                    'clientId': '0d155888-2cec-4b49-80bd-dd52c5a1888e',
                    'clientName': 'Aswin P'
                  });
                },
                icon: const Icon(Icons.manage_accounts),
                iconSize: 30),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 4, top: 3),
            child: IconButton(
                onPressed: () {
                  supabase.auth.signOut();
                  removeUserData();
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                },
                icon: const Icon(Icons.logout),
                iconSize: 30),
          )
        ],
      ),
      // bottomNavigationBar: CurvedNavigationBar(
      //   backgroundColor: Colors.blue,
      //   index: _selectedIndex,
      //   items: const [
      //     CurvedNavigationBarItem(
      //       child: Icon(Icons.home_outlined),
      //       label: 'Home',
      //     ),
      //     CurvedNavigationBarItem(
      //       child: Icon(Icons.group),
      //       label: 'Cases',
      //     ),
      //     CurvedNavigationBarItem(
      //       child: Icon(Icons.newspaper_outlined),
      //       label: 'News',
      //     ),
      //     CurvedNavigationBarItem(
      //       child: Icon(Icons.group),
      //       label: 'Athletes',
      //     ),
      //     CurvedNavigationBarItem(
      //       child: Icon(Icons.person),
      //       label: 'Profile',
      //     ),
      //   ],
      //   onTap: (index) {
      //     _onItemTapped(index);
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/chatbot');
          },
          backgroundColor: const Color.fromARGB(255, 19, 94, 155),
          tooltip: "Talk to bot",
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          child: const Icon(
            Icons.sms,
            color: Colors.white,
            size: 26,
          )),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SafeArea(
            child: widget.child!,
          )
        ],
      ),
    );
  }
}
