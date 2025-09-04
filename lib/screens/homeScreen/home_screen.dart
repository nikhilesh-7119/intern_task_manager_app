import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/controller/db_controller.dart';
import 'package:task_manager_app/screens/homeScreen/widgets/task_list.dart';
import 'package:task_manager_app/screens/homeScreen/widgets/task_editor_sheet.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final DbController db = Get.put(DbController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Icon(Icons.task_alt),
        ),
        centerTitle: true,
        title: const Text('Tasks'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showTaskEditorBottomSheet(context),
        child: const Icon(Icons.add),
      ),
      body: const TaskList(),
    );
  }
}
