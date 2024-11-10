import 'package:flutter/material.dart';
import 'package:task_manager/ui/screen/cancelled_task_screen.dart';
import 'package:task_manager/ui/screen/completed_task_screen.dart';
import 'package:task_manager/ui/screen/new_task_screen.dart';
import 'package:task_manager/ui/screen/progress_task_screen.dart';
import '../widgets/tm_app_bar.dart';

class MainBottomNabBarScreen extends StatefulWidget {
  const MainBottomNabBarScreen({super.key});

  @override
  State<MainBottomNabBarScreen> createState() => _MainBottomNabBarScreenState();
}

class _MainBottomNabBarScreenState extends State<MainBottomNabBarScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = const [
    NewTaskScreen(),
    CompletedTaskScreen(),
    CancelledTaskScreen(),
    ProgressTaskScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          _selectedIndex = index;
          setState(() {});
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.new_label), label: 'new'),
          NavigationDestination(
              icon: Icon(Icons.check_box), label: 'completed'),
          NavigationDestination(icon: Icon(Icons.close), label: 'cancelled'),
          NavigationDestination(
              icon: Icon(Icons.access_time), label: 'progress'),
        ],
      ),
    );
  }
}
